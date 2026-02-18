class URLs {
  static String baseURL = "";
  static String imageBaseURL = "";
  static String couchURL = "";
  static String couchUsername = "";
  static String couchPassword = "";
  static bool isProduction = true;
}

abstract class EndPoints {
  static const String baseURLVersion = '/v1';
  static String signIn = '$baseURLVersion/mobile/auth/login';
  static const String refreshToken = '$baseURLVersion/mobile/auth/refresh';
}
