import 'package:flutter/material.dart';

import 'package:bloc_architecure/core/constants/app_constant.dart';
import 'package:bloc_architecure/core/theme/app_styles.dart';
import 'package:bloc_architecure/core/constants/app_text_size.dart';

class SnackBarWidget {
  SnackBarWidget._();

  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = true,
    int durationMs = 3000,
    bool isInfinite = false,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = isError
        ? (colorScheme.errorContainer)
        : (colorScheme.primaryContainer);
    final foregroundColor = isError
        ? (colorScheme.onErrorContainer)
        : (colorScheme.onPrimaryContainer);

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppStyles.regularTextStyle(
            size: AppTextSize.t15,
            color: foregroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalSpace,
          vertical: AppConstants.verticalSpace,
        ),
        duration: isInfinite
            ? const Duration(days: 365)
            : Duration(milliseconds: durationMs),
        dismissDirection: DismissDirection.down,
      ),
    );
  }

  static void hide(BuildContext context) {
    ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
  }
}
