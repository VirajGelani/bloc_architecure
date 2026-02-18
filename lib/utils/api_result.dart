import 'app_exceptions.dart';

class ApiResult<T> {
  final T? data;
  final AppException? error;

  ApiResult._({this.data, this.error});

  static ApiResult<T> success<T>(T data) => ApiResult._(data: data);

  static ApiResult<T> failure<T>(AppException error) =>
      ApiResult._(error: error);

  bool get isSuccess => error == null;
}
