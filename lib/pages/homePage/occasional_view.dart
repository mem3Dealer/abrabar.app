import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localz.dart';
import '../../shared/widgets.dart';

class OccasionalView extends StatelessWidget {
  const OccasionalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    final aWidgets = AbrabarWidgets();
    return Center(
      child: ListView(
        children: [
          aWidgets.seasonTile(
              seasonName: t.new_year,
              assetName: 'new_year',
              amounOfCocks: 15,
              color: const Color(0xffC62E2E),
              context: context),
          aWidgets.seasonTile(
              seasonName: t.wedding,
              assetName: 'wedding',
              amounOfCocks: 13,
              color: const Color(0xffF0C3E9),
              context: context),
          aWidgets.seasonTile(
              seasonName: t.stPatrick,
              assetName: 'patrick',
              amounOfCocks: 15,
              color: const Color(0xff4CB469),
              context: context),
          aWidgets.seasonTile(
              seasonName: t.womensDay,
              assetName: 'womensDay',
              amounOfCocks: 10,
              color: const Color(0xffFF4A3F),
              context: context),
          aWidgets.seasonTile(
              seasonName: t.graduation,
              assetName: 'graduation',
              amounOfCocks: 9,
              color: const Color(0xff713FFF),
              context: context),
          aWidgets.seasonTile(
              seasonName: t.birthday,
              assetName: 'birthday',
              amounOfCocks: 8,
              color: const Color(0xffFFBE3F),
              context: context),
        ],
      ),
    );
  }
}
