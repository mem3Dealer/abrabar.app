import 'dart:convert';
import 'package:abrabar/logic/coctail.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:equatable/equatable.dart';
part 'coctail_event.dart';
part 'coctail_state.dart';

class CoctailBloc extends Bloc<CoctailEvent, CoctailState> {
  CoctailBloc() : super(CoctailState(allCoctails: [])) {
    on<CoctailsInitialize>(_onCoctailInitialize);
  }

  Future<void> _onCoctailInitialize(
      CoctailsInitialize event, Emitter emitter) async {
    List<Coctail>? _allCocks = [];
    final String source = await rootBundle.loadString('assets/allJSON.json');
    List data = await json.decode(source);
    for (var element in data) {
      // _allCocks.add(Coctail.fromMap(element));
      // emitter(state.copyWith(
      //     allCoctails: state.allCoctails.add(Coctail.fromMap(element))));
      state.allCoctails.add(Coctail.fromMap(element));
    }
    emitter(state.copyWith(allCoctails: state.allCoctails));
    print(state);
  }

  // Future<List> _allCocks() async {}
}
