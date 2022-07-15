import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../../services/analytic_service.dart';

part 'monetization_event.dart';
part 'monetization_state.dart';

class MonetizationBloc extends Bloc<MonetizationEvent, MonetizationState> {
  MonetizationBloc() : super(MonetizationInitial(false)) {
    on<MonetizationPurchase>(_onMonetizationPurchase);
  }
  final anal = GetIt.I.get<AnalyticsService>();

  Future<void> _onMonetizationPurchase(
      MonetizationPurchase event, Emitter emitter) async {
    anal.buyApp(999, 888);
    emitter(state.copyWith(isPurchased: true));
  }
}
