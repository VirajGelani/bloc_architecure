import 'dart:developer';
import 'dart:io';

import 'package:bloc_architecure/core/auth/auth_session_manager.dart';
import 'package:bloc_architecure/core/constants/urls.dart';
import 'package:bloc_architecure/services/hive_storage_service.dart';
import 'package:bloc_architecure/services/get_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._dio);

  final Dio _dio;
  final AuthSessionManager _sessionManager = GetIt.I<AuthSessionManager>();
  final HiveStorageService _hiveStorage = GetIt.I<HiveStorageService>();
  final GetStorageService _getStorage = GetIt.I<GetStorageService>();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _hiveStorage.authToken;
    if (token != null && token.isNotEmpty) {
      options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final refreshToken = await _hiveStorage.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      await _clearAllDataAndNotify();
      return handler.next(err);
    }

    try {
      final newAccessToken = await _refreshToken(refreshToken);
      if (newAccessToken == null || newAccessToken.isEmpty) {
        await _clearAllDataAndNotify();
        return handler.next(err);
      }

      await _hiveStorage.setAuthToken(newAccessToken);

      final requestOptions = err.requestOptions;
      requestOptions.headers[HttpHeaders.authorizationHeader] =
          'Bearer $newAccessToken';

      final response = await _dio.fetch(requestOptions);
      return handler.resolve(response);
    } catch (e) {
      log('AuthInterceptor: refresh token failed', error: e);
      await _clearAllDataAndNotify();
      return handler.next(err);
    }
  }

  /// Calls refresh token API with a bare Dio (no interceptors) to avoid loops.
  /// Returns new access token or null on failure.
  Future<String?> _refreshToken(String refreshToken) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: URLs.baseURL,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );

    final response = await dio.post<Map<String, dynamic>>(
      EndPoints.refreshToken,
      data: <String, dynamic>{'refreshToken': refreshToken},
    );

    final data = response.data;
    if (data == null) return null;

    final fromRoot = data['accessToken'] as String?;
    if (fromRoot != null) return fromRoot;
    final nested = data['data'];
    if (nested is Map<String, dynamic>) {
      return nested['accessToken'] as String?;
    }
    return null;
  }

  Future<void> _clearAllDataAndNotify() async {
    try {
      await _hiveStorage.clearSecureBox();
      await _getStorage.clearAllData();
    } catch (e) {
      log('AuthInterceptor: clearAllData failed', error: e);
    }
    _sessionManager.notifySessionExpired();
  }
}
