import 'package:abrabar/logic/bloc/bloc/coctail_bloc.dart';
import 'package:abrabar/pages/cookingPage.dart';
import 'package:abrabar/shared/sharedExtensions.dart';
import 'package:abrabar/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localz.dart';
import 'package:get_it/get_it.dart';
import 'pages/homePage/homePage.dart';
import 'pages/splashScreen.dart';
import 'package:sizer/sizer.dart';

void main() {
  GetIt.instance.registerSingleton<CoctailBloc>(CoctailBloc());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final cockBloc = GetIt.I.get<CoctailBloc>();

  @override
  Widget build(BuildContext context) {
    cockBloc.add(CoctailsInitialize());
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
          builder: (context, child) {
            return ScrollConfiguration(behavior: MyBehavior(), child: child!);
          },
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AbrabarTheme.lightTheme,
          title: 'Flutter Demo',
          home: const CookingPage());
    });
  }
}
