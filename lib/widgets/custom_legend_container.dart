import 'package:bloc_architecure/core/constants/app_constant.dart';
import 'package:bloc_architecure/core/theme/app_colors.dart';
import 'package:bloc_architecure/utils/extension.dart';
import 'package:flutter/material.dart';

import 'package:bloc_architecure/core/constants/app_text_size.dart';
import 'package:bloc_architecure/core/theme/app_styles.dart';

class CustomLegendContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomLegendContainer({
    super.key,
    required this.title,
    required this.child,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 9),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.black),
              borderRadius: BorderRadius.circular(
                borderRadius ?? AppConstants.borderRadius,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: .5.screenHeight),
              child: child,
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.screenWidth),
            color: AppColors.white,
            child: Text(
              title,
              style: AppStyles.regularTextStyle(
                size: AppTextSize.t15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
