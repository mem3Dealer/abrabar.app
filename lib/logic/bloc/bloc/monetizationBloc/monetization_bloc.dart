import 'dart:async';

import 'package:abrabar/logic/bloc/bloc/monetizationBloc/monetization_state.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
  final String productId = 'test_purchase';
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  Future<void> _onMonetizationPurchase(
      MonetizationPurchase event, Emitter emitter) async {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: state.products.first);
    iap.buyNonConsumable(purchaseParam: purchaseParam);

    anal.buyApp(999, 888);
    emitter(state.copyWith(isPurchased: true));
  }

  Future<void> _onMonetizationInit(
      MonetizationInit event, Emitter emitter) async {
    bool available = await iap.isAvailable();
    if (available) {
      await _getProducts();
      await _getPastPurchases();
      verifyPurchase();
      _subscription = iap.purchaseStream.listen((event) {
        state.purchases.addAll(event);
        emitter(state.copyWith(purchases: state.purchases));
        verifyPurchase();
      });
    }
  }

  void verifyPurchase() {
    PurchaseDetails? purchase = hasPurchased(productId);
    if (purchase != null && purchase.pendingCompletePurchase) {
      iap.completePurchase(purchase);
      emit(state.copyWith(isPurchased: true));
    }
  }

  PurchaseDetails hasPurchased(String id) {
    return state.purchases.firstWhere((purchase) => purchase.productID == id);
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from([productId]);
    ProductDetailsResponse response = await iap.queryProductDetails(ids);
    emit(state.copyWith(products: response.productDetails));
    // products = response.productDetails;
    // print(response);
  }

  Future<void> _getPastPurchases() async {
    iap.restorePurchases();
  }
}
