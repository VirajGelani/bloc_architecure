import 'dart:async';
import 'dart:convert';

import 'package:bloc_architecure/core/constants/urls.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:bloc_architecure/core/constants/app_labels.dart';
import 'package:bloc_architecure/utils/api_error_handler.dart';
import 'package:bloc_architecure/utils/api_result.dart';
import 'package:bloc_architecure/utils/app_exceptions.dart';
import 'package:bloc_architecure/services/interceptors/couch_interceptor.dart';

class CouchService {
  late Dio _dio;
  final CouchInterceptor _couchInterceptor = CouchInterceptor();
  static const Duration _defaultTimeout = Duration(seconds: 30);

  @override
  void onInit() {
    // super.onInit();
    _dio = Dio(
      BaseOptions(
        baseUrl: URLs.couchURL,
        connectTimeout: _defaultTimeout,
        receiveTimeout: _defaultTimeout,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );
    _setupInterceptors();
  }

  void _setupInterceptors() {
    if (kDebugMode) {
      // Add logger Interceptors
      _dio.interceptors.addAll([
        LogInterceptor(
          error: true,
          request: true,
          requestBody: true,
          requestHeader: true,
          responseBody: true,
          responseHeader: true,
        ),
      ]);
    }
    // Add CouchDB Interceptor
    _dio.interceptors.add(_couchInterceptor);
  }

  // Connectivity check helper before API call
  Future<ApiResult<T>> _executeWithConnectivityCheck<T>(
    Future<ApiResult<T>> Function() operation,
  ) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (!connectivity.contains(ConnectivityResult.mobile) &&
        !connectivity.contains(ConnectivityResult.wifi) &&
        !connectivity.contains(ConnectivityResult.ethernet)) {
      return ApiResult.failure(
        ApiErrorHandler.fromDioError(
          DioException.connectionError(
            requestOptions: RequestOptions(),
            reason: AppLabels.noInternet,
          ),
        ),
      );
    }
    return await operation();
  }

  /// GET request to CouchDB
  Future<ApiResult<T>> get<T>(
    String endpoint, {
    required T Function(dynamic response)? parser,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    Duration? timeout,
  }) async {
    return await _executeWithConnectivityCheck(() async {
      try {
        final queryParams = {...?query, 'include_docs': 'true'};
        final res = await _dio.get(
          endpoint,
          queryParameters: queryParams,
          cancelToken: cancelToken,
          options: Options(receiveTimeout: timeout ?? _defaultTimeout),
        );
        final parsedData = parser != null ? parser(res.data) : res.data as T;
        return ApiResult.success(parsedData);
      } on DioException catch (e) {
        return ApiResult.failure(_handleCouchError(e));
      }
    });
  }

  /// Continuous GET request (for CouchDB changes feed or streaming)
  Stream<ApiResult<T>> getStream<T>({
    required String endpoint,
    required T Function(dynamic response)? parser,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    Duration? timeout,
  }) async* {
    final connectivity = await Connectivity().checkConnectivity();
    if (!connectivity.contains(ConnectivityResult.mobile) &&
        !connectivity.contains(ConnectivityResult.wifi) &&
        !connectivity.contains(ConnectivityResult.ethernet)) {
      yield ApiResult.failure(
        ApiErrorHandler.fromDioError(
          DioException.connectionError(
            requestOptions: RequestOptions(),
            reason: AppLabels.noInternet,
          ),
        ),
      );
      return;
    }

    try {
      final queryParams = {
        ...?query,
        'feed': 'continuous',
        'heartbeat': 'true',
        'include_docs': 'true',
      };

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
        cancelToken: cancelToken,
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: timeout ?? Duration(minutes: 5),
        ),
      );

