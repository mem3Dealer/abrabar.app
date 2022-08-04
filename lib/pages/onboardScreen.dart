import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../shared/picPaths.dart';

class OnboardScreen extends StatefulWidget {
  OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final PageController controller = PageController();

  int selectedindex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: PageView(
            physics: const ClampingScrollPhysics(),
            controller: controller,
            children: _buildPages(selectedindex, context),
            onPageChanged: (int page) {
              setState(() {
                selectedindex = page;
              });
            },
          ),
        ),
        Container(
          height: 180,
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
                padding: EdgeInsets.only(bottom: 6.2.h, top: 3.h),
                child: _buildButton(theme, selectedindex),
              )
            ],
          ),
        )
      ],
    );
  }

  List<Widget> _buildPages(int index, BuildContext context) {
    List<Widget> list = [];
    List<String> texts = [
      'ПРИГОТОВЬТЕ ДОМА ЛЮБЫЕ КОКТЕЙЛИ НА ВАШ ВЫБОР',
      'Коктейли на любой случай в тематических подборках',
      'Добавляйте свои коктейли в избранное и делитесь ими с друзьями',
      'Пошаговые инструкции по приготовлению коктейлей сделают из вас настоящего бармена',
      'Наслаждайтесь своими навыками миксологии вместе с AbraBar',
    ];
    for (var i = 0; i < 5; i++) {
      final theme = Theme.of(context);
      final paths = PicPaths();
      String _content = texts[i];
      bool _isonBottom = i == 0 || i == 1;
      list.add(Scaffold(
        body: Container(
          color: theme.scaffoldBackgroundColor,
          child: Stack(
            // fit: StackFit.passthrough,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                  alignment: _isonBottom
                      ? const Alignment(0, -0.4)
                      : Alignment.bottomCenter,
                  child:
                      // i == 0
                      //     ? Text(
                      //         'Расширьте свою миксологию и приготовьте коктейль как настоящий бармен с',
                      //         textAlign: TextAlign.center,
                      //         style: theme.textTheme.headline2!
                      //             .copyWith(color: Colors.white),
                      //       )
                      //     :
                      SizedBox(
                    width: 100.w,
                    child: SvgPicture.asset(
                      '${paths.systemImages}onboard_$i.svg',
                      fit: BoxFit.fill,
                    ),
                  )),
              Align(
                alignment: _isonBottom
                    ? Alignment.bottomCenter
                    : const Alignment(0, -0.6),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20.0, right: 5.w, left: 5.w),
                  child: Text(
                    _content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'zet_regular',
                        color: Colors.white,
                        fontSize: 30),
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

  Widget _buildButton(ThemeData theme, int index) {
    return SizedBox(
      width: 72.w,
      height: 7.h,
      child: ElevatedButton(
          onPressed: () {
            index != 4
                ? controller.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut)
                : () {};
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
                ? 'ИНТЕРЕСНО'
                : index == 4
                    ? "насладиться"
                    : 'далее',
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
