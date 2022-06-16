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
  AnotherStep({
    required this.index,
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
