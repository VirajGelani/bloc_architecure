// import 'package:flutter/material.dart';
//
// class LanguageService {
//   final currentLocale = const Locale('gu', 'IN');
//
//   void changeLanguage(String langCode, String countryCode) {
//     final locale = Locale(langCode, countryCode);
//     currentLocale.value = locale;
//     Get.updateLocale(locale);
//   }
//
//   bool get isNotoFamily => currentLocale.value.languageCode == 'en';
//
//   String get currentFontFamily {
//     final langCode = currentLocale.value.languageCode;
//     if (langCode == 'gu') {
//       return 'NotoSansGujarati';
//     }
//     return isNotoFamily ? 'NotoSans' : 'MuktaVaani';
//   }
// }
