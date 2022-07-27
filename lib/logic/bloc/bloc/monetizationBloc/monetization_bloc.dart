import 'dart:async';
import 'dart:developer';

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
    await iap.buyNonConsumable(purchaseParam: purchaseParam).then((value) {
      anal.buyApp(999, 888);
      emitter(state.copyWith(isPurchased: true));
    });
  }

  FutureOr<void> _onMonetizationInit(
      MonetizationInit event, Emitter emitter) async {
    bool available = await iap.isAvailable();
    if (available) {
      await _getProducts();
      await _getPastPurchases();
      await verifyPurchase(null);

      _subscription = iap.purchaseStream.listen((purchases) async {
        purchases.forEach((element) async {
          log("THIS IS PURCHASE status IN STREAM " + element.status.toString());
          await verifyPurchase(element);
        });
        state.purchases.addAll(purchases);
        emitter(state.copyWith(purchases: state.purchases));
      });
    }
  }

  Future<void> verifyPurchase(PurchaseDetails? purchase) async {
    // PurchaseDetails? purchase = hasPurchased(productId);
    print(purchase.toString());
    purchase ??= hasPurchased(productId);
    if (purchase != null) {
      if (purchase.pendingCompletePurchase ||
          purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.error) {
        log('DO WE EVEN GET HERE?');
        await iap.completePurchase(purchase).then((value) => print(
            'PURCHASE COMPLETED ${purchase?.purchaseID},' +
                purchase.toString()));
        emit(state.copyWith(isPurchased: true));
        log('HERE?...');
      }
    } else {
      log('no purchase, null');
    }
  }

  PurchaseDetails? hasPurchased(String id) {
    if (state.purchases.isNotEmpty) {
      log('PURCHASES WERE NOT EMPTY');
      state.purchases.firstWhere(
        (purchase) => purchase.productID == id,
      );
    } else {
      return null;
    }
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from([productId]);
    ProductDetailsResponse response = await iap.queryProductDetails(ids);
    emit(state.copyWith(products: response.productDetails));
  }

  Future<void> _getPastPurchases() async {
    await iap.restorePurchases();
    log('RESTORE CALLED');
  }
}
