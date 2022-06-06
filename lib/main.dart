import 'package:abrabar/shared/theme.dart';
import 'package:flutter/material.dart';
// import 'l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localz.dart';
import 'pages/homePage/homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AbrabarTheme.lightTheme,
        title: 'Flutter Demo',
        home: const MyHomePage());
  }
}
