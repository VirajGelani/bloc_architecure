import 'dart:convert';

import 'package:flutter/foundation.dart';

class FirestoreLogger {
  // Log request details
  static void logRequest({
    required String operation,
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParams,
  }) {
    if (kDebugMode) {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🔥 FIRESTORE REQUEST');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('Operation: $operation');
      debugPrint('Path: $path');
      if (queryParams != null && queryParams.isNotEmpty) {
        debugPrint('Query Parameters: ${jsonEncode(queryParams)}');
      }
      if (data != null && data.isNotEmpty) {
        debugPrint('Data: ${jsonEncode(data)}');
      }
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
  }

  // Log response details
  static void logResponse({
    required String operation,
    required String path,
    required bool success,
    dynamic data,
    String? error,
  }) {
    if (kDebugMode) {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('✅ FIRESTORE RESPONSE');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('Operation: $operation');
      debugPrint('Path: $path');
      debugPrint('Status: ${success ? "SUCCESS" : "FAILURE"}');
      if (success && data != null) {
        try {
          if (data is Map || data is List) {
            debugPrint('Response Data: ${jsonEncode(data)}');
          } else {
            debugPrint('Response Data: $data');
          }
        } catch (e) {
          debugPrint('Response Data: $data');
        }
      }
      if (error != null) {
        debugPrint('Error: $error');
      }
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
  }
}
