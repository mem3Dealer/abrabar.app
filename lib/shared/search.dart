import 'package:abrabar/shared/picPaths.dart';
import 'package:flutter/material.dart';

import 'package:abrabar/logic/coctail.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import '../logic/bloc/bloc/coctail_bloc.dart';

class SearchCoctails extends SearchDelegate<String> {
  final cockBloc = GetIt.I.get<CoctailBloc>();
  final paths = PicPaths();
  List<Coctail> allCoctails = [];
  SearchCoctails({
    required this.allCoctails,
  });

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () => query = '',
          icon: SvgPicture.asset("${paths.systemImages}close.svg"))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () {
          query = '';
          close(context, query);
        },
        icon: SvgPicture.asset("${paths.systemImages}back_arrow_golden.svg"));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Coctail> resultCoctails = [];

    resultCoctails = allCoctails.where((coctail) {
      return coctail.searchWords!.contains(query.toLowerCase());
    }).toList();

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: GridView.builder(
          // physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemCount: resultCoctails.length,
          itemBuilder: (BuildContext ctx, index) {
            return resultCoctails[index].createGridCell(
                context: context, coctail: resultCoctails[index]);
          }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // List<Coctail> resultCoctails = [];

    // resultCoctails = allCoctails.where((coctail) {
    //   return coctail.searchWords!.contains(query);
    // }).toList();

    return GridView.builder(
        // physics: const BouncingScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: allCoctails.length,
        itemBuilder: (BuildContext ctx, index) {
          return allCoctails[index]
              .createGridCell(context: context, coctail: allCoctails[index]);
        });
  }
}
