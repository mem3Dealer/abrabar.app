// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'coctail_bloc.dart';

abstract class CoctailEvent {}

class CoctailsInitialize extends CoctailEvent {}

class SelectCoctail extends CoctailEvent {
  Coctail coctail;
  BuildContext context;
  SelectCoctail(
    this.coctail,
    this.context,
  );
}

class AnotherStep extends CoctailEvent {
  int index;
  bool? isForward;
  AnotherStep({
    required this.index,
    this.isForward,
  });
}

class ChangeFavorite extends CoctailEvent {
  Coctail coctail;
  bool isFav;
  ChangeFavorite({
    required this.coctail,
    required this.isFav,
  });
}

class StartAndEndCooking extends CoctailEvent {
  Coctail coctail;
  bool isStart;
  BuildContext context;
  StartAndEndCooking({
    required this.coctail,
    required this.isStart,
    required this.context,
  });
}
