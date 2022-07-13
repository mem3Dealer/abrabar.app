import 'package:abrabar/logic/coctail.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: analytics);

  Future<void> star(Coctail coc) async {
    analytics.logEvent(name: 'star', parameters: {"item": coc.name});
  }

  Future<void> search(String query) async {
    analytics.logEvent(name: 'search', parameters: {"query": query});
  }

  Future<void> stepChanged(bool isForward,
      {required String name,
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

  //TBD
  Future<void> selectItem(Coctail coctail, String? collectionName) async {
    analytics.logEvent(name: 'select_item', parameters: {
      'item': coctail.name,
      "collection": collectionName,
      "set": '',
    });
  }

  //TBD
  Future<void> selectSet(String setName) async {
    analytics.logEvent(
        name: 'select_set', parameters: {'collection': '', 'set': setName});
  }

  Future<void> changeCollection(String target) async {
    analytics
        .logEvent(name: 'change_collection', parameters: {'target': target});
  }

//TBD
  Future<void> purchaseSuccess(num actualPrice, num basePice) async {
    analytics.logEvent(
        name: 'purchase_success',
        parameters: {'base_price': basePice, 'actual_price': actualPrice});
  }

//TBD
  Future<void> purchaseFailure() async {
    analytics.logEvent(name: 'purchase_faulure');
  }

//TBD
  Future<void> buyApp(num actualPrice, num basePice) async {
    analytics.logEvent(
        name: 'buy_app',
        parameters: {'base_price': basePice, 'actual_price': actualPrice});
  }
}
