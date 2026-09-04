import 'package:flutter/material.dart';

/// This class contains all the colors of the app.
class AppColors {
  //Brand Colors
  static const Color scaffoldColor = Color(0xfff6f7f9);
  static const Color fontColor = Color(0xff444e5e);
  static const Color fontColor2 = Color(0xff8294ae);
  static const Color fontColor3 = Color(0xff989898);
  static const Color mainColorFont = Color(0xff384354);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color transparent = Colors.transparent;
  static const Color primaryColor = Color(0xFF4FB3AB);
  static const Color secondaryColor = Color(0xFF033D75);
  static Color dangerColor = const Color(0xffD64545);
  static Color purpleColor = const Color(0xff905bfe);

  static const MaterialColor primarySwatch = MaterialColor(
    0xFF63C7BF,
    <int, Color>{
      50: Color(0xFFF0FAF9),
      100: Color(0xFFD8F1EE),
      200: Color(0xFFB1E4DF),
      300: Color(0xFF8AD7D0),
      400: Color(0xFF73CEC7),
      500: Color(0xFF63C7BF),
      600: Color(0xFF4FB3AB),
      700: Color(0xFF40918A),
      800: Color(0xFF357670),
      900: Color(0xFF2B615C),
      950: Color(0xFF163534),
    },
  );

  static const MaterialColor secondarySwatch = MaterialColor(
    0xFF033D75,
    <int, Color>{
      50: Color(0xFFEAF3FB),
      100: Color(0xFFCFE1F4),
      200: Color(0xFFA0C3E9),
      300: Color(0xFF6EA4DD),
      400: Color(0xFF458AD3),
      500: Color(0xFF033D75),
      600: Color(0xFF033665),
      700: Color(0xFF022D55),
      800: Color(0xFF022447),
      900: Color(0xFF011C39),
      950: Color(0xFF010F1F),
    },
  );

  //grey
  static const MaterialColor greySwatch = MaterialColor(
    0xFFA39F9F,
    <int, Color>{
      50: Color(0xfff8f8f8),
      100: Color(0xFFF0EFEF),
      200: Color(0xFFE9E8E8),
      300: Color(0xFFDAD8D8),
      400: Color(0xFFC6C3C3),
      500: Color(0xFFA39F9F),
      600: Color(0xFF6b6b6b),
      700: Color(0xFF4D4949),
      800: Color(0xFF333232),
      900: Color(0xFF262525),
    },
  );

  //danger
  static const MaterialColor dangerSwatch = MaterialColor(
    0xFFBC2A23,
    <int, Color>{
      50: Color(0xFFF8E8E7),
      100: Color(0xFFF2D4D3),
      200: Color(0xFFE4AAA7),
      300: Color(0xFFD77F7B),
      400: Color(0xFFC9554F),
      500: Color(0xFFBC2A23),
      600: Color(0xFF962923),
      700: Color(0xFF712724),
      800: Color(0xFF3C2625),
      900: Color(0xFF413130),
    },
  );

  //success
  static const MaterialColor successSwatch = MaterialColor(
    0xFF35C75A,
    <int, Color>{
      50: Color(0xFFEAFDE7),
      100: Color(0xFFDCFCD7),
      200: Color(0xFFB2F9B0),
      300: Color(0xFF85EE8B),
      400: Color(0xFF63DD76),
      500: Color(0xFF35C75A),
      600: Color(0xFF26AB55),
      700: Color(0xFF1A8F4E),
      800: Color(0xFF107346),
      900: Color(0xFF304133),
    },
  );
}
