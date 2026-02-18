import 'package:bloc_architecure/core/constants/app_constant.dart';
import 'package:bloc_architecure/core/constants/app_images.dart';
import 'package:bloc_architecure/core/theme/app_styles.dart';
import 'package:bloc_architecure/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:bloc_architecure/core/constants/app_text_size.dart';
import 'package:bloc_architecure/core/theme/app_colors.dart';
import 'package:bloc_architecure/widgets/bounceable.dart';

class CustomAppDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final void Function()? onClosePressed;

  const CustomAppDialog({
    super.key,
    required this.title,
    required this.child,
    this.onClosePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMain),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMain),
          border: Border.all(color: AppColors.black, width: 2),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 2.screenWidth,
            horizontal: 2.screenWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  SizedBox(width: double.infinity, height: 5.screenWidth),
                  // Title centered
                  Center(
                    child: Text(
                      title,
                      style: AppStyles.regularTextStyle(
                        size: AppTextSize.t19,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Close button positioned slightly below
                  Positioned(
                    right: 0,
                    top: 3.screenWidth,
                    child: Bounceable(
                      onTap: onClosePressed,
                      child: SvgPicture.asset(
                        AppImages.icon,
                        width: 5.screenWidth,
                        height: 5.screenWidth,
                        colorFilter: AppColors.black.color,
                      ),
                    ),
                  ),
                ],
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
