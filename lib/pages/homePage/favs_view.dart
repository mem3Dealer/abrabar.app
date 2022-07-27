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
        if (state.favoriteCoctails.isEmpty) {
          return Stack(
            children: [
              Align(
                  alignment: Alignment(0, -0.85),
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
                  child: SvgPicture.asset(
                      '${paths.systemImages}empty_favs_banner.svg')),
            ],
          );
        } else {
          return GridView.builder(
              // physics: const BouncingScrollPhysics(),
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
