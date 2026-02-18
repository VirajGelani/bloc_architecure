import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:bloc_architecure/core/theme/app_colors.dart';
import 'package:bloc_architecure/core/theme/app_styles.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    primaryColor: AppColors.black,
    colorScheme: ColorScheme.light(
      primary: AppColors.black,
      secondary: AppColors.black,
      error: AppColors.black,
    ),
    fontFamily: AppStyles.notoSans,
    textTheme: _buildTextTheme(isDark: false),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      titleTextStyle: AppStyles.regularTextStyle(
        size: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
      iconTheme: IconThemeData(color: AppColors.black),
    ),
  );

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.black,
    primaryColor: AppColors.black,
    colorScheme: ColorScheme.dark(
      primary: AppColors.black,
      secondary: AppColors.black,
      error: AppColors.black,
    ),
    fontFamily: AppStyles.notoSans,
    textTheme: _buildTextTheme(isDark: true),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.black,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      titleTextStyle: AppStyles.regularTextStyle(
        size: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
      iconTheme: IconThemeData(color: AppColors.white),
    ),
  );

  static TextTheme _buildTextTheme({required bool isDark}) {
    final color = isDark ? AppColors.white : AppColors.black;
    return TextTheme(
      displayLarge: AppStyles.regularTextStyle(
        size: 32.sp,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      titleLarge: AppStyles.regularTextStyle(
        size: 20.sp,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      bodyLarge: AppStyles.regularTextStyle(
        size: 16.sp,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      bodyMedium: AppStyles.regularTextStyle(
        size: 14.sp,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      labelLarge: AppStyles.regularTextStyle(
        size: 14.sp,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }
}
