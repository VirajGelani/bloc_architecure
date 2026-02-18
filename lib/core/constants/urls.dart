import 'package:bloc_architecure/core/constants/app_constant.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class URLs {
  static String get baseURL =>
      dotenv.env[AppConstants.baseUrlKey] ?? '';

  static String get imageBaseURL =>
      dotenv.env[AppConstants.imageUrlKey] ?? '';

  static String get couchURL =>
      dotenv.env[AppConstants.couchUrlKey] ?? '';

  static String get couchUsername =>
      dotenv.env[AppConstants.couchUsernameKey] ?? '';

  static String get couchPassword =>
      dotenv.env[AppConstants.couchPasswordKey] ?? '';

  static bool get isProduction {
    final value = dotenv.env['IS_PRODUCTION'];
    if (value == null) return true;
    return value.toLowerCase() == 'true';
  }
}

abstract class EndPoints {
  static const String baseURLVersion = '/v1';
  static String signIn = '$baseURLVersion/mobile/auth/login';
  static const String refreshToken = '$baseURLVersion/mobile/auth/refresh';
}
