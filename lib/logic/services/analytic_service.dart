import 'package:abrabar/logic/coctail.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

class AnalyticsService {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FlutterBranchSdk branch = FlutterBranchSdk();

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: analytics);

  Future<void> star(Coctail coc) async {
    analytics.logEvent(name: 'star', parameters: {"item": coc.name});
  }

  Future<void> unstar(Coctail coc) async {
    analytics.logEvent(name: 'unstar', parameters: {"item": coc.name});
  }

  Future<void> search(String query) async {
    analytics.logEvent(name: 'search', parameters: {"query": query});
  }

  Future<void> stepChanged(
      {required bool isForward,
      required String name,
      required int stepNum,
      required int totalSteps}) async {
    analytics.logEvent(
        name: isForward ? "step_forward" : "step_back",
        parameters: {
          "item": name,
          "step_num": stepNum,
          "total_steps": totalSteps
        });
  }

  Future<void> howToCook(Coctail coctail) async {
    analytics.logEvent(name: 'how_to_cook', parameters: {'item': coctail.name});
  }

  Future<void> readIngredients(Coctail coctail) async {
    analytics
        .logEvent(name: 'read_ingridients', parameters: {'item': coctail.name});
  }

  Future<void> selectItem(
      Coctail coctail, String? collectionName, String setName) async {
    analytics.logEvent(name: 'select_item', parameters: {
      'item': coctail.name,
      "collection": collectionName,
      "set": setName,
    });
  }

  Future<void> selectSet(String setName, String collectionName) async {
    analytics.logEvent(
        name: 'select_set',
        parameters: {'collection': collectionName, 'set': setName});
  }

  Future<void> changeCollection(String target) async {
    analytics
        .logEvent(name: 'change_collection', parameters: {'target': target});
  }

  Future<void> purchaseSuccess(num actualPrice, num basePice) async {
    analytics.logEvent(
        name: 'purchase_success',
        parameters: {'base_price': basePice, 'actual_price': actualPrice});
  }

  Future<void> purchaseFailure() async {
    analytics.logEvent(name: 'purchase_faulure');
  }

  Future<void> buyApp(
      num actualPrice, num basePice, String currencySymbol) async {
    BranchEvent eventCustom = BranchEvent.customEvent('buy_app');
    eventCustom.addCustomData('base_price', basePice.toString());
    eventCustom.addCustomData('actual_price', actualPrice.toString());

    FlutterBranchSdk.trackContentWithoutBuo(branchEvent: eventCustom);
    analytics.logEvent(name: 'buy_app', parameters: {
      'base_price': basePice,
      'actual_price': actualPrice,
      "currency_Symbol": currencySymbol
    }).then((value) => print(currencySymbol));
  }

  Future<void> paywallOpened(
      {required String fromWhere,
      required int basePrice,
      required int actualPrice}) async {
    analytics.logEvent(name: 'paywall_opened', parameters: {
      'fromWhere': fromWhere,
      'base_price': basePrice,
      'actual_price': actualPrice
    });
  }

  Future<void> onboardSwipe({required int index}) async {
    // print(index);
    analytics.logEvent(name: 'onb_$index', parameters: {});
  }
}
