import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseService {
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  InAppPurchase iap = InAppPurchase.instance;
  bool isAvailable = true;
  final String productId = 'test_purchase';

  bool _isPurchased = false;
  bool get isPurchased => _isPurchased;
  set isPurchased(bool value) {
    _isPurchased = value;
  }

  List _purchases = [];
  List get purchases => _purchases;
  set purchases(List value) {
    _purchases = value;
  }

  List _products = [];
  List get products => _purchases;
  set products(List value) {
    _purchases = value;
  }

  Future<void> initListeningToPurchases() async {
    bool available = await iap.isAvailable();
    if (available) {
      await _getProducts();
      // await _getPastPurchases();
      verifyPurchase();
//
      _subscription = iap.purchaseStream.listen((event) {
        purchases.addAll(event);
        verifyPurchase();
      });
    }
  }

  void verifyPurchase() {
    PurchaseDetails? purchase = hasPurchased(productId);
    if (purchase != null && purchase.pendingCompletePurchase) {
      iap.completePurchase(purchase);
      isPurchased = true;
    }
  }

  PurchaseDetails hasPurchased(String id) {
    return purchases.firstWhere((purchase) => purchase.productID == id);
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from([productId]);
    ProductDetailsResponse response = await iap.queryProductDetails(ids);
    products = response.productDetails;
    // print(response);
  }

  Future<void> _getPastPurchases() async {
    iap.restorePurchases();
  }
}
