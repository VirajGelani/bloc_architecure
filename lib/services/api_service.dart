import 'dart:io';

import 'package:bloc_architecure/core/constants/urls.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:bloc_architecure/core/constants/app_labels.dart';
import 'package:bloc_architecure/utils/api_error_handler.dart';
import 'package:bloc_architecure/utils/api_result.dart';
import 'package:bloc_architecure/services/interceptors/auth_interceptor.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: URLs.baseURL,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );
    _setupInterceptors();
  }

  void _setupInterceptors() {
    if (kDebugMode) {
      //Add logger Interceptors
      _dio.interceptors.addAll([
        LogInterceptor(
          error: true,
          request: true,
          requestBody: true,
          requestHeader: true,
          responseBody: true,
          responseHeader: true,
        ),
        /*CurlLoggerInterceptor(),*/
      ]);
    }
    _dio.interceptors.add(AuthInterceptor(_dio));
  }

  Future<ApiResult<T>> get<T>(
    String endpoint, {
    required T Function(dynamic response)? parser,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      try {
        final res = await _dio.get(
          endpoint,
          queryParameters: query,
          cancelToken: cancelToken,
        );
        final parsedData = parser != null ? parser(res.data) : res.data as T;
        return ApiResult.success(parsedData);
      } on DioException catch (e) {
        return ApiResult.failure(ApiErrorHandler.fromDioError(e));
      }
    } else {
      return ApiResult.failure(
        ApiErrorHandler.fromDioError(
          DioException.connectionError(
            requestOptions: RequestOptions(),
            reason: AppLabels.noInternet,
          ),
        ),
      );
    }
  }

  Future<ApiResult<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    required T Function(dynamic response)? parser,
    CancelToken? cancelToken,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      try {
        final res = await _dio.post(
          endpoint,
          data: body,
          cancelToken: cancelToken,
        );
        final parsedData = parser != null ? parser(res.data) : res.data as T;
        return ApiResult.success(parsedData);
      } on DioException catch (e) {
        return ApiResult.failure(ApiErrorHandler.fromDioError(e));
      }
    } else {
      return ApiResult.failure(
        ApiErrorHandler.fromDioError(
          DioException.connectionError(
            requestOptions: RequestOptions(),
            reason: AppLabels.noInternet,
          ),
        ),
      );
    }
  }

  Future<ApiResult<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    required T Function(dynamic response)? parser,
    CancelToken? cancelToken,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      try {
        final res = await _dio.put(
          endpoint,
          data: body,
          cancelToken: cancelToken,
        );
        final parsedData = parser != null ? parser(res.data) : res.data as T;
        return ApiResult.success(parsedData);
      } on DioException catch (e) {
        return ApiResult.failure(ApiErrorHandler.fromDioError(e));
      }
    } else {
      return ApiResult.failure(
        ApiErrorHandler.fromDioError(
          DioException.connectionError(
            requestOptions: RequestOptions(),
            reason: AppLabels.noInternet,
          ),
        ),
      );
    }
  }

  Future<ApiResult<T>> delete<T>(
    String endpoint, {
    required T Function(dynamic response)? parser,
    CancelToken? cancelToken,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      try {
        final res = await _dio.delete(endpoint, cancelToken: cancelToken);
        final parsedData = parser != null ? parser(res.data) : res.data as T;
        return ApiResult.success(parsedData);
      } on DioException catch (e) {
        return ApiResult.failure(ApiErrorHandler.fromDioError(e));
      }
    } else {
      return ApiResult.failure(
        ApiErrorHandler.fromDioError(
          DioException.connectionError(
            requestOptions: RequestOptions(),
            reason: AppLabels.noInternet,
          ),
        ),
      );
    }
  }

  Future<ApiResult<T>> postMultipart<T>(
    String endpoint, {
    required File file,
    Map<String, dynamic>? fields,
    String fieldName = 'file',
    required T Function(dynamic response)? parser,
    void Function(int sent, int total)? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      try {
        final formData = FormData.fromMap({
          ...?fields,
          fieldName: await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        });

        final res = await _dio.post(
          endpoint,
          data: formData,
          onSendProgress: onSendProgress,
          cancelToken: cancelToken,
        );
        final parsedData = parser != null ? parser(res.data) : res.data as T;
        return ApiResult.success(parsedData);
      } on DioException catch (e) {
        return ApiResult.failure(ApiErrorHandler.fromDioError(e));
      }
    } else {
      return ApiResult.failure(
        ApiErrorHandler.fromDioError(
          DioException.connectionError(
            requestOptions: RequestOptions(),
            reason: AppLabels.noInternet,
          ),
        ),
      );
    }
  }

  Future<dynamic> download(String fileUrl, {CancelToken? cancelToken}) async {
    dynamic responseJson;
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      try {
        final res = await _dio.get(
          fileUrl,
          options: Options(responseType: ResponseType.bytes),
          cancelToken: cancelToken,
        );
        responseJson = res.data;
      } on DioException catch (e) {
        responseJson = e;
      }
    } else {
      responseJson = DioException.connectionError(
        requestOptions: RequestOptions(),
        reason: 'No Internet',
      );
    }
    return responseJson;
  }
}
