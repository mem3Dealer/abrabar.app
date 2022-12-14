import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localz.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';

import 'package:abrabar/logic/services/analytic_service.dart';

import '../logic/bloc/bloc/coctailBloc/coctail_bloc.dart';
import '../logic/bloc/bloc/monetizationBloc/monetization_bloc.dart';
import '../logic/bloc/bloc/monetizationBloc/monetization_state.dart';
import '../logic/coctail.dart';
import '../pages/paywallScreen.dart';
import 'picPaths.dart';

class AbrabarWidgets {
  Widget seasonTile({
    required String seasonName,
    required String assetName,
    required String subtitle,
    int? amounOfCocks,
    required Color color,
    required BuildContext context,
  }) {
    final paths = PicPaths();
    final theme = Theme.of(context);
    List<String> whoIsWhite = [
      'spring',
      'autumn',
      'new_year',
      'patrick',
      'graduation'
    ];
    var t = AppLocalizations.of(context)!;
    bool isWhite = whoIsWhite.contains(assetName);
    final String defaultLocale = Platform.localeName;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
              builder: (BuildContext context) => SeasonPage(
                    isWhite: isWhite,
                    title: seasonName,
                    categoryName: assetName,
                    color: color,
                  ),
              settings: RouteSettings(name: 'CategoryPage: $seasonName')),
        );
      },
      child: Container(
        color: color,
        height: 22.h,
        width: 100.w,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 2.8.h, left: 2.75.w),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  seasonName,
                  style: theme.textTheme.headline2!.copyWith(
                      fontSize: 37.sp,
                      color: isWhite ? Colors.white : const Color(0xff242320)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 1.75.h, left: 2.75.w),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  subtitle,
                  style: theme.textTheme.subtitle2!.copyWith(
                      color: isWhite ? Colors.white : const Color(0xff242320),
                      fontFamily: 'zet_light'),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                  height: 20.h,
                  width: 21.h,
                  child: SvgPicture.asset(
                    "${paths.categoryPics}$assetName.svg",
                    alignment: Alignment.bottomRight,
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class SeasonPage extends StatelessWidget {
  Color color;
  String categoryName;
  String title;
  bool isWhite;
  SeasonPage({
    Key? key,
    required this.color,
    required this.categoryName,
    required this.title,
    required this.isWhite,
  }) : super(key: key);
  final cockBloc = GetIt.I.get<CoctailBloc>();
  final paths = PicPaths();
  final anal = GetIt.I.get<AnalyticsService>();

  List<String> whoIsWhite = [
    'spring',
    'autumn',
    'new_year',
    'patrick',
    'graduation'
  ];

  @override
  Widget build(BuildContext context) {
    bool isWhite = whoIsWhite.contains(categoryName);

    String collectionName(String categoryName) {
      List<String> seasons = ['winter', 'spring', 'summer', 'autumn'];
      List<String> occasions = [
        'new_year',
        'wedding',
        'patrick',
        'womensDay',
        'graduation',
        'birthday'
      ];
      if (seasons.contains(categoryName)) {
        return 'season';
      } else if (occasions.contains(categoryName)) {
        return 'occasional';
      } else {
        return '';
      }
    }

    anal.selectSet(categoryName, collectionName(categoryName));

    return BlocConsumer<CoctailBloc, CoctailState>(
      listener: (context, state) {},
      builder: (context, state) {
        final theme = Theme.of(context);
        List<Coctail> categoryCoctails = [];
        for (var coc in state.allCoctails) {
          if (coc.categories!.contains(categoryName)) {
            categoryCoctails.add(coc);
          }
        }

        return Scaffold(
          body: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverAppBar(
                // pinned: true,
                floating: true,
                backgroundColor: color,
                expandedHeight: 44.h,
                leading: IconButton(
                  onPressed: (() => Navigator.of(context).pop()),
                  icon: SvgPicture.asset(
                    "${paths.systemImages}back_arrow.svg",
                    color: isWhite ? Colors.white : Colors.black,
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 6.25.h,
                          left: 6.1.w,
                        ),
                        child: Align(
                          alignment: Alignment(-0.85, -0.6),
                          child: Text(
                            title,
                            style: theme.textTheme.headline2!.copyWith(
                                color: isWhite
                                    ? Colors.white
                                    : const Color(0xff242320)),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                          height: 25.h,
                          width: 45.w,
                          child: SvgPicture.asset(
                            "${paths.categoryPics}$categoryName.svg",
                            alignment: Alignment.bottomRight,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              buildGrid(categoryCoctails, collectionName(categoryName), context)
            ],
          ),
        );
      },
    );
  }

  Widget buildGrid(List<Coctail> categoryCoctails, String categoryName,
          BuildContext context) =>
      SliverToBoxAdapter(
        child: Stack(
          children: [
            GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                primary: false,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: categoryCoctails.length,
                itemBuilder: (BuildContext ctx, index) {
                  return categoryCoctails[index].createGridCell(
                      collectionName: categoryName,
                      setName: categoryName,
                      coctail: categoryCoctails[index],
                      context: context);
                }),
            Positioned.fill(
                child: OverlayWithLock(
              screenName: categoryName,
              isSeasonal: true,
            ))
            // OverlayWithLock()
          ],
        ),
      );
}

class OverlayWithLock extends StatelessWidget {
  bool isSeasonal;
  String screenName;
  OverlayWithLock({
    Key? key,
    required this.isSeasonal,
    required this.screenName,
  }) : super(key: key);

  final PicPaths paths = PicPaths();
  final anal = GetIt.I.get<AnalyticsService>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonetizationBloc, MonetizationState>(
      builder: (context, state) {
        if (state.isPurchased == false) {
          return Stack(
            // fit: StackFit.expand,
            children: [
              IgnorePointer(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              Align(
                alignment:
                    isSeasonal ? const Alignment(0, -0.80) : Alignment.center,
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (BuildContext context) => PaywallScreen(),
                        settings: const RouteSettings(name: 'PaywallScreen'),
                      ));
                      anal.paywallOpened(
                          fromWhere: screenName,
                          basePrice: state.basePrice.toInt(),
                          actualPrice: state.actualPrice.toInt());
                    },
                    child: SvgPicture.asset('${paths.systemImages}lock.svg')),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
