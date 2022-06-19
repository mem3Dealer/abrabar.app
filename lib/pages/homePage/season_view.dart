import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../logic/bloc/bloc/coctail_bloc.dart';
import '../../shared/picPaths.dart';
import 'package:flutter_gen/gen_l10n/app_localz.dart';
import '../../shared/widgets.dart';

class SeasonView extends StatelessWidget {
  final cockBloc = GetIt.I.get<CoctailBloc>();
  final paths = PicPaths();
  final abrabarWidget = AbrabarWidgets();

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return Center(
      child: ListView(
        children: [
          abrabarWidget.seasonTile(
              seasonName: t.winter,
              amounOfCocks: 12,
              color: const Color(0xffA7C8E0),
              assetName: 'winter',
              context: context),
          abrabarWidget.seasonTile(
              seasonName: t.spring,
              amounOfCocks: 9,
              color: const Color(0xffF2521F),
              assetName: 'spring',
              context: context),
          abrabarWidget.seasonTile(
              seasonName: t.summer,
              amounOfCocks: 10,
              color: const Color(0xff46C56A),
              assetName: 'summer',
              context: context),
          abrabarWidget.seasonTile(
              seasonName: t.autumn,
              amounOfCocks: 15,
              color: const Color(0xffF2AA1F),
              assetName: 'autumn',
              context: context),
        ],
      ),
    );
  }
}
