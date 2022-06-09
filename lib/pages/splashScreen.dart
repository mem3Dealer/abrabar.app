import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final String _way = 'assets/images/splash/';
  @override
  Widget build(BuildContext context) {
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
                          alignment: Alignment(1, -1.2),
                          child: FractionallySizedBox(
                            widthFactor: 0.56,
                            heightFactor: 0.26,
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
                          alignment: Alignment.bottomLeft,
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
