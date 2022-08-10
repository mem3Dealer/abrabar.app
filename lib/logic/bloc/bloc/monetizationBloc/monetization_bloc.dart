import 'dart:async';
import 'dart:developer';
import 'dart:io';
// import 'package:in_app_purchase_ios/store_kit_wrappers.dart';
import 'package:abrabar/logic/bloc/bloc/monetizationBloc/monetization_state.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../services/analytic_service.dart';

part 'monetization_event.dart';

class MonetizationBloc extends Bloc<MonetizationEvent, MonetizationState> {
  MonetizationBloc() : super(MonetizationInitial()) {
    on<MonetizationPurchase>(_onMonetizationPurchase);
    on<MonetizationInit>(_onMonetizationInit);
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

    anal.buyApp(
        purchaseParam.productDetails.rawPrice,
        purchaseParam.productDetails.rawPrice,
        purchaseParam.productDetails.currencySymbol);
    if (state.isPurchased) {
      Navigator.of(event.context).pop();
    }
  }

  FutureOr<void> _onMonetizationInit(
      MonetizationInit event, Emitter emitter) async {
    // await _wasAppPurchased();
    bool available = await iap.isAvailable();
    // emitter(state.copyWith(isAppAvailableToBuy: available));

    if (available && state.isPurchased == false) {
      // await _wasAppPurchased();
      await _getProducts();
      await _getPastPurchases();
      final Stream<List<PurchaseDetails>> purchaseUpdated = iap.purchaseStream;
      _subscription = purchaseUpdated.listen(
          (List<PurchaseDetails> purchaseDetailsList) async {
        log('stream of purchases initiatied');
        await _listenToPurchaseUpdated(purchaseDetailsList, emitter);
      }, onDone: () {
        _subscription.cancel();
      }, onError: (Object error) {
        // handle error here.
      });
    }
  }

  Future<void> _wasAppPurchased() async {
    var readVal = await storage.read(key: "wasPurchased");
    if (readVal == 'true') {
      if (state.isPurchased == false) {
        emit(state.copyWith(isPurchased: true));
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
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            // await storage.write(
            //     key: 'wasPurchased', value: purchaseDetails.purchaseID);
            // emit(state.copyWith(
            //     isPurchased: true, isTherePendingPurchase: false));
          } else {
            return;
          }
        }
        try {
          if (purchaseDetails.pendingCompletePurchase) {
            await iap.completePurchase(purchaseDetails);
          }
        } on Exception catch (e) {
          log(e.toString());
        }
      }
    }
  }

  Future<void> _handleCancelledPurchases(PurchaseDetails details) async {
    log('purchase has CANCELLED status');
    // var transactions = await paymentWrapper.transactions();
    // transactions.forEach((transaction) async {
    //   await paymentWrapper.finishTransaction(transaction);
    // });
    await iap.completePurchase(details);
    emit(state.copyWith(isTherePendingPurchase: false));
  }

  void _handlePendingPurchases() {
    log('purchase has PENDING status');
    emit(state.copyWith(isTherePendingPurchase: true));
  }

  FutureOr<void> _handleErrorPurchase(
      PurchaseDetails purchaseDetails, Emitter emitter) async {
    log('THERE IS FOOKIN ERROR, ${purchaseDetails.error}');
    if (purchaseDetails.error?.message == 'BillingResponse.itemAlreadyOwned') {
      await storage.write(
          key: 'wasPurchased', value: purchaseDetails.purchaseID);
      emit(state.copyWith(isPurchased: true));
    } else {
      log('there is some other error occured. ${purchaseDetails.error}');
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails? purchase) async {
    //TODO запилить верификацию покупок?

    return true;
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from([productId]);
    ProductDetailsResponse response = await iap.queryProductDetails(ids);
    if (response.productDetails.isEmpty) {
      log('THERE ARE NO PRODUCTS');
    }
    emit(state.copyWith(products: response.productDetails));
  }

  Future<void> _getPastPurchases() async {
    await iap.restorePurchases();
    // var transactions = await paymentWrapper.transactions();
    // transactions.forEach((transaction) async {
    //   await paymentWrapper.finishTransaction(transaction);
    // });
  }

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
}
