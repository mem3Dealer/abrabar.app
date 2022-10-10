import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localz.dart';
import 'package:abrabar/logic/bloc/bloc/monetizationBloc/monetization_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../shared/theme.dart';
import '../../../services/analytic_service.dart';

part 'monetization_event.dart';

class MonetizationBloc extends Bloc<MonetizationEvent, MonetizationState> {
  MonetizationBloc() : super(MonetizationInitial()) {
    on<MonetizationPurchase>(_onMonetizationPurchase);
    on<MonetizationInit>(_onMonetizationInit);
    on<RestorePurchases>(_onRestorePurchase);
  }
  final anal = GetIt.I.get<AnalyticsService>();
  InAppPurchase iap = InAppPurchase.instance;
  final String productId = 'upgrade_full_access';
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  late bool isStoreAvailable;
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  // var paymentWrapper = SKPaymentQueueWrapper();

  Future<void> _onMonetizationPurchase(
      MonetizationPurchase event, Emitter emitter) async {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: state.products.first);

    await iap.buyNonConsumable(purchaseParam: purchaseParam);

    anal.buyApp(state.actualPrice, state.basePrice,
        purchaseParam.productDetails.currencySymbol);
    if (state.isPurchased) {
      Navigator.of(event.context).pop();
    }
  }

  FutureOr<void> _onMonetizationInit(
      MonetizationInit event, Emitter emitter) async {
    await _wasAppPurchased();
    bool available = await iap.isAvailable();
    emitter(state.copyWith(isAppAvailableToBuy: available));
    if (available && state.isPurchased == false) {
      await _getProducts();
      // await _getPastPurchases();

      // print("$available, ${state.isPurchased}");
      final Stream<List<PurchaseDetails>> purchaseUpdated = iap.purchaseStream;

      _subscription = purchaseUpdated.listen(
          (List<PurchaseDetails> purchaseDetailsList) async {
        log('stream of purchases initiatied');
        await _listenToPurchaseUpdated(purchaseDetailsList, emitter);
      }, onDone: () {
        _subscription.cancel();
      }, onError: (Object error) {
        log(error.toString());
      });
    }
  }

  Future<void> _wasAppPurchased() async {
    var readVal = await storage.read(key: "wasPurchased");

    if (readVal == 'true') {
      if (state.isPurchased == false) {
        emit(state.copyWith(isPurchased: true));
      } else {
        emit(state.copyWith(isPurchased: false));
      }
    }
  }

  void dispose() {
    _subscription.cancel();
  }

  Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
    Emitter emitter,
  ) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _handlePendingPurchases();
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        await _handleCancelledPurchases(purchaseDetails);
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _handleErrorPurchase(purchaseDetails, emitter);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            await storage.write(key: 'wasPurchased', value: 'true');
            emit(state.copyWith(
                isPurchased: true, isTherePendingPurchase: false));
          } else {
            return;
          }
        } else if (purchaseDetails.status == PurchaseStatus.restored) {
          log('There is restored purchase');
          state.purchases.add(purchaseDetails);
          emit(state.copyWith(purchases: state.purchases));
        }
        try {
          if (purchaseDetails.pendingCompletePurchase) {
            await iap.completePurchase(purchaseDetails);
            anal.purchaseSuccess(state.actualPrice, state.basePrice);
          }
        } on Exception catch (e) {
          log(e.toString());
        }
      }
    }
  }

  Future<void> _handleCancelledPurchases(PurchaseDetails details) async {
    log('purchase has CANCELLED status');
    anal.purchaseFailure();
    await iap.completePurchase(details);
    emit(state.copyWith(isTherePendingPurchase: false));
  }

  void _handlePendingPurchases() {
    log('purchase has PENDING status');
    emit(state.copyWith(isTherePendingPurchase: true));
  }

  FutureOr<void> _handleErrorPurchase(
      PurchaseDetails purchaseDetails, Emitter emitter) async {
    final Map<String, dynamic> errorMap =
        Map.from(purchaseDetails.error?.details);
    final reason = errorMap["NSUnderlyingError"]["userInfo"]
        ["NSUnderlyingError"]["userInfo"]["NSLocalizedFailureReason"];

    //TODO не все ошибки отрабатывает. К примеру - ошибка аутентификации
    // log('THERE IS FOOKIN ERROR, ${purchaseDetails.error}');
    if (purchaseDetails.error?.message == 'BillingResponse.itemAlreadyOwned') {
      await storage.write(key: 'wasPurchased', value: 'true');
      emit(state.copyWith(isPurchased: true));
    } else if (reason == 'The authentication failed.') {
      emit(state.copyWith(isTherePendingPurchase: false));
      SnackBar snackBar = const SnackBar(
        content: Text(
          'Store authentication failed, please try again.',
          style: TextStyle(color: Color(0xffFFBE3F)),
        ),
        backgroundColor: Color(0xff242320),
      );
      snackbarKey.currentState?.showSnackBar(snackBar);
      anal.purchaseFailure();
    } else {
      log('there is some other error occured. ${purchaseDetails.error?.details}');
      anal.purchaseFailure();
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails? purchase) async {
    //TODO запилить верификацию покупок?
    return true;
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from([productId]);
    ProductDetailsResponse response = await iap.queryProductDetails(ids);
    print(response.productDetails.first);
    if (response.productDetails.isEmpty) {
      log('THERE ARE NO PRODUCTS');
    }
    emit(state.copyWith(products: response.productDetails));
    ProductDetails product = state.products.first;
    //TODO
    //Нужно разобраться как будут работать скидки, чтобы это делать нормально
    emit(state.copyWith(
        actualPrice: product.rawPrice, basePrice: product.rawPrice));
  }

  // Future<void> _getPastPurchases() async {
  //   // print(await iap.purchaseStream.first);
  //   // print(await iap.restorePurchases().toString());
  //   await iap.restorePurchases().then((value) => print('wtf'));
  //   print('???');
  // }

  Future<void> internetCheckUp() async {
    bool isThereInternet = true;
    bool available = await iap.isAvailable();
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isThereInternet = true;
      }
    } on SocketException catch (_) {
      isThereInternet = false;
    }

    if (isThereInternet == true && available == true) {
      emit(state.copyWith(isAppAvailableToBuy: true));
    } else {
      emit(state.copyWith(isAppAvailableToBuy: false));
    }
  }

  Future<void> _onRestorePurchase(
      RestorePurchases event, Emitter emitter) async {
    var t = AppLocalizations.of(event.context)!;
    bool isTherePurchases = state.purchases.isNotEmpty;
    if (isTherePurchases) {
      emitter(state.copyWith(isTherePendingPurchase: true));
      await iap.completePurchase(state.purchases.first).then((_) => emitter(
          state.copyWith(isTherePendingPurchase: false, isPurchased: true)));
      storage.write(key: 'wasPurchased', value: 'true');
    } else {
      ScaffoldMessenger.of(event.context).showSnackBar(SnackBar(
        content: Text(
          t.noPurchases,
          style: const TextStyle(color: const Color(0xffFFBE3F)),
        ),
        backgroundColor: const Color(0xff242320),
      ));
    }
  }
}
