import 'dart:convert';

import 'package:collection/collection.dart';

class Coctail {
  String name;
  String picPreview;
  List<String> categories;
  List<Map<String, dynamic>> steps;
  List<Map<String, dynamic>> ingredients;
  Coctail({
    required this.name,
    required this.picPreview,
    required this.categories,
    required this.steps,
    required this.ingredients,
  });

  Coctail copyWith({
    String? name,
    String? picPreview,
    List<String>? categories,
    List<Map<String, dynamic>>? steps,
    List<Map<String, dynamic>>? ingredients,
  }) {
    return Coctail(
      name: name ?? this.name,
      picPreview: picPreview ?? this.picPreview,
      categories: categories ?? this.categories,
      steps: steps ?? this.steps,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'picPreview': picPreview,
      'categories': categories,
      'steps': steps,
      'ingredients': ingredients,
    };
  }

  factory Coctail.fromMap(Map<String, dynamic> map) {
    return Coctail(
      name: map['name'] ?? '',
      picPreview: map['picPreview'] ?? '',
      categories: List<String>.from(map['category']),
      steps: List<Map<String, dynamic>>.from(
          map['steps']?.map((x) => Map<String, dynamic>.from(x))),
      ingredients: List<Map<String, dynamic>>.from(
          map['ingredients']?.map((x) => Map<String, dynamic>.from(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Coctail.fromJson(String source) =>
      Coctail.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Coctail(name: $name, picPreview: $picPreview, categories: $categories, steps: $steps, ingredients: $ingredients)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is Coctail &&
        other.name == name &&
        other.picPreview == picPreview &&
        listEquals(other.categories, categories) &&
        listEquals(other.steps, steps) &&
        listEquals(other.ingredients, ingredients);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        picPreview.hashCode ^
        categories.hashCode ^
        steps.hashCode ^
        ingredients.hashCode;
  }
}
