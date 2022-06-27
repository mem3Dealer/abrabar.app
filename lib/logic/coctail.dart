import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';

import 'bloc/bloc/coctail_bloc.dart';

class Coctail {
  String? name;
  String? picPreview;
  String? description;
  bool isFav;
  List<String>? searchWords;
  List<String>? categories;
  List<Map<String, dynamic>>? steps;
  List<Map<String, dynamic>>? ingredients;

  Coctail({
    this.name,
    this.picPreview,
    this.description,
    required this.isFav,
    this.searchWords,
    this.categories,
    this.steps,
    this.ingredients,
  });

  factory Coctail.fromGSheets(Map<String, String> json) {
    List<String>? categories = [];
    List<String>? searchWords = [];
    List<Map<String, dynamic>> steps = [];
    List<Map<String, dynamic>> ingredients = [];

    json["searchWords"]!.split(",").forEach((element) {
      searchWords.add(element.trim());
    });

    json['categories']!.split(',').forEach((element) {
      categories.add(element.trim());
    });
    // print(json);
    List<String> presteps = json['steps']!.split('///');

    presteps.forEach((step) {
      List<String> images = step.split(':')[1].split(",");
      List<String> trimmed = [];
      images.forEach((el) {
        trimmed.add(el.trim());
      });

      Map<String, dynamic> mappedStep = {
        "step": step.split(':')[0].trim(),
        "images": trimmed
      };
      steps.add(mappedStep);
    });

    List<String> preIngredients = json['ingredients']!.split('///');
    preIngredients.forEach((elemnt) {
      Map<String, dynamic> mappedIngredient = {
        "what": elemnt.split(":")[0].trim(),
        "howMuch": elemnt.split(":")[1].trim()
      };
      ingredients.add(mappedIngredient);
    });

    return Coctail(
      name: json['name']!.trim(),
      picPreview: json['picPreview']!.trim(),
      description: json['description']!.trim(),
      isFav: false,
      searchWords: searchWords,
      categories: categories,
      steps: steps,
      ingredients: ingredients,
    );
  }

  Widget createGridCell(
      {required BuildContext context, required Coctail coctail}) {
    bool isFav;

    final cockBloc = GetIt.I.get<CoctailBloc>();
    isFav = cockBloc.state.favoriteCoctails.contains(coctail);
    return InkWell(
        onTap: () => cockBloc.add(SelectCoctail(coctail, context)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // child,
            SvgPicture.asset('assets/images/previews/${coctail.picPreview}'),
            isFav
                ? Padding(
                    padding: EdgeInsets.only(right: 3.w, top: 1.5.h),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset(
                          'assets/images/system/white_gold_star.svg'),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ));
  }

  Coctail copyWith({
    String? name,
    String? picPreview,
    String? description,
    bool? isFav,
    List<String>? searchWords,
    List<String>? categories,
    List<Map<String, dynamic>>? steps,
    List<Map<String, dynamic>>? ingredients,
  }) {
    return Coctail(
      name: name ?? this.name,
      picPreview: picPreview ?? this.picPreview,
      description: description ?? this.description,
      isFav: isFav ?? this.isFav,
      searchWords: searchWords ?? this.searchWords,
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
      'searchWords': searchWords,
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
      searchWords: List<String>.from(map['searchWords']),
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
    return 'Coctail(name: $name, picPreview: $picPreview, description: $description, isFav: $isFav, searchWords: $searchWords, categories: $categories, steps: $steps, ingredients: $ingredients)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Coctail &&
        other.name == name &&
        other.picPreview == picPreview &&
        other.description == description &&
        other.isFav == isFav &&
        listEquals(other.searchWords, searchWords) &&
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
        searchWords.hashCode ^
        categories.hashCode ^
        steps.hashCode ^
        ingredients.hashCode;
  }
}
