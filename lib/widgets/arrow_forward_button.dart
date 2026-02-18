import 'package:bloc_architecure/core/constants/app_images.dart';
import 'package:bloc_architecure/core/theme/app_colors.dart';
import 'package:bloc_architecure/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ArrowForwardButton extends StatelessWidget {
  final double? size;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsets? padding;

  const ArrowForwardButton({
    super.key,
    this.size,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final containerSize = size ?? 5.screenWidth;
    final isDarkMode = isDark;
    final bgColor =
        backgroundColor ??
        (isDarkMode ? Colors.transparent : Colors.transparent);
    final border =
        borderColor ?? (isDarkMode ? AppColors.white : AppColors.white);
    final borderW = borderWidth ?? 1;
    final iconColor = isDarkMode ? AppColors.white : AppColors.black;
    final containerPadding = padding ?? EdgeInsets.only(right: 1.screenWidth);

    return Padding(
      padding: containerPadding,
      child: Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: border, width: borderW),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 0.5.screenWidth),
            child: SvgPicture.asset(
              AppImages.icon,
              height: 2.screenWidth,
              width: 1.screenWidth,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
