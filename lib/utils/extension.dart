import 'dart:math';

import 'package:bloc_architecure/core/constants/app_constant.dart';
import 'package:bloc_architecure/core/constants/app_images.dart';
import 'package:bloc_architecure/core/constants/app_labels.dart';
import 'package:bloc_architecure/core/constants/app_text_size.dart';
import 'package:bloc_architecure/core/constants/urls.dart';
import 'package:bloc_architecure/core/theme/app_colors.dart';
import 'package:bloc_architecure/core/theme/app_styles.dart';
import 'package:bloc_architecure/services/api_service.dart';
import 'package:bloc_architecure/services/get_storage_service.dart';
import 'package:bloc_architecure/services/hive_storage_service.dart';
import 'package:bloc_architecure/utils/api_result.dart';
import 'package:bloc_architecure/utils/app_exceptions.dart';
import 'package:bloc_architecure/widgets/button_widget.dart';
import 'package:bloc_architecure/widgets/custom_icon_widget.dart';
import 'package:bloc_architecure/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

//dependency injections getters
ApiService get apiService => GetIt.I<ApiService>();

GetStorageService get getStorageService => GetIt.I<GetStorageService>();

HiveStorageService get hiveStorageService => GetIt.I<HiveStorageService>();

// FireStoreService get firestoreService => Get.find<FireStoreService>();
//
// CouchService get couchService => Get.find<CouchService>();
// CouchbaseDatabaseService get couchbaseDatabaseService =>
//     Get.find<CouchbaseDatabaseService>();

//api response handler
extension ApiResultHandler<T> on ApiResult<T> {
  Future<R> handle<R>({
    required Future<R> Function(T response) onSuccess,
    required Future<R> Function(AppException error) onError,
  }) async {
    return isSuccess ? await onSuccess(data as T) : await onError(error!);
  }
}

//api responses handler
// extension ApiResultsHandler<T> on List<ApiResult<T>> {
//   Future<AppException?> handleMultiple() async {
//     return firstWhereOrNull((result) => result.error != null)?.error;
//   }
// }

extension EmptySpace on num {
  SizedBox get height => SizedBox(height: toDouble());

  SizedBox get sHeight => SizedBox(height: toDouble().screenHeight);

  SizedBox get width => SizedBox(width: toDouble());

  SizedBox get sWidth => SizedBox(width: toDouble().screenWidth);
}

extension ScreenSpace on num {
  double get screenHeight => 100 /*Get.height * (toDouble() / 100)*/;

  double get screenWidth => 100 /*Get.width * (toDouble() / 100)*/;
}

extension ColorFilterExtension on Color {
  ColorFilter get color => ColorFilter.mode(this, BlendMode.srcIn);
}

extension StringNullCheckExtension on String? {
  bool get isNullOrEmpty => this == null || (this?.isEmpty ?? true);
}

extension ListNullCheckExtension on List? {
  bool get isNullOrEmpty => this == null || (this?.isEmpty ?? true);
}

extension PricingExtension on double {
  String get toPrice =>
      (this - toInt()) == 0.0 ? toStringAsFixed(0) : toStringAsFixed(2);
}

extension ServerURL on String {
  String get toFineURL => "${URLs.imageBaseURL}$this";
}

/// Extension to remove HTML tags and decode HTML entities from strings
extension HtmlStripper on String {
  /// Removes all HTML tags and returns plain text
  /// Also decodes common HTML entities like &amp;, &lt;, &gt;, &quot;, &#39;, etc.
  String get removeHtmlTags {
    if (isEmpty) return this;

    String text = this;

    // Decode HTML entities first
    text = text
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&copy;', '©')
        .replaceAll('&reg;', '®')
        .replaceAll('&trade;', '™')
        .replaceAll('&mdash;', '—')
        .replaceAll('&ndash;', '–')
        .replaceAll('&hellip;', '…');

    // Remove HTML tags using regex
    // This regex matches <...> tags including attributes
    text = text.replaceAll(RegExp(r'<[^>]*>'), '');

    // Decode numeric HTML entities (&#123; or &#x1F;)
    text = text.replaceAllMapped(RegExp(r'&#(\d+);'), (match) {
      final code = int.tryParse(match.group(1) ?? '');
      if (code != null && code >= 0 && code <= 0x10FFFF) {
        return String.fromCharCode(code);
      }
      return match.group(0) ?? '';
    });

    text = text.replaceAllMapped(RegExp(r'&#x([0-9A-Fa-f]+);'), (match) {
      final code = int.tryParse(match.group(1) ?? '', radix: 16);
      if (code != null && code >= 0 && code <= 0x10FFFF) {
        return String.fromCharCode(code);
      }
      return match.group(0) ?? '';
    });

    // Clean up multiple spaces and newlines
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    return text;
  }

