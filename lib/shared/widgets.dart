import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';

import '../logic/bloc/bloc/coctail_bloc.dart';
import '../logic/coctail.dart';
import 'picPaths.dart';

class AbrabarWidgets {
  Widget seasonTile({
    required String seasonName,
    required String assetName,
    required int amounOfCocks,
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
    bool isWhite = whoIsWhite.contains(assetName);
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
                  style: theme.textTheme.headline2!.copyWith(
                      color: isWhite ? Colors.white : const Color(0xff242320)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 1.75.h, left: 2.75.w),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  '$amounOfCocks коктейлей',
                  style: theme.textTheme.subtitle2!.copyWith(
                      color: isWhite ? Colors.white : const Color(0xff242320)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                  height: 20.h,
                  width: 21.h,
                  child:
                      SvgPicture.asset("${paths.categoryPics}$assetName.svg")),
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

  @override
  Widget build(BuildContext context) {
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
                          style: theme.textTheme.headline2!.copyWith(
                              color: isWhite
                                  ? Colors.white
                                  : const Color(0xff242320)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                      width: 60.w,
                      child: Align(
                        alignment: const Alignment(1, 1),
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
                  itemCount: categoryCoctails.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return categoryCoctails[index].createGridCell(
                        coctail: categoryCoctails[index], context: context);
                  }),
            ],
          ),
        );
      },
    );
  }
}
