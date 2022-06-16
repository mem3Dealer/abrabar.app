import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class Coctail {
  String? name;
  String? picPreview;
  String? description;
  bool isFav = false;
  List<String>? categories;
  List<Map<String, dynamic>>? steps;
  List<Map<String, dynamic>>? ingredients;

  Coctail({
    this.name,
    this.picPreview,
    this.description,
    this.isFav = false,
    this.categories,
    this.steps,
    this.ingredients,
  });

  Coctail copyWith({
    String? name,
    String? picPreview,
    String? description,
    bool? isFav,
    List<String>? categories,
    List<Map<String, dynamic>>? steps,
    List<Map<String, dynamic>>? ingredients,
  }) {
    return Coctail(
      name: name ?? this.name,
      picPreview: picPreview ?? this.picPreview,
      description: description ?? this.description,
      isFav: isFav ?? this.isFav,
      categories: categories ?? this.categories,
      steps: steps ?? this.steps,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'picPreview': picPreview,
      'description': description,
      'isFav': isFav,
      'categories': categories,
      'steps': steps,
      'ingredients': ingredients,
    };
  }

  factory Coctail.fromMap(Map<String, dynamic> map) {
    return Coctail(
      name: map['name'],
      picPreview: map['picPreview'],
      description: map['description'],
      isFav: map['isFav'] ?? false,
      categories: List<String>.from(map['categories']),
      steps: map['steps'] != null
          ? List<Map<String, dynamic>>.from(
              map['steps']?.map((x) => Map<String, dynamic>.from(x)))
          : null,
      ingredients: map['ingredients'] != null
          ? List<Map<String, dynamic>>.from(
              map['ingredients']?.map((x) => Map<String, dynamic>.from(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Coctail.fromJson(String source) =>
      Coctail.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Coctail(name: $name, picPreview: $picPreview, description: $description, isFav: $isFav, categories: $categories, steps: $steps, ingredients: $ingredients)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Coctail &&
        other.name == name &&
        other.picPreview == picPreview &&
        other.description == description &&
        other.isFav == isFav &&
        listEquals(other.categories, categories) &&
        listEquals(other.steps, steps) &&
        listEquals(other.ingredients, ingredients);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        picPreview.hashCode ^
        description.hashCode ^
        isFav.hashCode ^
        categories.hashCode ^
        steps.hashCode ^
        ingredients.hashCode;
  }
}
