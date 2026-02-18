import 'package:bloc_architecure/core/constants/app_constant.dart';
import 'package:bloc_architecure/core/constants/app_text_size.dart';
import 'package:bloc_architecure/core/theme/app_colors.dart';
import 'package:bloc_architecure/core/theme/app_styles.dart';
import 'package:bloc_architecure/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpFieldWidget extends StatefulWidget {
  final int length;
  final double horPadding;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onOTPChange;
  final int separators;

  const OtpFieldWidget({
    super.key,
    required this.length,
    required this.horPadding,
    required this.controller,
    required this.onOTPChange,
    required this.focusNode,
    this.separators = 2,
  });

  @override
  State<OtpFieldWidget> createState() => _OtpFieldWidgetState();
}

class _OtpFieldWidgetState extends State<OtpFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.horPadding),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IgnorePointer(
            ignoring: true,
            child: TextFormField(
              enableInteractiveSelection: false,
              focusNode: widget.focusNode,
              showCursor: false,
              controller: widget.controller,
              textAlign: TextAlign.center,
              style: AppStyles.regularTextStyle(
                size: AppTextSize.t20,
                color: Colors.transparent,
              ),
              cursorColor: Colors.transparent,
              textAlignVertical: TextAlignVertical.center,
              onTapOutside: (event) {
                widget.focusNode.unfocus();
              },
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(widget.length),
              ],
              decoration: const InputDecoration.collapsed(hintText: ''),
              onChanged: (value) {
                setState(() {});
                widget.onOTPChange.call(value);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: () {
              final children = <Widget>[];
              if (widget.separators <= 1) {
                // No grouping, show all fields with individual radius
                for (int index = 0; index < widget.length; index++) {
                  final isFirst = index == 0;
                  final isLast = index == widget.length - 1;
                  children.add(
                    _otpView(
                      index,
                      hasLeftRadius: isFirst,
                      hasRightRadius: isLast,
                      hasNoRadius: !isFirst && !isLast,
                      isCornerBox: isLast,
                    ),
                  );
                }
              } else {
                // Calculate fields per group
                final fieldsPerGroup = widget.length ~/ widget.separators;
                final remainder = widget.length % widget.separators;

                int currentIndex = 0;
                for (
                  int groupIndex = 0;
                  groupIndex < widget.separators;
                  groupIndex++
                ) {
                  // Calculate actual fields in this group (distribute remainder)
                  final fieldsInGroup =
                      fieldsPerGroup + (groupIndex < remainder ? 1 : 0);

                  // Add fields for this group
                  for (int i = 0; i < fieldsInGroup; i++) {
                    final fieldIndex = currentIndex + i;
                    final isFirstInGroup = i == 0;
                    final isLastInGroup = i == fieldsInGroup - 1;
                    final isFirstGroup = groupIndex == 0;
                    final isLastGroup = groupIndex == widget.separators - 1;

                    // Determine border radius based on group position
                    bool hasLeftRadius = false;
                    bool hasRightRadius = false;
                    bool hasNoRadius = false;

                    if (isFirstGroup && isFirstInGroup) {
                      // First group's first field: left radius only
                      hasLeftRadius = true;
                    } else if (isLastGroup && isLastInGroup) {
                      // Last group's last field: right radius only
                      hasRightRadius = true;
                    } else {
                      // All other fields: no radius (straight edges)
                      hasNoRadius = true;
                    }

                    children.add(
                      _otpView(
                        fieldIndex,
                        hasLeftRadius: hasLeftRadius,
                        hasRightRadius: hasRightRadius,
                        hasNoRadius: hasNoRadius,
                        isCornerBox: isLastInGroup,
                      ),
                    );
                  }

                  currentIndex += fieldsInGroup;

                  // Add separator after group (except for last group)
                  if (groupIndex < widget.separators - 1) {
                    children.add(
                      Expanded(
                        child: Center(
                          child: Text(
                            '-',
                            style: AppStyles.regularTextStyle(
                              size: AppTextSize.t20,
                              color: AppColors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }
              }
              return children;
            }(),
          ),
        ],
      ),
    );
  }

  Widget _otpView(
    int index, {
    bool hasLeftRadius = false,
    bool hasRightRadius = false,
    bool hasNoRadius = false,
    bool isCornerBox = false,
  }) {
    final isFilled =
        widget.controller.text.length > index &&
        widget.controller.text.isNotEmpty;

    BorderRadius borderRadius;
    if (hasNoRadius) {
      // Middle groups: no radius (straight edges)
      borderRadius = BorderRadius.zero;
    } else if (hasLeftRadius && hasRightRadius) {
      // Single field or first/last field in a group
      borderRadius = BorderRadius.circular(AppConstants.borderRadius);
    } else if (hasLeftRadius) {
      // First field in group: left radius only
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(AppConstants.borderRadius),
        bottomLeft: Radius.circular(AppConstants.borderRadius),
      );
    } else if (hasRightRadius) {
      // Last field in group: right radius only
      borderRadius = BorderRadius.only(
        topRight: Radius.circular(AppConstants.borderRadius),
        bottomRight: Radius.circular(AppConstants.borderRadius),
      );
    } else {
      // Default: no radius (straight edges)
      borderRadius = BorderRadius.zero;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0.screenWidth),
      child: InkWell(
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        borderRadius: borderRadius,
        onTap: () {
          widget.focusNode.requestFocus();
        },
        child: Container(
          width: (80 / widget.length).screenWidth,
          height: (80 / widget.length).screenWidth,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: borderRadius,
            border: Border(
              bottom: BorderSide(color: AppColors.black, width: 1),
              top: BorderSide(color: AppColors.black, width: 1),
              left: BorderSide(color: AppColors.black, width: 1),
              right: isCornerBox
                  ? BorderSide(color: AppColors.black, width: 1)
                  : BorderSide.none,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            isFilled ? widget.controller.text[index] : "",
            style: AppStyles.regularTextStyle(
              size: AppTextSize.t20,
              color: AppColors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
