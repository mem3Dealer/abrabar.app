part of 'monetization_bloc.dart';

class MonetizationState extends Equatable {
  bool isPurchased = false;
  MonetizationState(
    this.isPurchased,
  );

  MonetizationState copyWith({
    bool? isPurchased,
  }) {
    return MonetizationState(
      isPurchased ?? this.isPurchased,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isPurchased': isPurchased,
    };
  }

  factory MonetizationState.fromMap(Map<String, dynamic> map) {
    return MonetizationState(
      map['isPurchased'] ?? false,
    );
  }

  @override
  String toString() => 'MonetizationState(isPurchased: $isPurchased)';

  @override
  List<Object> get props => [isPurchased];
}

class MonetizationInitial extends MonetizationState {
  MonetizationInitial(super.isPurchased);
}
