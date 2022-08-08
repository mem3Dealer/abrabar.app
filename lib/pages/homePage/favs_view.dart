import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../logic/bloc/bloc/coctailBloc/coctail_bloc.dart';
import '../../shared/picPaths.dart';
import 'package:flutter_gen/gen_l10n/app_localz.dart';
import 'package:sizer/sizer.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    final paths = PicPaths();
    return BlocConsumer<CoctailBloc, CoctailState>(
      listener: (context, state) {},
      builder: (context, state) {
        state.favoriteCoctails.forEach((element) {
          // log(element.toString());
        });
        if (state.favoriteCoctails.isEmpty) {
          return Stack(
            children: [
              Align(
                  alignment: const Alignment(0, -0.85),
                  child: Text(
                    t.zombieSays,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w400),
                  )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    // color: Colors.red,
                    height: 50.h,
                    width: 100.w,
                    child: SvgPicture.asset(
                      '${paths.systemImages}empty_favs_banner.svg',
                      fit: BoxFit.cover,
                    ),
                  )),
            ],
          );
        } else {
          return GridView.builder(
              // physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: state.favoriteCoctails.length,
              itemBuilder: (BuildContext ctx, index) {
                return state.favoriteCoctails[index].createGridCell(
                    collectionName: 'favs',
                    setName: null,
                    context: context,
                    coctail: state.favoriteCoctails[index]);
              });
        }
      },
    );
  }
}
