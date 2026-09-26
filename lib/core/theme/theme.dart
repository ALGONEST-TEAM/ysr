import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.scaffoldColor,
  primarySwatch: AppColors.primarySwatch,
  splashColor: AppColors.primaryColor.withValues(alpha: .1),
  highlightColor: AppColors.primaryColor.withValues(alpha: .1),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  ),
  tabBarTheme: TabBarThemeData(
    labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    dividerColor: Colors.transparent,
    labelColor: Colors.white,
    unselectedLabelColor: AppColors.fontColor,
    indicatorColor: Colors.transparent,
    overlayColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        return AppColors.primaryColor.withValues(alpha: 0.1);
      },
    ),
    unselectedLabelStyle: const TextStyle(fontFamily: "IBMPlexSansArabic", fontWeight: FontWeight.w500),
    labelStyle: const TextStyle(fontFamily: "IBMPlexSansArabic", fontWeight: FontWeight.w700),
    indicatorSize: TabBarIndicatorSize.tab,
    indicator: BoxDecoration(
      color: AppColors.primaryColor,
      borderRadius: BorderRadius.circular(20),
    ),
    dividerHeight: 0,
    tabAlignment: TabAlignment.start,
  ),
  fontFamily: 'IBMPlexSansArabic',
);
