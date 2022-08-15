import 'dart:developer';
import 'dart:io';

import 'package:abrabar/shared/picPaths.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localz.dart';

import '../logic/bloc/bloc/monetizationBloc/monetization_bloc.dart';
import '../logic/bloc/bloc/monetizationBloc/monetization_state.dart';
import '../logic/services/analytic_service.dart';

class PaywallScreen extends StatelessWidget {
  PaywallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paths = PicPaths();
    var t = AppLocalizations.of(context)!;
    final moneyBloc = GetIt.I.get<MonetizationBloc>();
    final String defaultLocale = Platform.localeName;
    late ProductDetails product;

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
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   leading: IconButton(
      //     splashColor: Colors.transparent,
      //     hoverColor: Colors.transparent,
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //     icon: SvgPicture.asset(
      //       "${paths.systemImages}close.svg",
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: BlocConsumer<MonetizationBloc, MonetizationState>(
        listener: (context, state) async {
          if (state.isPurchased) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state.products.isEmpty) {
            product = ProductDetails(
                id: '',
                title: "",
                description: "",
                price: "0",
                rawPrice: 0,
                currencyCode: 'ru_Ru');
          } else {
            product = state.products.first;
          }

          moneyBloc.internetCheckUp();
          return SafeArea(
              top: false,
              bottom: false,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 6.h),
                      child: Text(
                        t.getAccess,
                        style: theme.textTheme.headline1
                            ?.copyWith(fontSize: 32.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 1.25.h, bottom: 6.h),
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
                      height: 2.h,
                    ),
                    state.isAppAvailableToBuy
                        ? Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                            ),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: [
                                TextSpan(
                                    text: "${t.onlyfor}\n",
                                    style: theme.textTheme.headline1!
                                        .copyWith(fontSize: 50.sp)),
                                TextSpan(
                                    text: '${product.rawPrice} ',
                                    style: theme.textTheme.headline1!.copyWith(
                                        overflow: TextOverflow.fade,
                                        fontSize: 50.sp,
                                        color: const Color(0xffFFBE3F))),
                                TextSpan(
                                    text: product.currencySymbol,
                                    style: TextStyle(
                                        fontFamily: "Roboto",
                                        // fontStyle: FontStyle.italic,
                                        fontSize: 50.sp,
                                        color: const Color(0xffFFBE3F))),
                                TextSpan(
                                  text: '\n${t.onceAndForEver}',
                                  style: theme.textTheme.headline1,
                                )
                              ]),
                            ),
                          )
                        : const SizedBox.shrink(),
                    SizedBox(
                      height: 4.h,
                    ),
                    SizedBox(
                      // height: 7.h,
                      width: 72.w,
                      child: ElevatedButton(
                          onPressed: () {
                            moneyBloc.add(MonetizationPurchase(context));
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero)),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xffFFBE3F))),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.2.h),
                            child: state.isTherePendingPurchase
                                ? CircularProgressIndicator(
                                    color: theme.scaffoldBackgroundColor,
                                  )
                                : Text(
                                    t.continue1,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.headline4
                                        ?.copyWith(color: Colors.black),
                                  ),
                          )),
                    ),
                    Platform.isIOS
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.h),
                            child: SizedBox(
                              width: 60.w,
                              child: ElevatedButton(
                                  onPressed: () {
                                    moneyBloc.add(RestorePurchases(context));
                                  },
                                  style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(5),
                                      shadowColor: MaterialStateProperty.all(
                                          const Color(0xffFFBE3F)),
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              color: const Color(0xffFFBE3F))),
                                      shape: MaterialStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.zero)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              theme.scaffoldBackgroundColor)),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.2.h),
                                    child: state.isTherePendingPurchase
                                        ? const CircularProgressIndicator(
                                            color: Color(0xffFFBE3F),
                                          )
                                        : Text(
                                            t.allreadyBoudght,
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.headline4
                                                ?.copyWith(
                                                    color: const Color(
                                                        0xffFFBE3F)),
                                          ),
                                  )),
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ));
        },
      ),
    );
  }
}
