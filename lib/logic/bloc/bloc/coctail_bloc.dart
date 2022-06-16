import 'dart:convert';
import 'package:abrabar/logic/coctail.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:equatable/equatable.dart';
part 'coctail_event.dart';
part 'coctail_state.dart';

class CoctailBloc extends Bloc<CoctailEvent, CoctailState> {
  CoctailBloc()
      : super(CoctailState(allCoctails: [], currentCoctail: Coctail())) {
    on<CoctailsInitialize>(_onCoctailInitialize);
    on<SelectCoctail>(_onSelectCoctail);
    on<AnotherStep>(_onAnotherStep);
    on<ChangeFavorite>(_onChangeFav);
  }
  static const storage = FlutterSecureStorage();

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
    emitter(state.copyWith(currentCoctail: event.coctail));
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
    if (event.isFav == true) {
      await storage.write(
          key: event.coctail.name!, value: event.isFav.toString());
      emitter(state.copyWith(
          currentCoctail: event.coctail.copyWith(isFav: event.isFav)));
    } else {
      await storage.delete(key: event.coctail.name!);
      emitter(
          state.copyWith(currentCoctail: event.coctail.copyWith(isFav: false)));
    }
  }
}
