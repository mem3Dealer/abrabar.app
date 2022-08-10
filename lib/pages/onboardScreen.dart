import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localz.dart';
import 'package:abrabar/pages/homePage/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../logic/services/analytic_service.dart';
import '../shared/picPaths.dart';

class OnboardScreen extends StatefulWidget {
  OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final PageController controller = PageController();
  final anal = GetIt.I.get<AnalyticsService>();
  int selectedindex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (selectedindex == 0) {
      anal.onboardSwipe(index: 0);
    }
    return SafeArea(
      top: false,
      bottom: false,
      child: Column(
        children: [
          Expanded(
            child: PageView(
              physics: const ClampingScrollPhysics(),
              controller: controller,
              children: _buildPages(selectedindex, context),
              onPageChanged: (int page) {
                setState(() {
                  selectedindex = page;
                  anal.onboardSwipe(index: selectedindex);
                });
              },
            ),
          ),
          Container(
            height: 20.h,
            // color: Colors.red,
            color: theme.scaffoldBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 3.2.h, top: 3.h),
                  child: _buildButton(theme, selectedindex, context),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildPages(int index, BuildContext context) {
    var t = AppLocalizations.of(context)!;
    late double heightFactor;
    late Alignment alignment;
    final String defaultLocale = Platform.localeName;
    final theme = Theme.of(context);
    final paths = PicPaths();
    List<Widget> list = [];
    List<String> texts = [
      t.onboard0,
      t.onboard1,
      t.onboard2,
      t.onboard3,
      t.onboard4
    ];
    for (var i = 0; i < 5; i++) {
      if (i == 0) {
        alignment = const Alignment(0, -1);
        heightFactor = 0.85;
      } else if (i == 1) {
        heightFactor = 0.65;
        alignment = const Alignment(0, -0.4);
      } else if (i == 2) {
        heightFactor = 0.74;
      } else if (i == 3 || i == 4) {
        heightFactor = 0.7;
      }

      String _content = texts[i];
      bool _isonBottom = i == 0 || i == 1;
      list.add(Scaffold(
        body: Container(
          color: theme.scaffoldBackgroundColor,
          // color: Colors.blue,
          child: Stack(
            children: [
              Align(
                  alignment: _isonBottom ? alignment : Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    heightFactor: heightFactor,
                    child: Container(
                      // color: Colors.green,
                      // width: 100.w,
                      // height: 50.h,
                      child: SvgPicture.asset(
                        defaultLocale.contains('ru') ||
                                defaultLocale.contains('RU')
                            ? '${paths.onboard}onboard_$i.svg'
                            : '${paths.onboard}onboard_${i}_eng.svg',
                        fit: BoxFit.fill,
                        // clipBehavior: Clip.antiAlias,
                      ),
                    ),
                  )),
              Align(
                alignment:
                    _isonBottom ? Alignment(0, 1) : const Alignment(0, -0.8),
                child: Padding(
                  padding: EdgeInsets.only(right: 5.w, left: 5.w),
                  child: Text(
                    _content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'zet_regular',
                        color: Colors.white,
                        fontSize: 27.sp),
                  ),
                ),
              )
            ],
          ),
        ),
      ));
    }
    return list;
  }

  Widget _buildButton(ThemeData theme, int index, BuildContext context) {
    FlutterSecureStorage storage = FlutterSecureStorage();
    var t = AppLocalizations.of(context)!;
    return SizedBox(
      width: 72.w,
      height: 7.h,
      child: ElevatedButton(
          onPressed: index == 4
              ? () async {
                  await storage.write(key: 'watchedOnboard', value: 'true');
                  // Navigator.of(context).push(MaterialPageRoute<void>(
                  //     builder: (BuildContext context) => const MyHomePage(),
                  //     settings: const RouteSettings(name: 'HomePage')));
                  Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
                      builder: (BuildContext context) => const MyHomePage(),
                      settings: const RouteSettings(name: 'HomePage')));
                }
              : () {
                  controller.nextPage(
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut);
                },
          style: ElevatedButton.styleFrom(
              //  primary: null,
              onPrimary: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              side: const BorderSide(width: 2, color: Color(0xffFFBE3F)),
              primary: Colors.transparent),
          child: Text(
            index == 0
                ? t.interesting
                : index == 4
                    ? t.enjoy
                    : t.next,
            style: theme.textTheme.subtitle1!.copyWith(fontSize: 24.sp),
          )),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 5; i++) {
      list.add(i == selectedindex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return Container(
      height: 6,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: 6,
        width: 6,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: Color(0XFFFFBE3F).withOpacity(0.72),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: Offset(
                      0.0,
                      0.0,
                    ),
                  )
                : BoxShadow(
                    color: Colors.transparent,
                  )
          ],
          shape: BoxShape.rectangle,
          color: isActive ? Color(0XFFFFBE3F) : Colors.grey,
        ),
      ),
    );
  }
}
