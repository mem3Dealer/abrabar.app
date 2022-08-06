import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localz.dart';
import '../../shared/widgets.dart';

class OccasionalView extends StatelessWidget {
  const OccasionalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    final String defaultLocale = Platform.localeName;
    bool isRu = defaultLocale.contains('ru') || defaultLocale.contains('RU');
    final aWidgets = AbrabarWidgets();
    return Center(
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        children: [
          aWidgets.seasonTile(
              seasonName: t.new_year,
              assetName: 'new_year',
              subtitle: isRu ? '17 коктейлей' : "17 coctails",
              color: const Color(0xffC62E2E),
              context: context),
          aWidgets.seasonTile(
              seasonName: t.wedding,
              assetName: 'wedding',
              subtitle: isRu ? '15 коктейлей' : "15 coctails",
              color: const Color(0xffF0C3E9),
              context: context),
          aWidgets.seasonTile(
              seasonName: t.stPatrick,
              assetName: 'patrick',
              subtitle: isRu ? '12 коктейлей' : "12 coctails",
              color: const Color(0xff4CB469),
              context: context),
          aWidgets.seasonTile(
              seasonName: t.womensDay,
              assetName: 'womensDay',
              subtitle: isRu ? '13 коктейлей' : "13 coctails",
              color: const Color(0xffFF4A3F),
              context: context),
          aWidgets.seasonTile(
              seasonName: t.graduation,
              assetName: 'graduation',
              subtitle: isRu ? '12 коктейлей' : "12 coctails",
              color: const Color(0xff713FFF),
              context: context),
          aWidgets.seasonTile(
              seasonName: t.birthday,
              assetName: 'birthday',
              subtitle: isRu ? '15 коктейлей' : "15 coctails",
              color: const Color(0xffFFBE3F),
              context: context),
        ],
      ),
    );
  }
}