  String get removeHtmlTagsKeepNewLine {
    if (isEmpty) return this;

    String text = this;

    // Decode HTML entities first
    text = text
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&copy;', '©')
        .replaceAll('&reg;', '®')
        .replaceAll('&trade;', '™')
        .replaceAll('&mdash;', '—')
        .replaceAll('&ndash;', '–')
        .replaceAll('&hellip;', '…');

    // Remove HTML tags using regex
    // This regex matches <...> tags including attributes
    text = text.replaceAll(RegExp(r'<[^>]*>'), '');

    // Decode numeric HTML entities (&#123; or &#x1F;)
    text = text.replaceAllMapped(RegExp(r'&#(\d+);'), (match) {
      final code = int.tryParse(match.group(1) ?? '');
      if (code != null && code >= 0 && code <= 0x10FFFF) {
        return String.fromCharCode(code);
      }
      return match.group(0) ?? '';
    });

    text = text.replaceAllMapped(RegExp(r'&#x([0-9A-Fa-f]+);'), (match) {
      final code = int.tryParse(match.group(1) ?? '', radix: 16);
      if (code != null && code >= 0 && code <= 0x10FFFF) {
        return String.fromCharCode(code);
      }
      return match.group(0) ?? '';
    });

    // Clean up multiple spaces
    text = text
        .replaceAll(RegExp(r'[ \t]+'), ' ')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();

    return text;
  }
}

String? formatDateString(
  String? dateString,
  DateFormat format, {
  String? locale,
}) {
  if (dateString == null || dateString.isEmpty) return null;
  final date = DateTime.parse(dateString).toLocal();
  // Extract language code from locale string (e.g., "gu_IN" -> "gu", "en_US" -> "en")
  String localeToUse = locale ?? 'gu';
  if (localeToUse.contains('_')) {
    localeToUse = localeToUse.split('_').first;
  }
  try {
    // Create DateFormat with locale - locale data should be initialized at app startup
    final localizedFormat = DateFormat(format.pattern, localeToUse);
    return localizedFormat.format(date);
  } catch (e) {
    // Fallback to default format if locale is not available
    return format.format(date);
  }
}

String? formatDateTime(DateTime? date, DateFormat format, {String? locale}) {
  if (date == null) return null;
  // Extract language code from locale string (e.g., "gu_IN" -> "gu", "en_US" -> "en")
  String localeToUse = locale ?? 'gu';
  if (localeToUse.contains('_')) {
    localeToUse = localeToUse.split('_').first;
  }
  try {
    // Create DateFormat with locale - locale data should be initialized at app startup
    final localizedFormat = DateFormat(format.pattern, localeToUse);
    return localizedFormat.format(date.toLocal());
  } catch (e) {
    // Fallback to default format if locale is not available
    return format.format(date.toLocal());
  }
}

bool get checkKeyboardVisibility => 0 > 0;

double get keyboardHeight => 1;

void hideKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

double get topSafeArea => 1;

double get bottomSafeArea => 1;

Future<dynamic> getCustomAppDialog({
  required String title,
  required Widget child,
  void Function()? onClosePressed,
  bool barrierDismissible = true,
}) async {
  // return await showGeneralDialog(
  //   context: context,
  //   barrierColor: Colors.black.withValues(alpha: 0.5),
  //   transitionBuilder: (context, a1, a2, widget) {
  //     return Transform.scale(
  //       scale: a1.value,
  //       child: Opacity(
  //         opacity: a1.value,
  //         child: CustomAppDialog(
  //           title: title,
  //           onClosePressed: onClosePressed,
  //           child: child,
  //         ),
  //       ),
  //     );
  //   },
  //   transitionDuration: const Duration(milliseconds: 200),
  //   barrierDismissible: barrierDismissible,
  //   barrierLabel: '',
  //   pageBuilder: (context, anim1, anim2) => const SizedBox(),
  // );
}

void logOutDialog({
  required BuildContext context,
  required void Function() onLogoutUser,
  required bool isLoading,
}) {
  getCustomAppDialog(
    title: 'logout',
    barrierDismissible: false,
    onClosePressed: () {
      if (!isLoading) {}
    },
    child: Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppConstants.horizontalSpace,
        horizontal: AppConstants.horizontalSpace,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 20.screenWidth,
            height: 20.screenWidth,
            decoration: BoxDecoration(
              color: AppColors.black,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppImages.icon,
                width: 10.screenWidth,
                height: 10.screenWidth,
                colorFilter: AppColors.black.color,
              ),
            ),
          ),
          3.screenHeight.height,
          Text(
            'logoutConfirmation',
            style: AppStyles.regularTextStyle(
              size: AppTextSize.t16,
              color: AppColors.black,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          3.screenHeight.height,

          ButtonWidget(
            text: 'logout',
            isLoading: isLoading,
            isEnable: !isLoading,
            onPressed: onLogoutUser,
            prefixIcon: AppImages.icon,
            background: AppColors.white,
            textColor: AppColors.white,
            fontWeight: FontWeight.w700,
            height: 6.screenHeight,
            horizontal: 0,
            prefixIconHeight: 2.screenHeight,
          ),
        ],
      ),
    ),
  );
}

