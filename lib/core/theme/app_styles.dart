import 'package:bloc_architecure/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppStyles {
  static const String notoSans = "NotoSans";

  static TextStyle regularTextStyle({
    Color? color,
    required double size,
    FontWeight fontWeight = FontWeight.w400,
    double letterSpacing = 0,
    double wordSpacing = 0,
    String? fontFamily,
    double? lineHeight,
    List<String>? fallbackFontFamily,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fallbackFontFamily,
      letterSpacing: letterSpacing,
      height: lineHeight,
      wordSpacing: wordSpacing,
      color: color ?? AppColors.black,
      fontSize: size,
      fontWeight: fontWeight,
      fontVariations: fontFamily == notoSans
          ? [
              fontWeight == FontWeight.w300
                  ? FontVariation('wght', 300)
                  : fontWeight == FontWeight.w400
                  ? FontVariation('wght', 400)
                  : fontWeight == FontWeight.w500
                  ? FontVariation('wght', 500)
                  : fontWeight == FontWeight.w600
                  ? FontVariation('wght', 600)
                  : fontWeight == FontWeight.w700
                  ? FontVariation('wght', 700)
                  : fontWeight == FontWeight.bold
                  ? FontVariation('wght', 700)
                  : fontWeight == FontWeight.w800
                  ? FontVariation('wght', 800)
                  : fontWeight == FontWeight.w900
                  ? FontVariation('wght', 900)
                  : FontVariation('wght', 400),
            ]
          : null,
    );
  }
}
