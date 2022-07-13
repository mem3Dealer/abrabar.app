import 'dart:convert';
import 'package:abrabar/logic/coctail.dart';
import 'package:abrabar/logic/api/recipes_api.dart';
import 'package:abrabar/logic/services/analytic_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../../../pages/coctailPage.dart';
import '../../../../pages/cookingPage.dart';

part 'coctail_event.dart';
part 'coctail_state.dart';

class CoctailBloc extends Bloc<CoctailEvent, CoctailState> {
  static const storage = FlutterSecureStorage();
  final anal = GetIt.I.get<AnalyticsService>();

  CoctailBloc()
      : super(CoctailState(
            allCoctails: [],
            favoriteCoctails: [],
            currentCoctail: Coctail(isFav: false))) {
    on<CoctailsInitialize>(_onCoctailInitialize);
    on<SelectCoctail>(_onSelectCoctail);
    on<AnotherStep>(_onAnotherStep);
    on<ChangeFavorite>(_onChangeFav);
    on<StartAndEndCooking>(_onStartAndEndCooking);
  }

  Future<void> _onCoctailInitialize(
      CoctailsInitialize event, Emitter emitter) async {
    List<Coctail> fetchedCocs = [];
    // fetchedCocs = await RecipesApi.fetchRecipes();
    final String source =
        await rootBundle.loadString('assets/recepies_ru.json');
    List data = await json.decode(source);

    data.forEach((element) {
      state.allCoctails.add(Coctail.fromGSheets(element));
    });

    emitter(state.copyWith(allCoctails: state.allCoctails));

    List list = [];
    Map<String, String> allValues = await storage.readAll();

    allValues.forEach((key, value) {
      list.add(key);
    });

    for (Coctail coc in state.allCoctails) {
      if (list.contains(coc.name)) {
        state.favoriteCoctails.add(coc);
      }
    }
    emitter(state.copyWith(
      favoriteCoctails: state.favoriteCoctails,
    ));
  }

  Future<void> _onSelectCoctail(SelectCoctail event, Emitter emitter) async {
    Coctail thisCoctail = event.coctail
        .copyWith(isFav: await storage.containsKey(key: event.coctail.name!));
    emitter(state.copyWith(currentCoctail: thisCoctail));
    Navigator.of(event.context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) => CoctailPage(),
        settings: RouteSettings(name: 'CoctailPage')));
  }

  Future<void> _onAnotherStep(AnotherStep event, Emitter emitter) async {
    List<dynamic>? what = [];
    List<String> fuck = [];
    what = state.currentCoctail.steps![event.index]['images'];

    what!.forEach((element) {
      fuck.add(element.toString());
    });
    emitter(state.copyWith(currentIngredients: fuck));
  }

  Future<void> _onChangeFav(ChangeFavorite event, Emitter emitter) async {
    Coctail updated = event.coctail.copyWith(isFav: event.isFav);
    anal.star(event.coctail);
    state.allCoctails[state.allCoctails
        .indexWhere((element) => element.name == event.coctail.name)] = updated;
    if (event.isFav == true) {
      await storage.write(
          key: event.coctail.name!, value: event.isFav.toString());
      // await storage.write(
      //     key: "TEST SHIT",
      //     value: '{"name": "TEST SHIT", "isFav":"${event.isFav.toString()}"}');

      state.favoriteCoctails.add(updated);
      emitter(state.copyWith(
          currentCoctail: updated,
          allCoctails: state.allCoctails,
          favoriteCoctails: state.favoriteCoctails));

      // String? what = await storage.read(key: event.coctail.name!);

    } else {
      await storage.delete(key: event.coctail.name!);
      Coctail cocToRemove = Coctail(isFav: false);
      // if (state.favoriteCoctails.contains(event.coctail)) {
      for (Coctail coc in state.favoriteCoctails) {
        if (coc.name == event.coctail.name) {
          // state.favoriteCoctails.remove(coc);
          cocToRemove = coc;
        }
      }
      state.favoriteCoctails.remove(cocToRemove);
      emitter(state.copyWith(
          currentCoctail: updated,
          allCoctails: state.allCoctails,
          favoriteCoctails: state.favoriteCoctails));
    }
  }

  Future<void> _onStartAndEndCooking(
      StartAndEndCooking event, Emitter emitter) async {
    if (event.isStart == true) {
      anal.howToCook(event.coctail);
      emitter(state.copyWith(
          currentIngredients: event.coctail.steps!.first['images']));
      Navigator.of(event.context).push<void>(
        MaterialPageRoute<void>(
            builder: (BuildContext context) => const CookingPage(),
            settings: RouteSettings(name: 'CoctailPage')),
      );
    } else if (event.isStart == false) {
      emitter(state.copyWith(currentIngredients: []));
      Navigator.of(event.context).pop();
    }
  }
}
