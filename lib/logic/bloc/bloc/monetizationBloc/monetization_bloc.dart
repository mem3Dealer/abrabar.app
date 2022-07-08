import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'monetization_event.dart';
part 'monetization_state.dart';

class MonetizationBloc extends Bloc<MonetizationEvent, MonetizationState> {
  MonetizationBloc() : super(MonetizationInitial(false)) {
    on<MonetizationPurchase>(_onMonetizationPurchase);
  }

  Future<void> _onMonetizationPurchase(
      MonetizationPurchase event, Emitter emitter) async {
    emitter(state.copyWith(isPurchased: true));
  }
}