      if (response.data is ResponseBody) {
        final stream = (response.data as ResponseBody).stream;
        final buffer = StringBuffer();

        await for (final chunk in stream.transform(
          StreamTransformer<Uint8List, String>.fromHandlers(
            handleData: (data, sink) {
              sink.add(utf8.decode(data));
            },
          ),
        )) {
          buffer.write(chunk);
          final lines = buffer.toString().split('\n');
          buffer.clear();
          buffer.write(lines.removeLast()); // Keep incomplete line in buffer

          for (final line in lines) {
            if (line.trim().isEmpty) continue;
            try {
              final jsonData = parser != null ? parser(line) : line as T;
              yield ApiResult.success(jsonData);
            } catch (e) {
              yield ApiResult.failure(
                CouchDataException('Failed to parse stream data: $e'),
              );
            }
          }
        }
        if (buffer.isNotEmpty) {
          try {
            final jsonData = parser != null
                ? parser(buffer.toString())
                : buffer.toString() as T;
            yield ApiResult.success(jsonData);
          } catch (e) {
            yield ApiResult.failure(
              CouchDataException('Failed to parse final data: $e'),
            );
          }
        }
      }
    } on DioException catch (e) {
      yield ApiResult.failure(_handleCouchError(e));
    } catch (e) {
      yield ApiResult.failure(
        CouchException('Unexpected error in continuous GET: ${e.toString()}'),
      );
    }
  }

  // /// POST request to CouchDB
  // Future<ApiResult<T>> post<T>(
  //   String endpoint, {
  //   Map<String, dynamic>? body,
  //   required T Function(dynamic response)? parser,
  //   CancelToken? cancelToken,
  //   Duration? timeout,
  // }) async {
  //   return await _executeWithConnectivityCheck(() async {
  //     try {
  //       final res = await _dio.post(
  //         endpoint,
  //         data: body,
  //         cancelToken: cancelToken,
  //         options: Options(receiveTimeout: timeout ?? _defaultTimeout),
  //       );
  //       final parsedData = parser != null ? parser(res.data) : res.data as T;
  //       return ApiResult.success(parsedData);
  //     } on DioException catch (e) {
  //       return ApiResult.failure(_handleCouchError(e));
  //     }
  //   });
  // }
  //
  // /// Continuous POST request (for bulk operations or long-running requests)
  // Stream<ApiResult<T>> postStream<T>({
  //   required String endpoint,
  //   Map<String, dynamic>? body,
  //   required T Function(dynamic response)? parser,
  //   CancelToken? cancelToken,
  //   Duration? timeout,
  //   void Function(int sent, int total)? onSendProgress,
  // }) async* {
  //   final connectivity = await Connectivity().checkConnectivity();
  //   if (!connectivity.contains(ConnectivityResult.mobile) &&
  //       !connectivity.contains(ConnectivityResult.wifi) &&
  //       !connectivity.contains(ConnectivityResult.ethernet)) {
  //     yield ApiResult.failure(
  //       ApiErrorHandler.fromDioError(
  //         DioException.connectionError(
  //           requestOptions: RequestOptions(),
  //           reason: AppLabels.noInternet,
  //         ),
  //       ),
  //     );
  //     return;
  //   }
  //
  //   try {
  //     final response = await _dio.post(
  //       endpoint,
  //       data: body,
  //       cancelToken: cancelToken,
  //       onSendProgress: onSendProgress,
  //       options: Options(
  //         responseType: ResponseType.stream,
  //         receiveTimeout: timeout ?? Duration(minutes: 5),
  //       ),
  //     );
  //
  //     if (response.data is ResponseBody) {
  //       final stream = (response.data as ResponseBody).stream;
  //       final buffer = StringBuffer();
  //
  //       await for (final chunk in stream.transform(
  //         StreamTransformer<Uint8List, String>.fromHandlers(
  //           handleData: (data, sink) {
  //             sink.add(utf8.decode(data));
  //           },
  //         ),
  //       )) {
  //         buffer.write(chunk);
  //         final lines = buffer.toString().split('\n');
  //         buffer.clear();
  //         buffer.write(lines.removeLast()); // Keep incomplete line in buffer
  //
  //         for (final line in lines) {
  //           if (line.trim().isEmpty) continue;
  //           try {
  //             final jsonData = parser != null ? parser(line) : line as T;
  //             yield ApiResult.success(jsonData);
  //           } catch (e) {
  //             yield ApiResult.failure(
  //               CouchDataException('Failed to parse stream data: $e'),
  //             );
  //           }
  //         }
  //       }
  //
  //       // Process remaining buffer
  //       if (buffer.isNotEmpty) {
  //         try {
  //           final jsonData = parser != null
  //               ? parser(buffer.toString())
  //               : buffer.toString() as T;
  //           yield ApiResult.success(jsonData);
  //         } catch (e) {
  //           yield ApiResult.failure(
  //             CouchDataException('Failed to parse final data: $e'),
  //           );
  //         }
  //       }
  //     }
  //   } on DioException catch (e) {
  //     yield ApiResult.failure(_handleCouchError(e));
  //   } catch (e) {
  //     yield ApiResult.failure(
  //       CouchException('Unexpected error in continuous POST: ${e.toString()}'),
  //     );
  //   }
  // }

  AppException _handleCouchError(DioException error) {
    final statusCode = error.response?.statusCode;
    final errorData = error.response?.data;
    if (statusCode != null) {
      switch (statusCode) {
        case 401:
          return CouchUnauthorizedException(
            errorData?['reason'] ?? 'Unauthorized access to CouchDB',
          );
        case 404:
          return CouchNotFoundException(
            errorData?['reason'] ?? 'Document or database not found',
          );
        case 409:
          return CouchConflictException(
            errorData?['reason'] ?? 'Document conflict',
          );
        case 500:
        case 503:
          return CouchUnavailableException(
            errorData?['reason'] ?? 'CouchDB service unavailable',
          );
        default:
          return CouchException(
            errorData?['reason'] ?? error.message ?? 'CouchDB error',
            code: statusCode,
          );
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return CouchTimeoutException();
      case DioExceptionType.connectionError:
        return NetworkException();
      default:
        return ApiErrorHandler.fromDioError(error);
    }
  }

  void clearSession() {
    _couchInterceptor.clearSession();
  }
}
