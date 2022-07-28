import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:abrabar/logic/bloc/bloc/monetizationBloc/monetization_state.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
  final String productId = 'test_purchase1';
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  late bool isStoreAvailable;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> _onMonetizationPurchase(
      MonetizationPurchase event, Emitter emitter) async {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: state.products.first);

    await iap.buyNonConsumable(purchaseParam: purchaseParam);
    anal.buyApp(
        purchaseParam.productDetails.rawPrice,
        purchaseParam.productDetails.rawPrice,
        purchaseParam.productDetails.currencySymbol);
  }

  FutureOr<void> _onMonetizationInit(
      MonetizationInit event, Emitter emitter) async {
    await _wasAppPurchased();
    bool available = await iap.isAvailable();
    if (available && state.isPurchased == false) {
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
    if (await storage.containsKey(key: 'wasPurchased')) {
      if (state.isPurchased == false) {
        emit(state.copyWith(isPurchased: true));
      }
    }
  }

  void dispose() {
    _subscription.cancel();
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList, Emitter emitter) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        log('purchase has PENDING status');
        // showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          log('THERE IS FOOKIN ERROR, ${purchaseDetails.error}');
          _handleErrorPurchase(purchaseDetails, emitter);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            await storage.write(
                key: 'wasPurchased', value: purchaseDetails.purchaseID);
            emit(state.copyWith(isPurchased: true));
          } else {
            return;
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await iap.completePurchase(purchaseDetails);
        }
      }
    }
  }

  FutureOr<void> _handleErrorPurchase(
      PurchaseDetails purchaseDetails, Emitter emitter) async {
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

    // PurchaseDetails? purchase = hasPurchased(productId);
    // purchase ??= _hasPurchased(productId);
    // log(purchase!.status.toString());
    // if (purchase != null) {
    //   if (purchase.pendingCompletePurchase ||
    //       purchase.status == PurchaseStatus.purchased ||
    //       purchase.status == PurchaseStatus.restored) {
    //     log('DO WE EVEN GET HERE?');
    //     await iap.completePurchase(purchase).then((value) => print(
    //         'PURCHASE COMPLETED ${purchase?.purchaseID},$purchase, ${purchase?.verificationData}'));
    //     emit(state.copyWith(isPurchased: true));
    //     log('HERE?...');
    //   }
    // } else {
    //   log('no purchase');
    // }
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
  }
}
