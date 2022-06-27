import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AbrabarTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xff242320),
      primaryColor: const Color(0xffFF3F6D),
      appBarTheme: AppBarTheme(
          // foregroundColor: Colors.white,
          toolbarTextStyle: TextStyle(color: Colors.amber),
          foregroundColor: Colors.red,
          // color: Co ,
          toolbarHeight: 9.h,
          backgroundColor: const Color(0xff242320),
          elevation: 0.0,
          centerTitle: true),
      fontFamily: 'zet_regular',
      textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Colors.white,
          cursorColor: Colors.white.withOpacity(0.5)),
      textTheme: TextTheme(
        headline1: TextStyle(
            fontWeight: FontWeight.w400, color: Colors.white, fontSize: 36.sp),
        headline2: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 40.sp,
            color: const Color(0xff242320)),
        headline3: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 24.sp, color: Colors.white),
        headline4: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 24.sp,
            color: const Color(0xffC9C6BF)),
        headline6: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w400, fontSize: 20.sp),
        subtitle1: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20.sp,
            color: const Color(0xffFFBE3F)),
        subtitle2: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20.sp,
            color: Color(0xff242320)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        floatingLabelStyle: TextStyle(color: Colors.white),
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2)),
      ),
    );
  }
}
