abstract class AppException implements Exception {
  final String message;
  final int? code;

  AppException(this.message, {this.code});
}

class NetworkException extends AppException {
  NetworkException() : super('No internet connection');
}

class TimeoutException extends AppException {
  TimeoutException() : super('Connection timed out');
}

class UnauthorizedException extends AppException {
  UnauthorizedException() : super('Unauthorized');
}

class ForbiddenException extends AppException {
  ForbiddenException(super.msg);
}

class ServerException extends AppException {
  ServerException(super.msg, {super.code});
}

class AccessException extends AppException {
  AccessException(super.msg, {super.code});
}

class FireStoreException extends AppException {
  FireStoreException(super.message, {super.code});
}

class FireStorePermissionException extends FireStoreException {
  FireStorePermissionException([String? message])
    : super(message ?? 'Permission denied to access FireStore');
}

class FireStoreNotFoundException extends FireStoreException {
  FireStoreNotFoundException([String? message])
    : super(message ?? 'Document not found in FireStore');
}

class FireStoreTimeoutException extends FireStoreException {
  FireStoreTimeoutException([String? message])
    : super(message ?? 'FireStore operation timed out');
}

class FireStoreUnavailableException extends FireStoreException {
  FireStoreUnavailableException([String? message])
    : super(message ?? 'FireStore service is unavailable');
}

class FireStoreDataException extends FireStoreException {
  FireStoreDataException([String? message])
    : super(message ?? 'Invalid data format in FireStore');
}

class CouchException extends AppException {
  CouchException(super.message, {super.code});
}

class CouchUnauthorizedException extends CouchException {
  CouchUnauthorizedException([String? message])
    : super(message ?? 'Unauthorized access to CouchDB');
}

class CouchNotFoundException extends CouchException {
  CouchNotFoundException([String? message])
    : super(message ?? 'Document or database not found in CouchDB');
}

class CouchConflictException extends CouchException {
  CouchConflictException([String? message])
    : super(message ?? 'Document conflict in CouchDB', code: 409);
}

class CouchTimeoutException extends CouchException {
  CouchTimeoutException([String? message])
    : super(message ?? 'CouchDB operation timed out');
}

class CouchUnavailableException extends CouchException {
  CouchUnavailableException([String? message])
    : super(message ?? 'CouchDB service is unavailable');
}

class CouchDataException extends CouchException {
  CouchDataException([String? message])
    : super(message ?? 'Invalid data format in CouchDB');
}

class CouchSessionException extends CouchException {
  CouchSessionException([String? message])
    : super(message ?? 'CouchDB session expired or invalid');
}
