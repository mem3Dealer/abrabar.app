part of 'monetization_bloc.dart';

abstract class MonetizationEvent {
  const MonetizationEvent();
}

class MonetizationInit extends MonetizationEvent {}

class MonetizationPurchase extends MonetizationEvent {
  BuildContext context;
  MonetizationPurchase(this.context);
}

class RestorePurchases extends MonetizationEvent {
  BuildContext context;
  RestorePurchases(this.context);
}
