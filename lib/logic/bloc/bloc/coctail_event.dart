part of 'coctail_bloc.dart';

@immutable
abstract class CoctailEvent {}

class CoctailsInitialize extends CoctailEvent {}

class SelectCoctail extends CoctailEvent {
  Coctail coctail;
  SelectCoctail(this.coctail);
}

class AnotherStep extends CoctailEvent {
  int index;
  AnotherStep({
    required this.index,
  });
}
