import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:bloc_architecure/core/theme/app_colors.dart';
import 'package:bloc_architecure/utils/extension.dart';

class CustomIconWidget extends StatelessWidget {
  final String icon;
  final double size;
  final double iconSize;
  final Color? bgColor;
  final double radius;
  final Color? borderColor;
  final bool isBorderVisible;
  final List<BoxShadow>? shadow;
  final Color? iconColor;

  const CustomIconWidget({
    super.key,
    required this.icon,
    this.size = kToolbarHeight * 0.8,
    this.iconSize = kToolbarHeight * 0.4,
    this.bgColor,
    this.radius = kToolbarHeight * 0.2,
    this.borderColor,
    this.isBorderVisible = false,
    this.shadow,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor ?? (isDark ? AppColors.white : AppColors.white),
        borderRadius: BorderRadius.circular(radius),
        border: isBorderVisible
            ? Border.all(color: borderColor ?? AppColors.black)
            : null,
        boxShadow: shadow,
      ),
      child: SvgPicture.asset(
        icon,
        width: iconSize,
        height: iconSize,
        colorFilter: (iconColor ?? AppColors.black).color,
      ),
    );
  }
}
