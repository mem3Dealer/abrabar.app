part of 'coctail_bloc.dart';

class CoctailState extends Equatable {
  List<Coctail> allCoctails = [];
  Coctail currentCoctail;
  List<String>? currentIngredients;
  CoctailState({
    required this.allCoctails,
    required this.currentCoctail,
    this.currentIngredients,
  });

  CoctailState copyWith({
    List<Coctail>? allCoctails,
    Coctail? currentCoctail,
    List<String>? currentIngredients,
  }) {
    return CoctailState(
      allCoctails: allCoctails ?? this.allCoctails,
      currentCoctail: currentCoctail ?? this.currentCoctail,
      currentIngredients: currentIngredients ?? this.currentIngredients,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'allCoctails': allCoctails.map((x) => x.toMap()).toList(),
      'currentCoctail': currentCoctail.toMap(),
      'currentIngredients': currentIngredients,
    };
  }

  factory CoctailState.fromMap(Map<String, dynamic> map) {
    return CoctailState(
      allCoctails: List<Coctail>.from(
          map['allCoctails']?.map((x) => Coctail.fromMap(x))),
      currentCoctail: Coctail.fromMap(map['currentCoctail']),
      currentIngredients: List<String>.from(map['currentIngredients']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CoctailState.fromJson(String source) =>
      CoctailState.fromMap(json.decode(source));

  @override
  String toString() =>
      'CoctailState(allCoctails: $allCoctails, currentCoctail: $currentCoctail, currentIngredients: $currentIngredients)';

  @override
  List<dynamic> get props => [allCoctails, currentCoctail, currentIngredients];
}