void deleteAccountDialog({
  required BuildContext context,
  required void Function() onDeleteUser,
  required bool isLoading,
}) {
  getCustomAppDialog(
    title: 'deleteAccount',
    barrierDismissible: false,
    onClosePressed: () {
      if (!isLoading) {}
    },
    child: Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppConstants.horizontalSpace,
        horizontal: AppConstants.horizontalSpace,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomIconWidget(
            icon: AppImages.icon,
            bgColor: AppColors.white,
            iconColor: AppColors.black,
            size: 7.screenHeight,
            iconSize: 4.screenHeight,
            radius: 5.screenWidth,
          ),
          1.sHeight,
          Text(
            'deleteAccountConfirmation',
            style: AppStyles.regularTextStyle(
              size: AppTextSize.t15,
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          3.sHeight,
          ButtonWidget(
            text: 'deleteAccount',
            isLoading: isLoading,
            isEnable: !isLoading,
            onPressed: onDeleteUser,
            height: 5.screenHeight,
            fontWeight: FontWeight.w700,
            textSize: AppTextSize.t16,
          ),
        ],
      ),
    ),
  );
}

void dynamicBackground({Color? color}) {
  final isDarkMode = isDark;
  final bgColor = color ?? (isDarkMode ? AppColors.black : Colors.white);
  final iconBrightness = isDarkMode ? Brightness.light : Brightness.dark;

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: bgColor,
      statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: iconBrightness,
      systemNavigationBarColor: bgColor,
      systemNavigationBarIconBrightness: iconBrightness,
    ),
  );
}

void viewerBackground({Color? color}) {
  final isDarkMode = isDark;
  final bgColor = color ?? (isDarkMode ? AppColors.black : Colors.black);
  final iconBrightness =
      Brightness.light; // Always light icons on dark background

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: bgColor,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: iconBrightness,
      systemNavigationBarColor: bgColor,
      systemNavigationBarIconBrightness: iconBrightness,
    ),
  );
}

void defaultBackground() {
  dynamicBackground(color: AppColors.white);
}

void primaryBackground() {
  final isDarkMode = isDark;
  final primaryColor = isDarkMode ? AppColors.black : AppColors.white;
  final iconBrightness = Brightness.light;

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: primaryColor,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: iconBrightness,
      systemNavigationBarColor: primaryColor,
      systemNavigationBarIconBrightness: iconBrightness,
    ),
  );
}

void transparentBackground() {
  dynamicBackground(color: Colors.transparent);
}

void get goHaptic {
  // Vibration disabled - no haptic feedback
  // (Platform.isAndroid) ? Vibration.vibrate(duration: 50, intensities: [0, 7, 12, 7, 0]) : HapticFeedback.mediumImpact();
}

void showLoginDialog(BuildContext context) {
  getCustomAppDialog(
    title: '',
    onClosePressed: () {},
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: AppConstants.verticalSpace),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalSpace / 2,
            ),
            child: Text(
              'userNotLoggedIn',
              style: AppStyles.regularTextStyle(
                size: AppTextSize.t16,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          3.sHeight,
          ButtonWidget(
            isWrapWidth: true,
            height: 5.screenHeight,
            text: 'drawer_register_signin',
            background: AppColors.black,
            textColor: AppColors.white,
            fontWeight: FontWeight.w700,
            onPressed: () {},
          ),
        ],
      ),
    ),
  );
}

Future<bool?> clearUserData(BuildContext context) async {
  try {
    // await hiveStorageService.clearSecureBox();
    // await getStorageService.clearAll();
    return true;
  } catch (err) {
    SnackBarWidget.showSnackBar(context, AppLabels.somethingWentWrong);
  }
  return null;
}

String generateId() {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final random = Random().nextInt(999999);
  return '$timestamp$random';
}

bool get isDark => false;

extension ThemeModeExtension on BuildContext {
  /// Toggles between dark and light mode
  void toggleThemeMode() {
    final themeService = null;
    if (themeService != null) {
      final currentIsDark = themeService.themeMode.value == ThemeMode.dark;
      themeService.toggleTheme(!currentIsDark);
    }
  }
}

/// Global helper function to toggle theme mode (can be used without BuildContext)
void toggleThemeMode() {
  final themeService = null;
  if (themeService != null) {
    final currentIsDark = themeService.themeMode.value == ThemeMode.dark;
    themeService.toggleTheme(!currentIsDark);
  }
}

String formatTime(double seconds) {
  final int sec = seconds.toInt();
  return "${(sec ~/ 60)}:${(sec % 60).toString().padLeft(2, '0')}";
}

Locale get getCurrentLanguage => Locale('gu', 'IN');

extension DigitLocalization on String {
  static const List<String> _guDigits = [
    '૦',
    '૧',
    '૨',
    '૩',
    '૪',
    '૫',
    '૬',
    '૭',
    '૮',
    '૯',
  ];

  String toGujaratiDigits() {
    return replaceAllMapped(RegExp(r'\d'), (match) {
      final digit = int.parse(match.group(0)!);
      return _guDigits[digit];
    });
  }

  String toLocalizedDigits({Locale? locale}) {
    final langCode = (locale ?? getCurrentLanguage).languageCode;
    if (langCode == 'gu') {
      return toGujaratiDigits();
    }
    return this;
  }
}

extension DigitLocalizationInt on int {
  String toLocalizedDigits({Locale? locale}) {
    return toString().toLocalizedDigits(locale: locale);
  }
}
