import 'package:bloc_architecure/core/constants/app_constant.dart';
import 'package:bloc_architecure/core/constants/app_text_size.dart';
import 'package:bloc_architecure/core/theme/app_colors.dart';
import 'package:bloc_architecure/core/theme/app_styles.dart';
import 'package:bloc_architecure/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyDataWidget extends StatelessWidget {
  final String title;
  final String? image;
  final double? imageHeight;
  final double? imageWidth;
  final EdgeInsetsGeometry? padding;

  const EmptyDataWidget({
    super.key,
    required this.title,
    this.image,
    this.imageHeight,
    this.imageWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ??
          EdgeInsets.symmetric(
            vertical: AppConstants.verticalSpace,
            horizontal: AppConstants.horizontalSpace,
          ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (image != null) ...[
            SvgPicture.asset(
              image!,
              height: imageHeight,
              width: imageWidth,
              fit: BoxFit.contain,
            ),
            5.sHeight,
          ],
          Text(
            title,
            style: AppStyles.regularTextStyle(
              size: AppTextSize.t16,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
