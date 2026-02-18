import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CurlLoggerInterceptor extends Interceptor {
  // Buffer to store cURL commands for clean output
  static final StringBuffer _curlBuffer = StringBuffer();

  // Method to get all logged cURL commands
  static String getCurlLogs() => _curlBuffer.toString();

  // Method to clear the buffer if needed
  static void clearCurlLogs() => _curlBuffer.clear();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      // Log request details similar to LoggingInterceptor
      developer.log(
        'REQUEST[${options.method}] => PATH: ${options.path}',
        name: 'CurlLogger',
      );
      options.headers.forEach(
        (k, v) => developer.log('\t\t$k: $v', name: 'CurlLogger'),
      );
      if (options.queryParameters.isNotEmpty) {
        options.queryParameters.forEach(
          (k, v) => developer.log('\t\t$k: $v', name: 'CurlLogger'),
        );
      }
      if (options.data != null) {
        developer.log(options.data.toString(), name: 'CurlLogger');
      }

      // Log token explicitly
      final token = options.headers[HttpHeaders.authorizationHeader];
      if (token != null) {
        developer.log('Authorization Token: $token', name: 'CurlLogger');
        _curlBuffer.writeln('Authorization Token: $token\n');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      // Log API invocation and cURL
      developer.log(
        'Api invoked => ${response.requestOptions.path}',
        name: 'CurlLogger',
      );
      developer.log('Curl is =>\n', name: 'CurlLogger');
      final curl = _renderCurlRepresentation(response.requestOptions);
      developer.log(curl, name: 'CurlLogger');
      _curlBuffer.writeln('Api invoked => ${response.requestOptions.path}');
      _curlBuffer.writeln('Curl is =>\n');
      _curlBuffer.writeln(curl);
      _curlBuffer.writeln();

      // Log response
      final responseData = jsonEncode(response.data);
      developer.log('RESPONSE is =>\n$responseData', name: 'CurlLogger');
      _curlBuffer.writeln('RESPONSE is =>\n$responseData\n');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      // Log error details
      developer.log(
        'Api invoked => ${err.requestOptions.path}',
        name: 'CurlLogger',
      );
      developer.log(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
        name: 'CurlLogger',
      );
      developer.log('Curl is =>\n', name: 'CurlLogger');
      final curl = _renderCurlRepresentation(err.requestOptions);
      developer.log(curl, name: 'CurlLogger');
      _curlBuffer.writeln('Api invoked => ${err.requestOptions.path}');
      _curlBuffer.writeln('Curl is =>\n');
      _curlBuffer.writeln(curl);
      _curlBuffer.writeln();
    }
    super.onError(err, handler);
  }

  String _renderCurlRepresentation(RequestOptions options) {
    try {
      return _cURLRepresentation(options);
    } catch (err) {
      const errorMessage =
          'unable to create a CURL representation of the requestOptions';
      _curlBuffer.writeln(errorMessage);
      return errorMessage;
    }
  }

  String _cURLRepresentation(RequestOptions options) {
    final components = <String>['curl -i'];

    // Add method if not GET
    if (options.method.toUpperCase() != 'GET') {
      components.add('-X ${options.method}');
    }

    // Add headers
    options.headers.forEach((k, v) {
      if (k.toLowerCase() != 'cookie') {
        components.add('-H "$k: $v"');
      }
    });

    // Add Content-Type if missing and data is JSON
    final contentTypeHeader = options.headers[HttpHeaders.contentTypeHeader];
    final isJson = options.data != null && options.data is! FormData;
    if (contentTypeHeader == null && isJson) {
      components.add('-H "Content-Type: application/json"');
    }

    // Add body
    if (options.data != null) {
      if (options.data is FormData) {
        final formData = options.data as FormData;
        for (final field in formData.fields) {
          components.add('-F "${field.key}=${field.value}"');
        }
        for (final file in formData.files) {
          final filename = file.value.filename ?? 'file';
          components.add('-F "${file.key}=@/absolute/path/to/$filename"');
        }
      } else {
        final data = json.encode(options.data).replaceAll('"', '\\"');
        components.add('-d "$data"');
      }
    }

    // Add URL
    components.add('"${options.uri}"');

    // Join with backslash and tab for formatting
    return components.join(' \\\n\t');
  }
}
