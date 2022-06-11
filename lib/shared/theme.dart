import 'package:flutter/material.dart';

class AbrabarTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xff242320),
      primaryColor: const Color(0xffFF3F6D),
      appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff242320),
          elevation: 0.0,
          centerTitle: true),
      fontFamily: 'zet_regular',
      textTheme: const TextTheme(
        headline1: TextStyle(
            fontWeight: FontWeight.w400, color: Colors.white, fontSize: 36),
        headline2: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 40,
            color: Color(0xff242320)),
        headline3: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 24, color: Colors.white),
        headline4: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 24,
            color: Color(0xffC9C6BF)),
        subtitle1: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20,
            color: Color(0xffFFBE3F)),
        subtitle2: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20,
            color: Color(0xff242320)),
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
