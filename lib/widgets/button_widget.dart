import 'package:bloc_architecure/core/constants/app_constant.dart';
import 'package:bloc_architecure/core/constants/app_text_size.dart';
import 'package:bloc_architecure/core/theme/app_colors.dart';
import 'package:bloc_architecure/core/theme/app_styles.dart';
import 'package:bloc_architecure/utils/extension.dart';
import 'package:bloc_architecure/widgets/custom_tap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final bool isEnable;
  final double? textSize;
  final Color? background;
  final Color? textColor;
  final double? horizontal;
  final double? height;
  final double? width;
  final FontWeight? fontWeight;
  final Color? splashColor;
  final bool? isWrapWidth;
  final double? borderRadius;
  final String? prefixIcon;
  final double? prefixIconHeight;
  final double? prefixIconWidth;
  final String? suffixIcon;
  final BoxFit? prefixIconFit;
  final double? suffixIconHeight;
  final double? suffixIconWidth;
  final BoxFit? suffixIconFit;
  final double? horPadding;
  final bool isPrimary;
  final Color? borderColor;
  final bool isLoading;
  final double? prefixSpacing;
  final double? suffixSpacing;
  final bool useDashboardColors;

  const ButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
    this.isEnable = true,
    this.textSize,
    this.background,
    this.textColor,
    this.horizontal,
    this.height,
    this.width,
    this.fontWeight,
    this.splashColor,
    this.isWrapWidth,
    this.borderRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.horPadding,
    this.isPrimary = true,
    this.borderColor,
    this.isLoading = false,
    this.prefixIconHeight,
    this.prefixIconWidth,
    this.prefixIconFit,
    this.suffixIconHeight,
    this.suffixIconWidth,
    this.suffixIconFit,
    this.prefixSpacing,
    this.suffixSpacing,
    this.useDashboardColors = false,
  });

  @override
  Widget build(BuildContext context) {
    final double btnHeight = height ?? 6.screenHeight;

    // Determine default colors based on theme mode
    final Color defaultBackground = useDashboardColors
        ? (isPrimary ? AppColors.black : AppColors.black)
        : (isPrimary
              ? (isDark ? AppColors.black : AppColors.black)
              : (isDark ? AppColors.black : AppColors.black));

    final Color defaultBorderColor = useDashboardColors
        ? (isPrimary ? AppColors.black : AppColors.black)
        : (isPrimary
              ? (isDark ? AppColors.black : AppColors.black)
              : (isDark ? AppColors.black : AppColors.black));

    final Color defaultTextColor = useDashboardColors
        ? (isPrimary ? AppColors.black : AppColors.black)
        : (isPrimary
              ? (isDark ? AppColors.black : AppColors.white)
              : (isDark ? AppColors.black : AppColors.white));

    return CustomTap(
      onTap: isEnable
          ? isLoading
                ? null
                : onPressed
          : null,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontal ?? 0),
        width: isWrapWidth ?? false ? null : width ?? double.maxFinite,
        height: btnHeight,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: background ?? defaultBackground,
          border: Border.all(color: borderColor ?? defaultBorderColor),
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius ?? AppConstants.borderRadius),
          ),
          boxShadow: isEnable
              ? [
                  BoxShadow(
                    color: (background ?? defaultBackground),
                    offset: Offset(0, 0),
                    blurRadius: 0,
                    spreadRadius: 1.15,
                  ),
                  BoxShadow(
                    color: (background ?? defaultBackground).withValues(
                      alpha: .48,
                    ),
                    offset: Offset(0, 1.15),
                    blurRadius: 2.29,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: MaterialButton(
          minWidth: 0.1.sw,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppConstants.borderRadius,
            ),
          ),
          onPressed: null,
          padding: horPadding == null
              ? null
              : EdgeInsets.symmetric(horizontal: horPadding ?? 0),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: textColor ?? defaultTextColor,
                    strokeWidth: height != null ? 2 : null,
                    constraints: BoxConstraints(
                      maxHeight: btnHeight * .7,
                      maxWidth: btnHeight * .7,
                      minHeight: btnHeight * .5,
                      minWidth: btnHeight * .5,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    prefixIcon != null
                        ? SvgPicture.asset(
                            prefixIcon!,
                            height: prefixIconHeight ?? btnHeight * .4,
                            width: prefixIconWidth,
                            fit: prefixIconFit ?? BoxFit.fitHeight,
                            colorFilter: ColorFilter.mode(
                              textColor ?? defaultTextColor,
                              BlendMode.srcIn,
                            ),
                          )
                        : 0.width,
                    if (prefixIcon != null) (prefixSpacing ?? 3).sWidth,
                    Padding(
                      padding: EdgeInsets.only(top: 0.2.screenHeight),
                      child: Text(
                        text,
                        style: AppStyles.regularTextStyle(
                          color: textColor ?? defaultTextColor,
                          size: textSize ?? AppTextSize.t18,
                          fontWeight: fontWeight ?? FontWeight.w400,
                          // fontFamily: AppStyles.aleo,
                        ),
                      ),
                    ),

                    1.sWidth,

                    if (suffixIcon != null) (suffixSpacing ?? 3).sWidth,
                    suffixIcon != null
                        ? SvgPicture.asset(
                            suffixIcon!,
                            height: suffixIconHeight ?? btnHeight * .4,
                            width: suffixIconWidth,
                            fit: suffixIconFit ?? BoxFit.fitHeight,
                            colorFilter: ColorFilter.mode(
                              textColor ?? defaultTextColor,
                              BlendMode.srcIn,
                            ),
                          )
                        : 0.width,
                  ],
                ),
        ),
      ),
    );
  }
}
