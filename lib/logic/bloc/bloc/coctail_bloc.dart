import 'dart:convert';
import 'package:abrabar/logic/coctail.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:equatable/equatable.dart';

import '../../../pages/coctailPage.dart';
part 'coctail_event.dart';
part 'coctail_state.dart';

class CoctailBloc extends Bloc<CoctailEvent, CoctailState> {
  static const storage = FlutterSecureStorage();
  CoctailBloc()
      : super(CoctailState(
            allCoctails: [], currentCoctail: Coctail(isFav: false))) {
    on<CoctailsInitialize>(_onCoctailInitialize);
    on<SelectCoctail>(_onSelectCoctail);
    on<AnotherStep>(_onAnotherStep);
    on<ChangeFavorite>(_onChangeFav);
  }

  Future<void> _onCoctailInitialize(
      CoctailsInitialize event, Emitter emitter) async {
    final String source = await rootBundle.loadString('assets/allJSON.json');
    List data = await json.decode(source);
    for (var element in data) {
      state.allCoctails.add(Coctail.fromMap(element));
    }

    emitter(state.copyWith(
      allCoctails: state.allCoctails,
    ));
  }

  Future<void> _onSelectCoctail(SelectCoctail event, Emitter emitter) async {
    Coctail thisCoctail = event.coctail
        .copyWith(isFav: await storage.containsKey(key: event.coctail.name!));
    emitter(state.copyWith(currentCoctail: thisCoctail));
    Navigator.of(event.context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) => CoctailPage()));
  }

  Future<void> _onAnotherStep(AnotherStep event, Emitter emitter) async {
    List<dynamic>? _what = [];
    List<String> fuck = [];
    _what = state.currentCoctail.steps![event.index]['images'];
    _what!.forEach((element) {
      fuck.add(element.toString());
    });
    emitter(state.copyWith(currentIngredients: fuck));
    // print(_what);
  }

  Future<void> _onChangeFav(ChangeFavorite event, Emitter emitter) async {
    Coctail updated = event.coctail.copyWith(isFav: event.isFav);

    if (event.isFav == true) {
      await storage.write(
          key: event.coctail.name!, value: event.isFav.toString());

      state.allCoctails[state.allCoctails
              .indexWhere((element) => element.name == event.coctail.name)] =
          updated;

      emitter(state.copyWith(
          currentCoctail: updated, allCoctails: state.allCoctails));
    } else {
      await storage.delete(key: event.coctail.name!);

      state.allCoctails[state.allCoctails
              .indexWhere((element) => element.name == event.coctail.name)] =
          updated;
      emitter(state.copyWith(
          currentCoctail: updated, allCoctails: state.allCoctails));
    }
  }
}
