import 'dart:convert';
import 'dart:io';

import 'package:bloc_architecure/core/constants/urls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class CouchInterceptor extends Interceptor {
  String? _sessionCookie;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add Basic Auth if credentials are available
    if (URLs.couchUsername.isNotEmpty && URLs.couchPassword.isNotEmpty) {
      final credentials = '${URLs.couchUsername}:${URLs.couchPassword}';
      final base64Credentials = base64Encode(utf8.encode(credentials));
      options.headers[HttpHeaders.authorizationHeader] =
          'Basic $base64Credentials';
    }

    // Add session cookie if available
    if (_sessionCookie != null && _sessionCookie!.isNotEmpty) {
      options.headers[HttpHeaders.cookieHeader] = _sessionCookie!;
    }

    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    // Extract session cookie from Set-Cookie header
    final setCookieHeader = response.headers.value(HttpHeaders.setCookieHeader);
    if (setCookieHeader != null && setCookieHeader.isNotEmpty) {
      _sessionCookie = setCookieHeader;
      debugPrint('CouchDB session cookie stored');
    }
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 - Try to refresh session
    if (err.response?.statusCode == 401) {
      try {
        final refreshed = await _refreshSession();
        if (refreshed) {
          // Retry the original request with new session
          final requestOptions = err.requestOptions;
          if (_sessionCookie != null) {
            requestOptions.headers[HttpHeaders.cookieHeader] = _sessionCookie!;
          }
          final dio = Dio();
          final fetchResponse = await dio.fetch(requestOptions);
          return handler.resolve(fetchResponse);
        }
      } catch (e) {
        debugPrint('CouchDB session refresh failed: $e');
        _sessionCookie = null; // Clear invalid session
      }
    }
    handler.next(err);
  }

  Future<bool> _refreshSession() async {
    try {
      if (URLs.couchURL.isEmpty ||
          URLs.couchUsername.isEmpty ||
          URLs.couchPassword.isEmpty) {
        return false;
      }

      final dio = Dio();
      final credentials = '${URLs.couchUsername}:${URLs.couchPassword}';
      final base64Credentials = base64Encode(utf8.encode(credentials));

      final response = await dio.post(
        '${URLs.couchURL}/_session',
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $base64Credentials',
            HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
          },
        ),
        data: {'name': URLs.couchUsername, 'password': URLs.couchPassword},
      );

      if (response.statusCode == 200) {
        final setCookieHeader = response.headers.value(
          HttpHeaders.setCookieHeader,
        );
        if (setCookieHeader != null && setCookieHeader.isNotEmpty) {
          _sessionCookie = setCookieHeader;
          debugPrint('CouchDB session refreshed successfully');
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error refreshing CouchDB session: $e');
      return false;
    }
  }

  void clearSession() {
    _sessionCookie = null;
  }
}
