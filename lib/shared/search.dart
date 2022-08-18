import 'package:abrabar/logic/services/analytic_service.dart';
import 'package:abrabar/shared/picPaths.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:abrabar/logic/coctail.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import '../logic/bloc/bloc/coctailBloc/coctail_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localz.dart';

class SearchCoctails extends SearchDelegate<String> {
  final cockBloc = GetIt.I.get<CoctailBloc>();
  final anal = GetIt.I.get<AnalyticsService>();
  final paths = PicPaths();
  List<Coctail> allCoctails = [];

  SearchCoctails({
    required this.allCoctails,
  });

  @override
  // TODO: implement textInputAction
  TextInputAction get textInputAction => TextInputAction.search;

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
    var t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    if (query != '') {
      resultCoctails = allCoctails.where((coctail) {
        return coctail.searchWords!.contains(query.toLowerCase().trim());
      }).toList();
      anal.search(query);
    } else {
      resultCoctails = allCoctails;
    }

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: resultCoctails.isNotEmpty
          ? GridView.builder(
              padding: EdgeInsets.zero,
              // physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: resultCoctails.length,
              itemBuilder: (BuildContext ctx, index) {
                return resultCoctails[index].createGridCell(
                    setName: null,
                    collectionName: 'search',
                    context: context,
                    coctail: resultCoctails[index]);
              })
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    t.notFound,
                    style: theme.textTheme.headline1,
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    width: 100.w,
                    height: 110.w,
                    child: SvgPicture.asset(
                      '${paths.systemImages}empty_favs_banner.svg',
                      fit: BoxFit.fitWidth,
                    ),
                  )
                ],
              ),
            ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.zero,
        // physics: const BouncingScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: allCoctails.length,
        itemBuilder: (BuildContext ctx, index) {
          return allCoctails[index].createGridCell(
              setName: null,
              collectionName: 'search',
              context: context,
              coctail: allCoctails[index]);
        });
  }
}
