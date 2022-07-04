import 'package:abrabar/shared/picPaths.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paths = PicPaths();

    Widget buildTextRow(String text) {
      return Padding(
        padding: EdgeInsets.only(bottom: 2.5.h, left: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset("${paths.systemImages}tick.svg"),
            SizedBox(
              width: 4.5.w,
            ),
            Text(
              text,
              style: theme.textTheme.headline3,
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset(
            "${paths.systemImages}close.svg",
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
          top: false,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: Text(
                    "ПОЛУЧИ ДОСТУП КО ВСЕМ РЕЦЕПТАМ КОКТЕЙЛЕЙ",
                    style: theme.textTheme.headline1?.copyWith(fontSize: 32.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.25.h, bottom: 8.75.h),
                  child: Text(
                    'БОЛЕЕ 150 РЕЦЕПТОВ!',
                    style: theme.textTheme.subtitle1?.copyWith(fontSize: 24.sp),
                  ),
                ),
                buildTextRow('КОКТЕЙЛИ ДЛЯ СОБЫТИЙ'),
                buildTextRow('СЕЗОННЫЕ КОКТЕЙЛИ'),
                buildTextRow('АВТОРСКИЕ КОКТЕЙЛИ'),
              ],
            ),
          )),
    );
  }
}
