import 'dart:io';

import 'package:bloc_architecure/core/constants/app_labels.dart';
import 'package:bloc_architecure/utils/app_exceptions.dart';
import 'package:bloc_architecure/utils/dialog_helper.dart';
import 'package:bloc_architecure/widgets/snack_bar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ApiErrorHandler {
  static AppException fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return TimeoutException();
      case DioExceptionType.sendTimeout:
        return TimeoutException();
      case DioExceptionType.receiveTimeout:
        return TimeoutException();
      case DioExceptionType.badCertificate:
        return ServerException(AppLabels.badCertificate);
      case DioExceptionType.badResponse:
        final int? code = error.response?.statusCode;
        final msg =
            error.response?.data['message'] ?? 'Error ${code ?? 'Unknown'}';
        if (code == 401) return UnauthorizedException();
        if (code == 403) return ForbiddenException(msg);
        if (code == 409) return AccessException(msg);
        return ServerException(msg, code: code);
      case DioExceptionType.cancel:
        return ServerException(AppLabels.requestCancelled);
      case DioExceptionType.connectionError:
        return NetworkException();
      case DioExceptionType.unknown:
        switch (error.error) {
          case SocketException _:
            return NetworkException();
          case FormatException _:
            return ServerException(AppLabels.badResponse);
          default:
            final int? code = error.response?.statusCode;
            final msg =
                error.response?.data['message'] ?? 'Error ${code ?? 'Unknown'}';
            if (code == 401) return UnauthorizedException();
            if (code == 403) return ForbiddenException(msg);
            if (code == 409) return AccessException(msg);
            return ServerException(msg, code: code);
        }
    }
  }

  static AppException fromFireStoreError(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return FireStorePermissionException(
          _getLocalizedMessage(AppLabels.firestorePermissionDenied),
        );
      case 'not-found':
        return FireStoreNotFoundException(
          _getLocalizedMessage(AppLabels.firestoreNotFound),
        );
      case 'deadline-exceeded':
        return FireStoreTimeoutException(
          _getLocalizedMessage(AppLabels.firestoreTimeout),
        );
      case 'unavailable':
        return FireStoreUnavailableException(
          _getLocalizedMessage(AppLabels.firestoreUnavailable),
        );
      case 'invalid-argument':
        return FireStoreDataException(
          _getLocalizedMessage(AppLabels.firestoreInvalidData),
        );
      case 'already-exists':
        return ServerException(
          _getLocalizedMessage(AppLabels.firestoreDocumentExists),
          code: 409,
        );
      case 'failed-precondition':
        return ServerException(
          _getLocalizedMessage(AppLabels.firestorePreconditionFailed),
          code: 412,
        );
      case 'aborted':
        return ServerException(
          _getLocalizedMessage(AppLabels.firestoreAborted),
          code: 409,
        );
      case 'out-of-range':
        return ServerException(
          _getLocalizedMessage(AppLabels.firestoreOutOfRange),
          code: 400,
        );
      case 'unimplemented':
        return ServerException(
          _getLocalizedMessage(AppLabels.firestoreUnimplemented),
          code: 501,
        );
      case 'internal':
        return ServerException(
          _getLocalizedMessage(AppLabels.firestoreInternalError),
          code: 500,
        );
      case 'resource-exhausted':
        return ServerException(
          _getLocalizedMessage(AppLabels.firestoreResourceExhausted),
          code: 429,
        );
      case 'cancelled':
        return ServerException(
          _getLocalizedMessage(AppLabels.firestoreCancelled),
          code: 499,
        );
      case 'data-loss':
        return ServerException(
          _getLocalizedMessage(AppLabels.firestoreDataLoss),
          code: 500,
        );
      case 'unauthenticated':
        return UnauthorizedException();
      default:
        return FireStoreException(
          _getLocalizedMessage(AppLabels.firestoreUnknownError),
          code: int.tryParse(error.code),
        );
    }
  }

  static Future<bool> handle(
    BuildContext context,
    AppException? error,
    Function() onOkayPressed,
  ) async {
    if (error is NetworkException ||
        error is TimeoutException ||
        error is FireStoreTimeoutException ||
        error is CouchTimeoutException) {
      final message = error?.message ?? (AppLabels.somethingWentWrong);
      await DialogHelper.retryDialog(message);
      // await onOkayPressed(); //use this when need looping retry on user input
    }
    if (error is UnauthorizedException ||
        error is FireStorePermissionException ||
        error is CouchUnauthorizedException ||
        error is CouchSessionException) {
      SnackBarWidget.showSnackBar(context, AppLabels.unauthorizedAccessMsg);

      // final ok = await AuthService.to.tryRefreshToken();
      // if (!ok) AuthService.to.logout();
      // return ok;
    }
    if (error is FireStoreNotFoundException ||
        error is CouchNotFoundException) {
      SnackBarWidget.showSnackBar(
        context,
        error?.message.isNotEmpty ?? false
            ? error?.message ?? ''
            : AppLabels.noData,
      );
    }
    if (error is ForbiddenException ||
        error is ServerException ||
        error is FireStoreException ||
        error is CouchException) {
      final message = error?.message ?? (AppLabels.somethingWentWrong);
      SnackBarWidget.showSnackBar(context, message);
    }
    return false;
  }

  static bool handleFirestore(BuildContext context, AppException? error) {
    if (error is NetworkException) {
      SnackBarWidget.showSnackBar(context, AppLabels.noInternet);
      return true;
    } else if (error is FireStoreException ||
        error is FireStorePermissionException ||
        error is FireStoreNotFoundException ||
        error is FireStoreTimeoutException ||
        error is FireStoreUnavailableException ||
        error is FireStoreDataException) {
      SnackBarWidget.showSnackBar(
        context,
        error?.message ?? AppLabels.somethingWentWrong,
      );
      return true;
    }
    return false;
  }

  static String _getLocalizedMessage(String messageKey) {
    // try {
    //   return _getLocalizedMessageFromKey(messageKey);
    // } catch (e) {
    //   return _getEnglishMessage(messageKey);
    // }

    return _getEnglishMessage(messageKey);
  }

  // static String _getLocalizedMessageFromKey(String messageKey) {
  //   try {
  //     switch (messageKey) {
  //       case AppLabels.firestorePermissionDenied:
  //         try {
  //           return 'firestorePermissionDenied';
  //         } catch (e) {
  //           return _getEnglishMessage(messageKey);
  //         }
  //       case AppLabels.firestoreNotFound:
  //         try {
  //           return 'firestoreNotFound';
  //         } catch (e) {
  //           return _getEnglishMessage(messageKey);
  //         }
  //       case AppLabels.firestoreTimeout:
  //         try {
  //           return 'firestoreTimeout';
  //         } catch (e) {
  //           return _getEnglishMessage(messageKey);
  //         }
  //       case AppLabels.firestoreUnavailable:
  //         try {
  //           return 'firestoreUnavailable';
  //         } catch (e) {
  //           return _getEnglishMessage(messageKey);
  //         }
  //       case AppLabels.firestoreInvalidData:
  //         try {
  //           return 'firestoreInvalidData';
  //         } catch (e) {
  //           return _getEnglishMessage(messageKey);
  //         }
  //       case AppLabels.firestoreDocumentExists:
  //         try {
  //           return 'firestoreDocumentExists';
  //         } catch (e) {
  //           return _getEnglishMessage(messageKey);
  //         }
  //       case AppLabels.firestorePreconditionFailed:
  //         try {
  //           return 'firestorePreconditionFailed';
  //         } catch (e) {
  //           return _getEnglishMessage(messageKey);
  //         }
  //       case AppLabels.firestoreAborted:
  //         try {
  //           return 'firestoreAborted';
  //         } catch (e) {
  //           return _getEnglishMessage(messageKey);
  //         }
  //       case AppLabels.firestoreOutOfRange:
  //         try {
  //           return 'firestoreOutOfRange';
  //         } catch (e) {
  //           return _getEnglishMessage(messageKey);
  //         }
  //       case AppLabels.firestoreUnimplemented:
  //         try {
  //           return 'firestoreUnimplemented';
  //         } catch (e) {
  //           return _getEnglishMessage(messageKey);
  //         }
  //       case AppLabels.firestoreInternalError:
  //         try {
  //           return 'firestoreInternalError';
  //         } catch (e) {
  //           return _getEnglishMessage(messageKey);
  //         }
  //       case AppLabels.firestoreResourceExhausted:
  //         try {
  //           return 'firestoreResourceExhausted';
  //         } catch (e) {
  //           return _getEnglishMessage(messageKey);
  //         }
  //       case AppLabels.firestoreCancelled:
  //         try {
  //           return 'firestoreCancelled';
  //         } catch (e) {
  //           return _getEnglishMessage(messageKey);
  //         }
  //       case AppLabels.firestoreDataLoss:
  //         try {
  //           return 'firestoreDataLoss';
  //         } catch (e) {
  //           return _getEnglishMessage(messageKey);
  //         }
  //       case AppLabels.firestoreUnknownError:
  //         try {
  //           return 'firestoreUnknownError';
  //         } catch (e) {
  //           return _getEnglishMessage(messageKey);
  //         }
  //       case AppLabels.firestoreUserNotFound:
  //         try {
  //           return 'firestoreUserNotFound';
  //         } catch (e) {
  //           return _getEnglishMessage(messageKey);
  //         }
  //       case AppLabels.firestoreInvalidUserData:
  //         try {
  //           return 'firestoreInvalidUserData';
  //         } catch (e) {
  //           return _getEnglishMessage(messageKey);
  //         }
  //       default:
  //         return _getEnglishMessage(messageKey);
  //     }
  //   } catch (e) {
  //     return _getEnglishMessage(messageKey);
  //   }
  // }

  static String _getEnglishMessage(String messageKey) {
    switch (messageKey) {
      case AppLabels.firestorePermissionDenied:
        return 'Permission denied to access FireStore';
      case AppLabels.firestoreNotFound:
        return 'Document not found in FireStore';
      case AppLabels.firestoreTimeout:
        return 'FireStore operation timed out';
      case AppLabels.firestoreUnavailable:
        return 'FireStore service is unavailable';
      case AppLabels.firestoreInvalidData:
        return 'Invalid data format in FireStore';
      case AppLabels.firestoreDocumentExists:
        return 'Document already exists';
      case AppLabels.firestorePreconditionFailed:
        return 'Operation failed due to precondition';
      case AppLabels.firestoreAborted:
        return 'Operation was aborted';
      case AppLabels.firestoreOutOfRange:
        return 'Operation out of range';
      case AppLabels.firestoreUnimplemented:
        return 'Operation not implemented';
      case AppLabels.firestoreInternalError:
        return 'Internal FireStore error';
      case AppLabels.firestoreResourceExhausted:
        return 'Resource exhausted';
      case AppLabels.firestoreCancelled:
        return 'Operation cancelled';
      case AppLabels.firestoreDataLoss:
        return 'Data loss occurred';
      case AppLabels.firestoreUnknownError:
        return 'Unknown FireStore error';
      case AppLabels.firestoreUserNotFound:
        return 'User not found';
      case AppLabels.firestoreInvalidUserData:
        return 'Invalid user data';
      default:
        return messageKey;
    }
  }
}
