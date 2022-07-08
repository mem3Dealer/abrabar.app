import 'package:abrabar/shared/picPaths.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localz.dart';

import '../logic/bloc/bloc/monetizationBloc/monetization_bloc.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paths = PicPaths();
    var t = AppLocalizations.of(context)!;
    final moneyBloc = GetIt.I.get<MonetizationBloc>();

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
            child: ListView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Text(
                        t.getAccess,
                        style: theme.textTheme.headline1
                            ?.copyWith(fontSize: 32.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1.25.h, bottom: 8.75.h),
                      child: Text(
                        t.moreThan,
                        style: theme.textTheme.subtitle1
                            ?.copyWith(fontSize: 24.sp),
                      ),
                    ),
                    buildTextRow(t.coctailsOccaisonal),
                    buildTextRow(t.coctailsSeasonal),
                    buildTextRow(t.coctailsAuthor),
                    SizedBox(
                      height: 8.h,
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: t.onlyfor,
                            style: theme.textTheme.headline1!
                                .copyWith(fontSize: 50.sp)),
                        TextSpan(
                            text: "999Р",
                            style: theme.textTheme.headline1!.copyWith(
                                fontSize: 50.sp,
                                color: const Color(0xffFFBE3F)))
                      ]),
                    ),
                    Text(
                      t.onceAndForEver,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headline1,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 6.h),
                      child: SizedBox(
                        // height: 7.h,
                        width: 72.w,
                        child: ElevatedButton(
                            onPressed: () {
                              moneyBloc.add(MonetizationPurchase());
                              Navigator.of(context).pop();
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero)),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xffFFBE3F))),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.2.h),
                              child: Text(
                                t.continue1,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headline4
                                    ?.copyWith(color: Colors.black),
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
