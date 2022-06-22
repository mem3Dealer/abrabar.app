import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AbrabarTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xff242320),
      primaryColor: const Color(0xffFF3F6D),
      appBarTheme: AppBarTheme(
          toolbarHeight: 9.h,
          backgroundColor: const Color(0xff242320),
          elevation: 0.0,
          centerTitle: true),
      fontFamily: 'zet_regular',
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
        subtitle1: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20.sp,
            color: const Color(0xffFFBE3F)),
        subtitle2: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20.sp,
            color: const Color(0xff242320)),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2)),
      ),
    );
  }
}
