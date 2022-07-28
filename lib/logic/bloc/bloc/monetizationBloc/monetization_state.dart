import 'dart:convert';

import 'package:equatable/equatable.dart';

class MonetizationState extends Equatable {
  bool isPurchased = false;
  bool isAppAvailableToBuy;
  List purchases;
  List products;
  MonetizationState(
    this.isPurchased,
    this.isAppAvailableToBuy,
    this.purchases,
    this.products,
  );

  MonetizationState copyWith({
    bool? isPurchased,
    bool? isAppAvailableToBuy,
    List? purchases,
    List? products,
  }) {
    return MonetizationState(
      isPurchased ?? this.isPurchased,
      isAppAvailableToBuy ?? this.isAppAvailableToBuy,
      purchases ?? this.purchases,
      products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isPurchased': isPurchased,
      'isAppAvailableToBuy': isAppAvailableToBuy,
      'purchases': purchases,
      'products': products,
    };
  }

  factory MonetizationState.fromMap(Map<String, dynamic> map) {
    return MonetizationState(
      map['isPurchased'] ?? false,
      map['isAppAvailableToBuy'] ?? false,
      List.from(map['purchases']),
      List.from(map['products']),
    );
  }

  @override
  String toString() {
    return 'MonetizationState(isPurchased: $isPurchased, isAppAvailableToBuy: $isAppAvailableToBuy, purchases: $purchases, products: $products)';
  }

  @override
  List<Object> get props =>
      [isPurchased, isAppAvailableToBuy, purchases, products];

  String toJson() => json.encode(toMap());

  factory MonetizationState.fromJson(String source) =>
      MonetizationState.fromMap(json.decode(source));
}

class MonetizationInitial extends MonetizationState {
  MonetizationInitial() : super(false, true, [], []);
}
