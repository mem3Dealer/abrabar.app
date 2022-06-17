import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';

import 'package:abrabar/logic/coctail.dart';

import '../../logic/bloc/bloc/coctail_bloc.dart';
import '../../shared/picPaths.dart';

class SeasonView extends StatelessWidget {
  final cockBloc = GetIt.I.get<CoctailBloc>();
  final paths = PicPaths();

  // List<String> cats = ['summer', 'winter', "autumn", "spring"];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ListView(
        children: [
          seasonTile(
              seasonName: 'Зима',
              amounOfCocks: 12,
              theme: theme,
              color: Color(0xffA7C8E0),
              assetName: 'winter',
              context: context),
          seasonTile(
              seasonName: 'Весна',
              amounOfCocks: 9,
              theme: theme,
              color: Color(0xffF2521F),
              assetName: 'spring',
              context: context),
          seasonTile(
              seasonName: 'Лето',
              amounOfCocks: 10,
              theme: theme,
              color: Color(0xff46C56A),
              assetName: 'summer',
              context: context),
          seasonTile(
              seasonName: 'Осень',
              amounOfCocks: 15,
              theme: theme,
              color: Color(0xffF2AA1F),
              assetName: 'autumn',
              context: context),
        ],
      ),
    );
  }

  Widget seasonTile(
      {required String seasonName,
      required String assetName,
      required int amounOfCocks,
      required Color color,
      required BuildContext context,
      required ThemeData theme}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => SeasonPage(
              title: seasonName,
              categoryName: assetName,
              color: color,
            ),
          ),
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
                  style: theme.textTheme.headline2,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 1.75.h, left: 2.75.w),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  '$amounOfCocks коктейлей',
                  style: theme.textTheme.subtitle2,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                  height: 20.h,
                  width: 21.h,
                  child: SvgPicture.asset(
                      paths.categoryPics + assetName + ".svg")),
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
  SeasonPage({
    Key? key,
    required this.color,
    required this.categoryName,
    required this.title,
  }) : super(key: key);
  final cockBloc = GetIt.I.get<CoctailBloc>();
  final paths = PicPaths();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoctailBloc, CoctailState>(
      listener: (context, state) {},
      builder: (context, state) {
        final theme = Theme.of(context);
        List<Coctail> seasonCoctails = [];
        state.allCoctails.forEach((coc) {
          if (coc.categories!.contains(categoryName)) {
            seasonCoctails.add(coc);
          }
        });

        return Scaffold(
          appBar: AppBar(
            // toolbarHeight: 8.h,
            backgroundColor: color,
          ),
          // backgroundColor: color,
          body: ListView(
            shrinkWrap: true,
            children: [
              Container(
                width: 100.w,
                height: 40.h,
                color: color,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 6.25.h, left: 6.1.w),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          title,
                          style: theme.textTheme.headline2,
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(bottom: 6.1.h, left: 6.1.w),
                    //   child: Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: Text(
                    //       title,
                    //       style: theme.textTheme.headline2,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 25.h,
                      width: 60.w,
                      child: Align(
                        alignment: Alignment(1, 1),
                        child: SvgPicture.asset(
                            "${paths.categoryPics}$categoryName.svg"),
                      ),
                    )
                  ],
                ),
              ),
              GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: seasonCoctails.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return seasonCoctails[index].createGridCell(
                        child: SvgPicture.asset(
                            paths.previews + seasonCoctails[index].picPreview!),
                        coctail: seasonCoctails[index],
                        context: context);
                  }),
            ],
          ),
        );
      },
    );
  }
}
