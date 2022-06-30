import 'package:abrabar/logic/coctail.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: analytics);

  Future<void> sendSelectedCoctail(Coctail coc) async {
    analytics.logEvent(name: 'cock_opened', parameters: {"name": coc.name});
    print('anal sent');
  }
}
