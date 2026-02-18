import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const shimmerBase = Color(0xFFFFFBF9);
  static const shimmerHighlight = Color(0xFFA1A1A2);

  static const Color shimmerBaseLight = Color(0xFFFFF5E4);
  static const Color shimmerHighlightLight = Color(0xFFFFFEF1);
  static const Color shimmerBaseDark = Color(0xFF3F2F24);
  static const Color shimmerHighlightDark = Color(0xFF6B5A4F);

  static Gradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [white, Colors.transparent],
    stops: const [0.406, 1],
  );
}
