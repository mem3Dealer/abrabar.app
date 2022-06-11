import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'homePage/homePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final String _way = 'assets/images/parts/';
  final Duration duration = const Duration(seconds: 3);
  @override
  Widget build(BuildContext context) {
    Future.delayed(
        duration,
        () => Navigator.of(context).pushReplacement(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const MyHomePage(),
              ),
            ));
    final theme = Theme.of(context);
    return SafeArea(
        child: Scaffold(
      body: Center(
          child: Container(

              // color: Colors.lightGreen,
              color: theme.scaffoldBackgroundColor,
              child: Column(
                children: [
                  Flexible(
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment(1, -1.35),
                          child: SizedBox(
                            width: 56.3.w,
                            height: 26.h,
                            child: SvgPicture.asset('${_way}orange.svg'),
                          ),
                        ),
                        Align(
                          alignment: Alignment(-1.31, -0.5),
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
                          alignment: Alignment(0.75, 0.3),
                          child: FractionallySizedBox(
                            widthFactor: 0.3,
                            heightFactor: 0.13,
                            child: SvgPicture.asset('${_way}ice.svg'),
                          ),
                        ),
                        Align(
                          alignment: Alignment(-1.1, 1.03),
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
                          alignment: Alignment(0, 0.80),
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