import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';

import 'package:abrabar/logic/bloc/bloc/monetizationBloc/monetization_bloc.dart';
import 'package:abrabar/logic/services/analytic_service.dart';
import 'package:abrabar/shared/picPaths.dart';

import 'bloc/bloc/coctailBloc/coctail_bloc.dart';
import 'bloc/bloc/monetizationBloc/monetization_state.dart';

class Coctail {
  String? name;
  String? picPreview;
  String? description;
  Color? color;
  bool isFav;
  List<String>? searchWords;
  List<String>? categories;
  List<Map<String, dynamic>>? steps;
  List<Map<String, dynamic>>? ingredients;

  Coctail({
    this.name,
    this.picPreview,
    this.description,
    this.color,
    required this.isFav,
    this.searchWords,
    this.categories,
    this.steps,
    this.ingredients,
  });

  factory Coctail.fromGSheets(Map json) {
    List<String>? categories = [];
    List<String>? searchWords = [];
    List<Map<String, dynamic>> steps = [];
    List<Map<String, dynamic>> ingredients = [];
    Color color;
    String st = '0xff';
    st = st + json['colorCode']!.trim();
    color = Color(int.parse(st));

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

    ingredients.forEach((element) {
      searchWords.add(element['what']);
    });

    return Coctail(
      name: json['name']!.trim(),
      picPreview: json['picPreview']!.trim(),
      description: json['description']!.trim(),
      color: color,
      isFav: false,
      searchWords: searchWords,
      categories: categories,
      steps: steps,
      ingredients: ingredients,
    );
  }

  Widget createGridCell(
      {required BuildContext context,
      required Coctail coctail,
      required String collectionName,
      required String? setName}) {
    bool isFav;
    final paths = PicPaths();
    final cockBloc = GetIt.I.get<CoctailBloc>();
    final moneyBloc = GetIt.I.get<MonetizationBloc>();
    final anal = GetIt.I.get<AnalyticsService>();
    isFav = cockBloc.state.favoriteCoctails.contains(coctail);

    bool isTappable = coctail.categories!.contains('classic') ||
        moneyBloc.state.isPurchased == true;

    return BlocConsumer<MonetizationBloc, MonetizationState>(
      listener: (context, state) {
        if (state.isPurchased == true) {
          isTappable = true;
        }
      },
      builder: (context, state) {
        final String defaultLocale = Platform.localeName;

        return InkWell(
            onTap: isTappable
                ? () {
                    cockBloc.add(SelectCoctail(coctail, context));
                    anal.selectItem(coctail, collectionName, setName ?? "null");
                  }
                : null,
            child: Stack(
              fit: StackFit.expand,
              children: [
                SvgPicture.asset(
                    defaultLocale.contains('ru') || defaultLocale.contains('RU')
                        ? paths.previewsRu + coctail.picPreview!
                        : paths.previewsEng + coctail.picPreview!),
                isFav
                    ? Padding(
                        padding: EdgeInsets.only(right: 3.w, top: 1.5.h),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: SvgPicture.asset(
                              '${paths.systemImages}white_gold_star.svg'),
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ));
      },
    );
  }

  Coctail copyWith({
    String? name,
    String? picPreview,
    String? description,
    Color? color,
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
      color: color ?? this.color,
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
      'color': color!.value,
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
      color: Color(map['color']),
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
    return 'Coctail(name: $name, picPreview: $picPreview, description: $description, color: $color, isFav: $isFav, searchWords: $searchWords, categories: $categories, steps: $steps, ingredients: $ingredients)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Coctail &&
        other.name == name &&
        other.picPreview == picPreview &&
        other.description == description &&
        other.color == color &&
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
        color.hashCode ^
        isFav.hashCode ^
        searchWords.hashCode ^
        categories.hashCode ^
        steps.hashCode ^
        ingredients.hashCode;
  }
}
