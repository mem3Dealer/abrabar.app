// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class MonetizationState extends Equatable {
  bool isPurchased = false;
  bool isAppAvailableToBuy;
  bool isTherePendingPurchase = false;
  List purchases;
  List products;
  MonetizationState(
    this.isPurchased,
    this.isAppAvailableToBuy,
    this.isTherePendingPurchase,
    this.purchases,
    this.products,
  );

  MonetizationState copyWith({
    bool? isPurchased,
    bool? isAppAvailableToBuy,
    bool? isTherePendingPurchase,
    List? purchases,
    List? products,
  }) {
    return MonetizationState(
      isPurchased ?? this.isPurchased,
      isAppAvailableToBuy ?? this.isAppAvailableToBuy,
      isTherePendingPurchase ?? this.isTherePendingPurchase,
      purchases ?? this.purchases,
      products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isPurchased': isPurchased,
      'isAppAvailableToBuy': isAppAvailableToBuy,
      'isTherePendingPurchase': isTherePendingPurchase,
      'purchases': purchases,
      'products': products,
    };
  }

  @override
  String toString() {
    return 'MonetizationState(isPurchased: $isPurchased, isAppAvailableToBuy: $isAppAvailableToBuy, purchases: $purchases, products: $products)';
  }

  @override
  List<Object> get props {
    return [
      isPurchased,
      isAppAvailableToBuy,
      isTherePendingPurchase,
      purchases,
      products,
    ];
  }

  String toJson() => json.encode(toMap());

  factory MonetizationState.fromJson(String source) =>
      MonetizationState.fromMap(json.decode(source) as Map<String, dynamic>);

  factory MonetizationState.fromMap(Map<String, dynamic> map) {
    return MonetizationState(
      map['isPurchased'] ?? false,
      map['isAppAvailableToBuy'] ?? false,
      map["isTherePendingPurchase"] ?? false,
      List.from(map['purchases']),
      List.from(map['products']),
    );
  }
  @override
  bool get stringify => true;
}

class MonetizationInitial extends MonetizationState {
  MonetizationInitial() : super(false, true, false, [], []);
}
