part of 'coctail_bloc.dart';

@immutable
class CoctailState extends Equatable {
  List<Coctail> allCoctails = [];
  CoctailState({
    required this.allCoctails,
  });

  CoctailState copyWith({
    List<Coctail>? allCoctails,
  }) {
    return CoctailState(
      allCoctails: allCoctails ?? this.allCoctails,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'allCoctails': allCoctails.map((x) => x.toMap()).toList(),
    };
  }

  factory CoctailState.fromMap(Map<String, dynamic> map) {
    return CoctailState(
      allCoctails: List<Coctail>.from(
          map['allCoctails']?.map((x) => Coctail.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CoctailState.fromJson(String source) =>
      CoctailState.fromMap(json.decode(source));

  @override
  String toString() => 'CoctailState(allCoctails: $allCoctails)';

  @override
  List<Object> get props => [allCoctails];
}
