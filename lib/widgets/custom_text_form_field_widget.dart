import 'package:bloc_architecure/core/constants/app_constant.dart';
import 'package:bloc_architecure/core/constants/app_images.dart';
import 'package:bloc_architecure/core/constants/app_text_size.dart';
import 'package:bloc_architecure/core/constants/enums.dart';
import 'package:bloc_architecure/core/theme/app_colors.dart';
import 'package:bloc_architecure/core/theme/app_styles.dart';
import 'package:bloc_architecure/utils/extension.dart';
import 'package:bloc_architecure/utils/validation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextFormFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String? prefixIcon;
  final Widget? prefixWidget;
  final double? prefixWidth;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final FocusNode? focusNode;
  final Color? fillColor, textColor;
  final String hint;
  final double? cursorHeight;
  final ValidationType? validationType;
  final AutovalidateMode? validationMode;
  final String? title;
  final int maxLength;
  final FontWeight? hintFontWeight;
  final double? height;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onSuffixTap;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final int? maxLines;
  final EdgeInsetsGeometry? contentPadding;
  final bool isPasswordField;
  final bool isVisible;
  final String? newPassword;
  final bool enabled;
  final bool isPortrait;

  const CustomTextFormFieldWidget({
    super.key,
    required this.controller,
    this.prefixIcon,
    this.prefixWidget,
    this.prefixWidth,
    this.textInputAction,
    this.textInputType,
    this.fillColor,
    this.textColor,
    this.focusNode,
    this.cursorHeight,
    required this.hint,
    this.validationType,
    this.validationMode = AutovalidateMode.onUserInteraction,
    this.title,
    this.hintFontWeight,
    this.maxLength = 50,
    this.height,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.onChanged,
    this.onFieldSubmitted,
    this.onSuffixTap,
    this.hintStyle,
    this.textStyle,
    this.maxLines = 1,
    this.contentPadding,
    this.isVisible = true,
    this.isPasswordField = false,
    this.newPassword,
    this.enabled = true,
    this.isPortrait = true,
  });

  @override
  State<CustomTextFormFieldWidget> createState() =>
      _CustomTextFormFieldWidgetState();
}

class _CustomTextFormFieldWidgetState extends State<CustomTextFormFieldWidget> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isValidated = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _isFocused = _focusNode.hasFocus;
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChange);
    _checkValidation();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onTextChange() {
    _checkValidation();
  }

  void _checkValidation() {
    final text = widget.controller.text;
    bool isValid = false;

    if (text.isNotEmpty && widget.validationType != null) {
      final error = ValidationHelper.validate(
        widget.validationType!,
        text,
        newPassword: widget.newPassword,
      );
      isValid = error == null;
    } else {
      isValid = text.trim().isEmpty ? false : true;
    }

    if (_isValidated != isValid) {
      setState(() {
        _isValidated = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: EdgeInsets.symmetric(vertical: 1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.title != null
              ? Text(
                  widget.title!,
                  style: AppStyles.regularTextStyle(
                    size: AppTextSize.t14,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : 0.width,
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            textCapitalization: widget.textCapitalization,
            textInputAction: widget.textInputAction ?? TextInputAction.done,
            keyboardType: widget.textInputType ?? TextInputType.text,
            autovalidateMode: widget.validationMode,
            cursorColor: isDark ? AppColors.white : AppColors.black,
            validator: (value) {
              return widget.validationType != null
                  ? ValidationHelper.validate(
                      widget.validationType!,
                      value!,
                      newPassword: widget.newPassword,
                    )
                  : null;
            },
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onChanged: (value) {
              widget.onChanged?.call(value);
              _checkValidation();
            },
            onFieldSubmitted: widget.onFieldSubmitted,
            inputFormatters: [
              LengthLimitingTextInputFormatter(widget.maxLength),
              ...?widget.inputFormatters,
            ],
            textAlignVertical: TextAlignVertical.center,
            maxLines: widget.isPasswordField ? 1 : widget.maxLines,
            maxLength: widget.maxLength,
            obscureText: widget.isPasswordField ? !widget.isVisible : false,
            obscuringCharacter: "*",
            style:
                widget.textStyle ??
                AppStyles.regularTextStyle(
                  size: AppTextSize.t16,
                  color: widget.textColor ?? AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
            decoration: InputDecoration(
              contentPadding: widget.contentPadding,
              hintText: widget.hint,
              enabled: widget.enabled,
              hintStyle:
                  widget.hintStyle ??
                  AppStyles.regularTextStyle(
                    size: AppTextSize.t16,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                  ),
              fillColor: widget.enabled
                  ? (_isFocused || widget.controller.text.trim().isNotEmpty
                        ? (isDark
                              ? (widget.fillColor ?? AppColors.white)
                              : AppColors.white)
                        : (widget.fillColor ?? AppColors.white))
                  : (widget.fillColor != null
                        ? widget.fillColor!
                        : (isDark ? AppColors.white : AppColors.white)),
              filled: true,
              errorMaxLines: 2,
              counterText: '',
              errorStyle: AppStyles.regularTextStyle(
                size: AppTextSize.t14,
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
              prefixIconConstraints: BoxConstraints(
                maxWidth: widget.prefixWidth ?? 9.5.screenWidth,
              ),
              prefixIcon:
                  widget.prefixWidget ??
                  (widget.prefixIcon == null
                      ? null
                      : Padding(
                          padding: EdgeInsets.only(
                            left: 3.screenWidth,
                            right: 1.screenWidth,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              widget.prefixIcon!,
                              width: 5.5.screenWidth,
                              fit: BoxFit.fitWidth,
                              colorFilter: AppColors.black.color,
                            ),
                          ),
                        )),
              suffixIconConstraints: BoxConstraints(
                maxWidth: widget.isPasswordField
                    ? 16.5.screenWidth
                    : 14.5.screenWidth,
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: 3.screenWidth,
                      left: 1.screenWidth,
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      ),
                      child: _isValidated
                          ? SvgPicture.asset(
                              AppImages.icon,
                              fit: BoxFit.fitWidth,
                              width: 4.screenWidth,
                              key: ValueKey('validated'),
                            )
                          : const SizedBox(width: 0, key: ValueKey('empty')),
                    ),
                  ),
                  !widget.isPasswordField
                      ? 0.width
                      : InkWell(
                          overlayColor: WidgetStatePropertyAll(
                            Colors.transparent,
                          ),
                          onTap: widget.onSuffixTap,
                          child: Padding(
                            padding: EdgeInsets.only(right: 3.screenWidth),
                            child: SvgPicture.asset(
                              widget.isVisible
                                  ? AppImages.icon
                                  : AppImages.icon,
                              fit: BoxFit.fitWidth,
                              width: 5.5.screenWidth,
                              colorFilter: AppColors.black.color,
                            ),
                          ),
                        ),
                ],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: BorderSide(color: AppColors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: BorderSide(color: AppColors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: BorderSide(color: AppColors.black),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: BorderSide(color: AppColors.black),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: BorderSide(color: AppColors.black),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                borderSide: BorderSide(color: AppColors.black),
              ),
            ),
            cursorHeight: widget.cursorHeight,
          ),
        ],
      ),
    );
  }
}
