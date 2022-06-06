import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localz.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    const double sizedBoxHeight = 168;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.settings,
          style: theme.textTheme.headline3,
        ),
        leading: IconButton(
            onPressed: () {},
            icon: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Image.asset('assets/images/close.png'))),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () {},
                child: Text(
                  'ПО-РУССКИ',
                  style: theme.textTheme.headline1,
                )),
            const SizedBox(
              height: sizedBoxHeight,
            ),
            TextButton(
                style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all(Colors.transparent)),
                onPressed: () {},
                child: Text('ENGLISH', style: theme.textTheme.headline1))
          ],
        ),
      ),
    );
  }
}
