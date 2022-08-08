import 'package:abrabar/pages/onboardScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';
import '../logic/bloc/bloc/coctailBloc/coctail_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'homePage/homePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final cockBloc = GetIt.I.get<CoctailBloc>();
  final String _way = 'assets/images/parts/';
  final Duration duration = const Duration(seconds: 2);
  FlutterSecureStorage storage = const FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    // RecipesApi.fetchRecipes();
    // print("???");
    Future.delayed(duration, () async {
      final bool isOnboardWatched =
          await storage.read(key: "watchedOnboard") == "true";
      // print(isOnboardWatched);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                isOnboardWatched ? MyHomePage() : OnboardScreen(),
            settings: const RouteSettings(name: 'HomePage')),
      );
    });
    final theme = Theme.of(context);
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          body: Center(
              child: Container(
                  color: theme.scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      Flexible(
                        child: Stack(
                          children: [
                            Align(
                              alignment: const Alignment(1, -1.35),
                              child: SizedBox(
                                width: 56.3.w,
                                height: 26.h,
                                child: SvgPicture.asset('${_way}orange.svg'),
                              ),
                            ),
                            Align(
                              alignment: const Alignment(-1.31, -0.5),
                              child: FractionallySizedBox(
                                widthFactor: 0.46,
                                heightFactor: 0.183,
                                child: SvgPicture.asset('${_way}bubbles.svg'),
                              ),
                            ),
                            Align(
                              alignment: const Alignment(-0.5, 0.20),
                              child: FractionallySizedBox(
                                widthFactor: 0.3,
                                heightFactor: 0.15,
                                child: SvgPicture.asset(
                                  '${_way}pinky.svg',
                                  alignment: Alignment.topLeft,
                                ),
                              ),
                            ),
                            Align(
                              alignment: const Alignment(0.75, 0.3),
                              child: FractionallySizedBox(
                                widthFactor: 0.3,
                                heightFactor: 0.13,
                                child: SvgPicture.asset('${_way}ice.svg'),
                              ),
                            ),
                            Align(
                              alignment: const Alignment(-1.1, 1.03),
                              child: FractionallySizedBox(
                                widthFactor: 0.53,
                                heightFactor: 0.17,
                                child: SvgPicture.asset(
                                  '${_way}wine.svg',
                                  alignment: Alignment.bottomLeft,
                                ),
                              ),
                            ),
                            Align(
                              alignment: const Alignment(0, 0.80),
                              child: FractionallySizedBox(
                                widthFactor: 0.36,
                                heightFactor: 0.3,
                                child: SvgPicture.asset('${_way}logo.svg'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ))),
        ));
  }
}
