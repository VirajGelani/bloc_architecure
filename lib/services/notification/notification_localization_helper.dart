/*
import 'package:shikshapatri/app/core/constants/enums.dart';
import 'package:shikshapatri/l10n/app_localizations.dart';
import 'package:shikshapatri/l10n/app_localizations_en.dart';
import 'package:shikshapatri/l10n/app_localizations_gu.dart';
import 'package:shikshapatri/l10n/app_localizations_hi.dart';

/// Helper to get AppLocalizations instance from locale string
/// Used for notifications scheduled in background without context
class NotificationLocalizationHelper {
  /// Get AppLocalizations instance from locale code
  static AppLocalizations getLocalizations(String localeCode) {
    final code = localeCode.split('_').first.toLowerCase();

    switch (code) {
      case 'gu':
        return AppLocalizationsGu(LanguageType.gujarati.langCode);
      case 'hi':
        return AppLocalizationsHi(LanguageType.hindi.langCode);
      case 'en':
        return AppLocalizationsEn(LanguageType.english.langCode);
      default:
        return AppLocalizationsEn(LanguageType.english.langCode);
    }
  }

  /// Get localized string by key from locale code
  static String getLocalizedString(String localeCode, String Function(AppLocalizations) getter) {
    final localizations = getLocalizations(localeCode);
    return getter(localizations);
  }
}
*/
