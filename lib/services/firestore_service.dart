import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../core/constants/enums.dart';
import '../utils/api_error_handler.dart';
import '../utils/api_result.dart';
import '../utils/app_exceptions.dart';
import 'interceptors/firestore_logger.dart';

class FireStoreService extends GetxService {
  static const Duration _defaultTimeout = Duration(seconds: 30);

  // Connectivity check helper before db operation
  Future<ApiResult<T>> _executeWithConnectivityCheck<T>(
    Future<ApiResult<T>> Function() operation,
  ) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (!connectivity.contains(ConnectivityResult.mobile) &&
        !connectivity.contains(ConnectivityResult.wifi) &&
        !connectivity.contains(ConnectivityResult.ethernet)) {
      return ApiResult.failure(NetworkException());
    }
    return await operation();
  }

  // Get document from user data
  Future<ApiResult<T>> getUserCollection<T>({
    required T Function(dynamic data, String id) parser,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)?
    queryBuilder,
    Duration timeout = _defaultTimeout,
  }) async {
    final path = Collection.users.name;
    FirestoreLogger.logRequest(operation: 'GET_USER_COLLECTION', path: path);
    return await _executeWithConnectivityCheck(() async {
      try {
        Query<Map<String, dynamic>> query = FirebaseFirestore.instance
            .collection(Collection.users.name);
        if (queryBuilder != null) {
          query = queryBuilder(query);
        }
        final snapshot = await query.limit(1).get().timeout(timeout);
        if (snapshot.docs.isEmpty) {
          FirestoreLogger.logResponse(
            operation: 'GET_USER_COLLECTION',
            path: path,
            success: false,
            error: 'Document not found',
          );
          return ApiResult.failure(FireStoreNotFoundException());
        }
        final result = parser(
          snapshot.docs.first.data(),
          snapshot.docs.first.id,
        );
        FirestoreLogger.logResponse(
          operation: 'GET_USER_COLLECTION',
          path: path,
          success: true,
          data: snapshot.docs.first.data(),
        );
        return ApiResult.success(result);
      } on FirebaseException catch (e) {
        FirestoreLogger.logResponse(
          operation: 'GET_USER_COLLECTION',
          path: path,
          success: false,
          error: 'FirebaseException: ${e.code} - ${e.message}',
        );
        return ApiResult.failure(ApiErrorHandler.fromFireStoreError(e));
      } catch (e) {
        if (e.toString().contains('TimeoutException')) {
          FirestoreLogger.logResponse(
            operation: 'GET_USER_COLLECTION',
            path: path,
            success: false,
            error: 'TimeoutException',
          );
          return ApiResult.failure(FireStoreTimeoutException());
        }
        FirestoreLogger.logResponse(
          operation: 'GET_USER_COLLECTION',
          path: path,
          success: false,
          error: e.toString(),
        );
        return ApiResult.failure(
          FireStoreException('Unexpected error: ${e.toString()}'),
        );
      }
    });
  }

  // Get document from user subCollection
  Future<ApiResult<T>> getSubCollection<T>({
    required String userId,
    required String subCollection,
    required T Function(Map<String, dynamic> data, String id) parser,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)?
    queryBuilder,
    Duration timeout = _defaultTimeout,
  }) async {
    final path = '${Collection.users.name}/$userId/$subCollection';
    FirestoreLogger.logRequest(operation: 'GET_SUB_COLLECTION', path: path);
    return await _executeWithConnectivityCheck(() async {
      try {
        Query<Map<String, dynamic>> query = FirebaseFirestore.instance
            .collection(Collection.users.name)
            .doc(userId)
            .collection(subCollection);
        if (queryBuilder != null) {
          query = queryBuilder(query);
        }
        final snapshot = await query.limit(1).get().timeout(timeout);
        if (snapshot.docs.isEmpty) {
          FirestoreLogger.logResponse(
            operation: 'GET_SUB_COLLECTION',
            path: path,
            success: false,
            error: 'Document not found',
          );
          return ApiResult.failure(FireStoreNotFoundException());
        }
        final docData = snapshot.docs.firstOrNull?.data() ?? {};
        final result = parser(docData, snapshot.docs.firstOrNull?.id ?? '');
        FirestoreLogger.logResponse(
          operation: 'GET_SUB_COLLECTION',
          path: path,
          success: true,
          data: docData.isNotEmpty ? docData : null,
        );
        return ApiResult.success(result);
      } on FirebaseException catch (e) {
        FirestoreLogger.logResponse(
          operation: 'GET_SUB_COLLECTION',
          path: path,
          success: false,
          error: 'FirebaseException: ${e.code} - ${e.message}',
        );
        return ApiResult.failure(ApiErrorHandler.fromFireStoreError(e));
      } catch (e) {
        if (e.toString().contains('TimeoutException')) {
          FirestoreLogger.logResponse(
            operation: 'GET_SUB_COLLECTION',
            path: path,
            success: false,
            error: 'TimeoutException',
          );
          return ApiResult.failure(FireStoreTimeoutException());
        }
        FirestoreLogger.logResponse(
          operation: 'GET_SUB_COLLECTION',
          path: path,
          success: false,
          error: e.toString(),
        );
        return ApiResult.failure(
          FireStoreException('Unexpected error: ${e.toString()}'),
        );
      }
    });
  }

  // Get documents from user subCollection
  Future<ApiResult<List<T>>> getSubCollections<T>({
    required String userId,
    required String subCollection,
    required T Function(Map<String, dynamic> data, String id) parser,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)?
    queryBuilder,
    Duration timeout = _defaultTimeout,
  }) async {
    final path = '${Collection.users.name}/$userId/$subCollection';
    FirestoreLogger.logRequest(operation: 'GET_SUB_COLLECTIONS', path: path);
    return await _executeWithConnectivityCheck(() async {
      try {
        Query<Map<String, dynamic>> query = FirebaseFirestore.instance
            .collection(Collection.users.name)
            .doc(userId)
            .collection(subCollection);
        if (queryBuilder != null) {
          query = queryBuilder(query);
        }
        final snapshot = await query.get().timeout(timeout);
        final results = snapshot.docs
            .map((doc) => parser(doc.data(), doc.id))
            .toList();
        final docsData = snapshot.docs.map((doc) => doc.data()).toList();
        FirestoreLogger.logResponse(
          operation: 'GET_SUB_COLLECTIONS',
          path: path,
          success: true,
          data: {'count': docsData.length, 'documents': docsData},
        );
        return ApiResult.success(results);
      } on FirebaseException catch (e) {
        FirestoreLogger.logResponse(
          operation: 'GET_SUB_COLLECTIONS',
          path: path,
          success: false,
          error: 'FirebaseException: ${e.code} - ${e.message}',
        );
        return ApiResult.failure(ApiErrorHandler.fromFireStoreError(e));
      } catch (e) {
        if (e.toString().contains('TimeoutException')) {
          FirestoreLogger.logResponse(
            operation: 'GET_SUB_COLLECTIONS',
            path: path,
            success: false,
            error: 'TimeoutException',
          );
          return ApiResult.failure(FireStoreTimeoutException());
        }
        FirestoreLogger.logResponse(
          operation: 'GET_SUB_COLLECTIONS',
          path: path,
          success: false,
          error: e.toString(),
        );
        return ApiResult.failure(
          FireStoreException('Unexpected error: ${e.toString()}'),
        );
      }
    });
  }

  // Create document in main collection (e.g., users collection)
  Future<ApiResult<T>> createUserDocument<T>({
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic> data, String id) parser,
    Collection? collection,
    Duration timeout = _defaultTimeout,
  }) async {
    final collectionName = collection?.name ?? Collection.users.name;
    final path = collectionName;
    FirestoreLogger.logRequest(
      operation: 'CREATE_USER_DOCUMENT',
      path: path,
      data: data,
    );
    return await _executeWithConnectivityCheck(() async {
      try {
        final ref = FirebaseFirestore.instance.collection(collectionName).doc();
        await ref.set(data).timeout(timeout);
        final doc = await ref.get().timeout(timeout);
        final result = parser(doc.data() ?? {}, doc.id);
        FirestoreLogger.logResponse(
          operation: 'CREATE_USER_DOCUMENT',
          path: '$path/${doc.id}',
          success: true,
          data: doc.data(),
        );
        return ApiResult.success(result);
      } on FirebaseException catch (e) {
        FirestoreLogger.logResponse(
          operation: 'CREATE_USER_DOCUMENT',
          path: path,
          success: false,
          error: 'FirebaseException: ${e.code} - ${e.message}',
        );
        return ApiResult.failure(ApiErrorHandler.fromFireStoreError(e));
      } catch (e) {
        if (e.toString().contains('TimeoutException')) {
          FirestoreLogger.logResponse(
            operation: 'CREATE_USER_DOCUMENT',
            path: path,
            success: false,
            error: 'TimeoutException',
          );
          return ApiResult.failure(FireStoreTimeoutException());
        }
        FirestoreLogger.logResponse(
          operation: 'CREATE_USER_DOCUMENT',
          path: path,
          success: false,
          error: e.toString(),
        );
        return ApiResult.failure(
          FireStoreException('Unexpected error: ${e.toString()}'),
        );
      }
    });
  }

  // Create document in main collection without response(e.g., feedback collection)
  Future<ApiResult<T>> createUserDocumentWithOutResponse<T>({
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic> data, String id) parser,
    Collection? collection,
    Duration timeout = _defaultTimeout,
  }) async {
    final collectionName = collection?.name ?? Collection.users.name;
    final path = collectionName;
    FirestoreLogger.logRequest(
      operation: 'CREATE_USER_DOCUMENT',
      path: path,
      data: data,
    );
    return await _executeWithConnectivityCheck(() async {
      try {
        final ref = FirebaseFirestore.instance.collection(collectionName).doc();
        final documentId = ref.id;
        await ref.set(data).timeout(timeout);
        final result = parser(data, documentId);
        FirestoreLogger.logResponse(
          operation: 'CREATE_USER_DOCUMENT',
          path: '$path/$documentId',
          success: true,
          data: data,
        );
        return ApiResult.success(result);
      } on FirebaseException catch (e) {
        FirestoreLogger.logResponse(
          operation: 'CREATE_USER_DOCUMENT',
          path: path,
          success: false,
          error: 'FirebaseException: ${e.code} - ${e.message}',
        );
        return ApiResult.failure(ApiErrorHandler.fromFireStoreError(e));
      } catch (e) {
        if (e.toString().contains('TimeoutException')) {
          FirestoreLogger.logResponse(
            operation: 'CREATE_USER_DOCUMENT',
            path: path,
            success: false,
            error: 'TimeoutException',
          );
          return ApiResult.failure(FireStoreTimeoutException());
        }
        FirestoreLogger.logResponse(
          operation: 'CREATE_USER_DOCUMENT',
          path: path,
          success: false,
          error: e.toString(),
        );
        return ApiResult.failure(
          FireStoreException('Unexpected error: ${e.toString()}'),
        );
      }
    });
  }

  // Create document in user subCollection
  Future<ApiResult<T>> createSubCollectionDocument<T>({
    required String userId,
    required String subCollection,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic> data, String id) parser,
    Duration timeout = _defaultTimeout,
  }) async {
    final path = '${Collection.users.name}/$userId/$subCollection';
    FirestoreLogger.logRequest(
      operation: 'CREATE_SUB_COLLECTION_DOCUMENT',
      path: path,
      data: data,
    );
    return await _executeWithConnectivityCheck(() async {
      try {
        final ref = FirebaseFirestore.instance
            .collection(Collection.users.name)
            .doc(userId)
            .collection(subCollection)
            .doc();
        await ref.set(data).timeout(timeout);
        final doc = await ref.get().timeout(timeout);
        final result = parser(doc.data() ?? {}, doc.id);
        FirestoreLogger.logResponse(
          operation: 'CREATE_SUB_COLLECTION_DOCUMENT',
          path: '$path/${doc.id}',
          success: true,
          data: doc.data(),
        );
        return ApiResult.success(result);
      } on FirebaseException catch (e) {
        FirestoreLogger.logResponse(
          operation: 'CREATE_SUB_COLLECTION_DOCUMENT',
          path: path,
          success: false,
          error: 'FirebaseException: ${e.code} - ${e.message}',
        );
        return ApiResult.failure(ApiErrorHandler.fromFireStoreError(e));
      } catch (e) {
        if (e.toString().contains('TimeoutException')) {
          FirestoreLogger.logResponse(
            operation: 'CREATE_SUB_COLLECTION_DOCUMENT',
            path: path,
            success: false,
            error: 'TimeoutException',
          );
          return ApiResult.failure(FireStoreTimeoutException());
        }
        FirestoreLogger.logResponse(
          operation: 'CREATE_SUB_COLLECTION_DOCUMENT',
          path: path,
          success: false,
          error: e.toString(),
        );
        return ApiResult.failure(
          FireStoreException('Unexpected error: ${e.toString()}'),
        );
      }
    });
  }

  // Create or update document in user subCollection with custom ID
  Future<ApiResult<T>> setSubCollectionDocument<T>({
    required String userId,
    required String subCollection,
    required String documentId,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic> data, String id) parser,
    Duration timeout = _defaultTimeout,
  }) async {
    final path = '${Collection.users.name}/$userId/$subCollection/$documentId';
    FirestoreLogger.logRequest(
      operation: 'SET_SUB_COLLECTION_DOCUMENT',
      path: path,
      data: data,
    );
    return await _executeWithConnectivityCheck(() async {
      try {
        final ref = FirebaseFirestore.instance
            .collection(Collection.users.name)
            .doc(userId)
            .collection(subCollection)
            .doc(documentId);
        await ref.set(data).timeout(timeout);
        final doc = await ref.get().timeout(timeout);
        final result = parser(doc.data() ?? {}, doc.id);
        FirestoreLogger.logResponse(
          operation: 'SET_SUB_COLLECTION_DOCUMENT',
          path: path,
          success: true,
          data: doc.data(),
        );
        return ApiResult.success(result);
      } on FirebaseException catch (e) {
        FirestoreLogger.logResponse(
          operation: 'SET_SUB_COLLECTION_DOCUMENT',
          path: path,
          success: false,
          error: 'FirebaseException: ${e.code} - ${e.message}',
        );
        return ApiResult.failure(ApiErrorHandler.fromFireStoreError(e));
      } catch (e) {
        if (e.toString().contains('TimeoutException')) {
          FirestoreLogger.logResponse(
            operation: 'SET_SUB_COLLECTION_DOCUMENT',
            path: path,
            success: false,
            error: 'TimeoutException',
          );
          return ApiResult.failure(FireStoreTimeoutException());
        }
        FirestoreLogger.logResponse(
          operation: 'SET_SUB_COLLECTION_DOCUMENT',
          path: path,
          success: false,
          error: e.toString(),
        );
        return ApiResult.failure(
          FireStoreException('Unexpected error: ${e.toString()}'),
        );
      }
    });
  }

  // Update document to user data
  Future<ApiResult<T>> updateUserDocument<T>({
    required String userId,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic> data, String id) parser,
    Duration timeout = _defaultTimeout,
  }) async {
    final path = '${Collection.users.name}/$userId';
    FirestoreLogger.logRequest(
      operation: 'UPDATE_USER_DOCUMENT',
      path: path,
      data: data,
    );
    return await _executeWithConnectivityCheck(() async {
      try {
        final ref = FirebaseFirestore.instance
            .collection(Collection.users.name)
            .doc(userId);
        await ref.update(data).timeout(timeout);
        final doc = await ref.get().timeout(timeout);
        final result = parser(doc.data() ?? {}, doc.id);
        FirestoreLogger.logResponse(
          operation: 'UPDATE_USER_DOCUMENT',
          path: path,
          success: true,
          data: doc.data(),
        );
        return ApiResult.success(result);
      } on FirebaseException catch (e) {
        FirestoreLogger.logResponse(
          operation: 'UPDATE_USER_DOCUMENT',
          path: path,
          success: false,
          error: 'FirebaseException: ${e.code} - ${e.message}',
        );
        return ApiResult.failure(ApiErrorHandler.fromFireStoreError(e));
      } catch (e) {
        if (e.toString().contains('TimeoutException')) {
          FirestoreLogger.logResponse(
            operation: 'UPDATE_USER_DOCUMENT',
            path: path,
            success: false,
            error: 'TimeoutException',
          );
          return ApiResult.failure(FireStoreTimeoutException());
        }
        FirestoreLogger.logResponse(
          operation: 'UPDATE_USER_DOCUMENT',
          path: path,
          success: false,
          error: e.toString(),
        );
        return ApiResult.failure(
          FireStoreException('Unexpected error: ${e.toString()}'),
        );
      }
    });
  }

  // Update document in user subCollection
  Future<ApiResult<T>> updateSubCollectionDocument<T>({
    required String userId,
    required String subCollection,
    required String subCollectionId,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic> data, String id) parser,
    Duration timeout = _defaultTimeout,
  }) async {
    final path =
        '${Collection.users.name}/$userId/$subCollection/$subCollectionId';
    FirestoreLogger.logRequest(
      operation: 'UPDATE_SUB_COLLECTION_DOCUMENT',
      path: path,
      data: data,
    );
    return await _executeWithConnectivityCheck(() async {
      try {
        final ref = FirebaseFirestore.instance
            .collection(Collection.users.name)
            .doc(userId)
            .collection(subCollection)
            .doc(subCollectionId);
        await ref.update(data).timeout(timeout);
        final doc = await ref.get().timeout(timeout);
        final result = parser(doc.data() ?? {}, doc.id);
        FirestoreLogger.logResponse(
          operation: 'UPDATE_SUB_COLLECTION_DOCUMENT',
          path: path,
          success: true,
          data: doc.data(),
        );
        return ApiResult.success(result);
      } on FirebaseException catch (e) {
        FirestoreLogger.logResponse(
          operation: 'UPDATE_SUB_COLLECTION_DOCUMENT',
          path: path,
          success: false,
          error: 'FirebaseException: ${e.code} - ${e.message}',
        );
        return ApiResult.failure(ApiErrorHandler.fromFireStoreError(e));
      } catch (e) {
        if (e.toString().contains('TimeoutException')) {
          FirestoreLogger.logResponse(
            operation: 'UPDATE_SUB_COLLECTION_DOCUMENT',
            path: path,
            success: false,
            error: 'TimeoutException',
          );
          return ApiResult.failure(FireStoreTimeoutException());
        }
        FirestoreLogger.logResponse(
          operation: 'UPDATE_SUB_COLLECTION_DOCUMENT',
          path: path,
          success: false,
          error: e.toString(),
        );
        return ApiResult.failure(
          FireStoreException('Unexpected error: ${e.toString()}'),
        );
      }
    });
  }

  //delete user
  Future<ApiResult<void>> deleteUserDocument({
    required String userId,
    Duration timeout = _defaultTimeout,
  }) async {
    final path = '${Collection.users.name}/$userId';
    FirestoreLogger.logRequest(operation: 'DELETE_USER_DOCUMENT', path: path);
    return await _executeWithConnectivityCheck(() async {
      try {
        final ref = FirebaseFirestore.instance
            .collection(Collection.users.name)
            .doc(userId);
        await ref.delete().timeout(timeout);
        FirestoreLogger.logResponse(
          operation: 'DELETE_USER_DOCUMENT',
          path: path,
          success: true,
          data: 'Document deleted successfully',
        );
        return ApiResult.success(null);
      } on FirebaseException catch (e) {
        FirestoreLogger.logResponse(
          operation: 'DELETE_USER_DOCUMENT',
          path: path,
          success: false,
          error: 'FirebaseException: ${e.code} - ${e.message}',
        );
        return ApiResult.failure(ApiErrorHandler.fromFireStoreError(e));
      } catch (e) {
        if (e.toString().contains('TimeoutException')) {
          FirestoreLogger.logResponse(
            operation: 'DELETE_USER_DOCUMENT',
            path: path,
            success: false,
            error: 'TimeoutException',
          );
          return ApiResult.failure(FireStoreTimeoutException());
        }
        FirestoreLogger.logResponse(
          operation: 'DELETE_USER_DOCUMENT',
          path: path,
          success: false,
          error: e.toString(),
        );
        return ApiResult.failure(
          FireStoreException('Unexpected error: ${e.toString()}'),
        );
      }
    });
  }

  // Delete document from user subCollection
  Future<ApiResult<void>> deleteSubCollectionDocument({
    required String userId,
    required String subCollection,
    required String subCollectionId,
    Duration timeout = _defaultTimeout,
  }) async {
    final path =
        '${Collection.users.name}/$userId/$subCollection/$subCollectionId';
    FirestoreLogger.logRequest(
      operation: 'DELETE_SUB_COLLECTION_DOCUMENT',
      path: path,
    );
    return await _executeWithConnectivityCheck(() async {
      try {
        final ref = FirebaseFirestore.instance
            .collection(Collection.users.name)
            .doc(userId)
            .collection(subCollection)
            .doc(subCollectionId);
        await ref.delete().timeout(timeout);
        FirestoreLogger.logResponse(
          operation: 'DELETE_SUB_COLLECTION_DOCUMENT',
          path: path,
          success: true,
          data: 'Document deleted successfully',
        );
        return ApiResult.success(null);
      } on FirebaseException catch (e) {
        FirestoreLogger.logResponse(
          operation: 'DELETE_SUB_COLLECTION_DOCUMENT',
          path: path,
          success: false,
          error: 'FirebaseException: ${e.code} - ${e.message}',
        );
        return ApiResult.failure(ApiErrorHandler.fromFireStoreError(e));
      } catch (e) {
        if (e.toString().contains('TimeoutException')) {
          FirestoreLogger.logResponse(
            operation: 'DELETE_SUB_COLLECTION_DOCUMENT',
            path: path,
            success: false,
            error: 'TimeoutException',
          );
          return ApiResult.failure(FireStoreTimeoutException());
        }
        FirestoreLogger.logResponse(
          operation: 'DELETE_SUB_COLLECTION_DOCUMENT',
          path: path,
          success: false,
          error: e.toString(),
        );
        return ApiResult.failure(
          FireStoreException('Unexpected error: ${e.toString()}'),
        );
      }
    });
  }

  // ========== NESTED SUBCOLLECTION METHODS ==========
  // For paths like: users/{userId}/bookmarks/{bookmarkId}/bookmarkItems/{itemId}

  // Create document in nested subCollection
  Future<ApiResult<T>> createNestedSubCollectionDocument<T>({
    required String userId,
    required String parentCollection,
    required String parentDocumentId,
    required String subCollection,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic> data, String id) parser,
    Duration timeout = _defaultTimeout,
  }) async {
    final path =
        '${Collection.users.name}/$userId/$parentCollection/$parentDocumentId/$subCollection';
    FirestoreLogger.logRequest(
      operation: 'CREATE_NESTED_SUB_COLLECTION_DOCUMENT',
      path: path,
      data: data,
    );
    return await _executeWithConnectivityCheck(() async {
      try {
        final ref = FirebaseFirestore.instance
            .collection(Collection.users.name)
            .doc(userId)
            .collection(parentCollection)
            .doc(parentDocumentId)
            .collection(subCollection)
            .doc();
        await ref.set(data).timeout(timeout);
        final doc = await ref.get().timeout(timeout);
        final result = parser(doc.data() ?? {}, doc.id);
        FirestoreLogger.logResponse(
          operation: 'CREATE_NESTED_SUB_COLLECTION_DOCUMENT',
          path: '$path/${doc.id}',
          success: true,
          data: doc.data(),
        );
        return ApiResult.success(result);
      } on FirebaseException catch (e) {
        FirestoreLogger.logResponse(
          operation: 'CREATE_NESTED_SUB_COLLECTION_DOCUMENT',
          path: path,
          success: false,
          error: 'FirebaseException: ${e.code} - ${e.message}',
        );
        return ApiResult.failure(ApiErrorHandler.fromFireStoreError(e));
      } catch (e) {
        if (e.toString().contains('TimeoutException')) {
          FirestoreLogger.logResponse(
            operation: 'CREATE_NESTED_SUB_COLLECTION_DOCUMENT',
            path: path,
            success: false,
            error: 'TimeoutException',
          );
          return ApiResult.failure(FireStoreTimeoutException());
        }
        FirestoreLogger.logResponse(
          operation: 'CREATE_NESTED_SUB_COLLECTION_DOCUMENT',
          path: path,
          success: false,
          error: e.toString(),
        );
        return ApiResult.failure(
          FireStoreException('Unexpected error: ${e.toString()}'),
        );
      }
    });
  }

  // Get documents from nested subCollection
  Future<ApiResult<List<T>>> getNestedSubCollections<T>({
    required String userId,
    required String parentCollection,
    required String parentDocumentId,
    required String subCollection,
    required T Function(Map<String, dynamic> data, String id) parser,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)?
    queryBuilder,
    Duration timeout = _defaultTimeout,
  }) async {
    final path =
        '${Collection.users.name}/$userId/$parentCollection/$parentDocumentId/$subCollection';
    FirestoreLogger.logRequest(
      operation: 'GET_NESTED_SUB_COLLECTIONS',
      path: path,
    );
    return await _executeWithConnectivityCheck(() async {
      try {
        Query<Map<String, dynamic>> query = FirebaseFirestore.instance
            .collection(Collection.users.name)
            .doc(userId)
            .collection(parentCollection)
            .doc(parentDocumentId)
            .collection(subCollection);
        if (queryBuilder != null) {
          query = queryBuilder(query);
        }
        final snapshot = await query.get().timeout(timeout);
        final results = snapshot.docs
            .map((doc) => parser(doc.data(), doc.id))
            .toList();
        final docsData = snapshot.docs.map((doc) => doc.data()).toList();
        FirestoreLogger.logResponse(
          operation: 'GET_NESTED_SUB_COLLECTIONS',
          path: path,
          success: true,
          data: {'count': docsData.length, 'documents': docsData},
        );
        return ApiResult.success(results);
      } on FirebaseException catch (e) {
        FirestoreLogger.logResponse(
          operation: 'GET_NESTED_SUB_COLLECTIONS',
          path: path,
          success: false,
          error: 'FirebaseException: ${e.code} - ${e.message}',
        );
        return ApiResult.failure(ApiErrorHandler.fromFireStoreError(e));
      } catch (e) {
        if (e.toString().contains('TimeoutException')) {
          FirestoreLogger.logResponse(
            operation: 'GET_NESTED_SUB_COLLECTIONS',
            path: path,
            success: false,
            error: 'TimeoutException',
          );
          return ApiResult.failure(FireStoreTimeoutException());
        }
        FirestoreLogger.logResponse(
          operation: 'GET_NESTED_SUB_COLLECTIONS',
          path: path,
          success: false,
          error: e.toString(),
        );
        return ApiResult.failure(
          FireStoreException('Unexpected error: ${e.toString()}'),
        );
      }
    });
  }

  // Delete document from nested subCollection
  Future<ApiResult<void>> deleteNestedSubCollectionDocument({
    required String userId,
    required String parentCollection,
    required String parentDocumentId,
    required String subCollection,
    required String subCollectionId,
    Duration timeout = _defaultTimeout,
  }) async {
    final path =
        '${Collection.users.name}/$userId/$parentCollection/$parentDocumentId/$subCollection/$subCollectionId';
    FirestoreLogger.logRequest(
      operation: 'DELETE_NESTED_SUB_COLLECTION_DOCUMENT',
      path: path,
    );
    return await _executeWithConnectivityCheck(() async {
      try {
        final ref = FirebaseFirestore.instance
            .collection(Collection.users.name)
            .doc(userId)
            .collection(parentCollection)
            .doc(parentDocumentId)
            .collection(subCollection)
            .doc(subCollectionId);
        await ref.delete().timeout(timeout);
        FirestoreLogger.logResponse(
          operation: 'DELETE_NESTED_SUB_COLLECTION_DOCUMENT',
          path: path,
          success: true,
          data: 'Document deleted successfully',
        );
        return ApiResult.success(null);
      } on FirebaseException catch (e) {
        FirestoreLogger.logResponse(
          operation: 'DELETE_NESTED_SUB_COLLECTION_DOCUMENT',
          path: path,
          success: false,
          error: 'FirebaseException: ${e.code} - ${e.message}',
        );
        return ApiResult.failure(ApiErrorHandler.fromFireStoreError(e));
      } catch (e) {
        if (e.toString().contains('TimeoutException')) {
          FirestoreLogger.logResponse(
            operation: 'DELETE_NESTED_SUB_COLLECTION_DOCUMENT',
            path: path,
            success: false,
            error: 'TimeoutException',
          );
          return ApiResult.failure(FireStoreTimeoutException());
        }
        FirestoreLogger.logResponse(
          operation: 'DELETE_NESTED_SUB_COLLECTION_DOCUMENT',
          path: path,
          success: false,
          error: e.toString(),
        );
        return ApiResult.failure(
          FireStoreException('Unexpected error: ${e.toString()}'),
        );
      }
    });
  }

  // Delete all documents in a nested subcollection for a specific parent document
  // For paths like: users/{userId}/bookmarks/{bookmarkId}/bookmarkItems
  Future<ApiResult<void>> deleteAllNestedSubCollectionDocuments({
    required String userId,
    required String parentCollection,
    required String parentDocumentId,
    required String subCollection,
    Duration timeout = _defaultTimeout,
  }) async {
    final path =
        '${Collection.users.name}/$userId/$parentCollection/$parentDocumentId/$subCollection';
    FirestoreLogger.logRequest(
      operation: 'DELETE_ALL_NESTED_SUB_COLLECTION_DOCUMENTS',
      path: path,
    );
    return await _executeWithConnectivityCheck(() async {
      try {
        final nestedSubCollectionRef = FirebaseFirestore.instance
            .collection(Collection.users.name)
            .doc(userId)
            .collection(parentCollection)
            .doc(parentDocumentId)
            .collection(subCollection);

        final snapshot = await nestedSubCollectionRef.get().timeout(timeout);

        if (snapshot.docs.isEmpty) {
          FirestoreLogger.logResponse(
            operation: 'DELETE_ALL_NESTED_SUB_COLLECTION_DOCUMENTS',
            path: path,
            success: true,
            data: 'No documents available',
          );
          return ApiResult.success(null);
        }

        const batchSize = 500;
        int totalDeleted = 0;

        // Delete in batches
        for (int i = 0; i < snapshot.docs.length; i += batchSize) {
          final batch = FirebaseFirestore.instance.batch();
          final end = (i + batchSize < snapshot.docs.length)
              ? i + batchSize
              : snapshot.docs.length;
          for (int j = i; j < end; j++) {
            batch.delete(snapshot.docs[j].reference);
          }
          await batch.commit().timeout(timeout);
          totalDeleted += (end - i);
        }

        FirestoreLogger.logResponse(
          operation: 'DELETE_ALL_NESTED_SUB_COLLECTION_DOCUMENTS',
          path: path,
          success: true,
          data: '$totalDeleted documents deleted successfully',
        );
        return ApiResult.success(null);
      } on FirebaseException catch (e) {
        FirestoreLogger.logResponse(
          operation: 'DELETE_ALL_NESTED_SUB_COLLECTION_DOCUMENTS',
          path: path,
          success: false,
          error: 'FirebaseException: ${e.code} - ${e.message}',
        );
        return ApiResult.failure(ApiErrorHandler.fromFireStoreError(e));
      } catch (e) {
        if (e.toString().contains('TimeoutException')) {
          FirestoreLogger.logResponse(
            operation: 'DELETE_ALL_NESTED_SUB_COLLECTION_DOCUMENTS',
            path: path,
            success: false,
            error: 'TimeoutException',
          );
          return ApiResult.failure(FireStoreTimeoutException());
        }
        FirestoreLogger.logResponse(
          operation: 'DELETE_ALL_NESTED_SUB_COLLECTION_DOCUMENTS',
          path: path,
          success: false,
          error: e.toString(),
        );
        return ApiResult.failure(
          FireStoreException('Unexpected error: ${e.toString()}'),
        );
      }
    });
  }

  Future<ApiResult<void>> deleteAllSubCollection({
    required String userId,
    required String subCollection,
    Duration timeout = _defaultTimeout,
  }) async {
    final path = '${Collection.users.name}/$userId/$subCollection';
    FirestoreLogger.logRequest(
      operation: 'DELETE_ALL_SUB_COLLECTION_DOCUMENTS',
      path: path,
    );
    return await _executeWithConnectivityCheck(() async {
      try {
        final subCollectionRef = FirebaseFirestore.instance
            .collection(Collection.users.name)
            .doc(userId)
            .collection(subCollection);
        QuerySnapshot snapshot = await subCollectionRef.get().timeout(timeout);
        if (snapshot.docs.isEmpty) {
          FirestoreLogger.logResponse(
            operation: 'DELETE_ALL_SUB_COLLECTION_DOCUMENTS',
            path: path,
            success: true,
            data: 'No documents available',
          );
          return ApiResult.success(null);
        }
        const batchSize = 500;
        int totalDeleted = 0;
        for (int i = 0; i < snapshot.docs.length; i += batchSize) {
          final batch = FirebaseFirestore.instance.batch();
          final end = (i + batchSize < snapshot.docs.length)
              ? i + batchSize
              : snapshot.docs.length;
          for (int j = i; j < end; j++) {
            batch.delete(snapshot.docs[j].reference);
          }
          await batch.commit().timeout(timeout);
          totalDeleted += (end - i);
        }
        FirestoreLogger.logResponse(
          operation: 'DELETE_ALL_SUB_COLLECTION_DOCUMENTS',
          path: path,
          success: true,
          data: '$totalDeleted documents deleted successfully',
        );
        return ApiResult.success(null);
      } on FirebaseException catch (e) {
        FirestoreLogger.logResponse(
          operation: 'DELETE_ALL_SUB_COLLECTION_DOCUMENTS',
          path: path,
          success: false,
          error: 'FirebaseException: ${e.code} - ${e.message}',
        );
        return ApiResult.failure(ApiErrorHandler.fromFireStoreError(e));
      } catch (e) {
        if (e.toString().contains('TimeoutException')) {
          FirestoreLogger.logResponse(
            operation: 'DELETE_ALL_SUB_COLLECTION_DOCUMENTS',
            path: path,
            success: false,
            error: 'TimeoutException',
          );
          return ApiResult.failure(FireStoreTimeoutException());
        }
        FirestoreLogger.logResponse(
          operation: 'DELETE_ALL_SUB_COLLECTION_DOCUMENTS',
          path: path,
          success: false,
          error: e.toString(),
        );
        return ApiResult.failure(
          FireStoreException('Unexpected error: ${e.toString()}'),
        );
      }
    });
  }

  // Delete all nested subcollections recursively
  // For paths like: users/{userId}/bookmarks/{bookmarkId}/bookmarkItems
  Future<ApiResult<void>> deleteAllNestedSubCollections({
    required String userId,
    required String parentCollection,
    required String subCollection,
    Duration timeout = _defaultTimeout,
  }) async {
    final path =
        '${Collection.users.name}/$userId/$parentCollection/*/$subCollection';
    FirestoreLogger.logRequest(
      operation: 'DELETE_ALL_NESTED_SUB_COLLECTIONS',
      path: path,
    );
    return await _executeWithConnectivityCheck(() async {
      try {
        // First, get all parent documents
        final parentCollectionRef = FirebaseFirestore.instance
            .collection(Collection.users.name)
            .doc(userId)
            .collection(parentCollection);
        final parentSnapshot = await parentCollectionRef.get().timeout(timeout);

        if (parentSnapshot.docs.isEmpty) {
          FirestoreLogger.logResponse(
            operation: 'DELETE_ALL_NESTED_SUB_COLLECTIONS',
            path: path,
            success: true,
            data: 'No parent documents available',
          );
          return ApiResult.success(null);
        }

        int totalDeleted = 0;
        const batchSize = 500;

        // For each parent document, delete all nested subcollection documents
        for (final parentDoc in parentSnapshot.docs) {
          final nestedSubCollectionRef = parentDoc.reference.collection(
            subCollection,
          );
          final nestedSnapshot = await nestedSubCollectionRef.get().timeout(
            timeout,
          );

          if (nestedSnapshot.docs.isNotEmpty) {
            // Delete in batches
            for (int i = 0; i < nestedSnapshot.docs.length; i += batchSize) {
              final batch = FirebaseFirestore.instance.batch();
              final end = (i + batchSize < nestedSnapshot.docs.length)
                  ? i + batchSize
                  : nestedSnapshot.docs.length;
              for (int j = i; j < end; j++) {
                batch.delete(nestedSnapshot.docs[j].reference);
              }
              await batch.commit().timeout(timeout);
              totalDeleted += (end - i);
            }
          }
        }

        FirestoreLogger.logResponse(
          operation: 'DELETE_ALL_NESTED_SUB_COLLECTIONS',
          path: path,
          success: true,
          data: '$totalDeleted nested documents deleted successfully',
        );
        return ApiResult.success(null);
      } on FirebaseException catch (e) {
        FirestoreLogger.logResponse(
          operation: 'DELETE_ALL_NESTED_SUB_COLLECTIONS',
          path: path,
          success: false,
          error: 'FirebaseException: ${e.code} - ${e.message}',
        );
        return ApiResult.failure(ApiErrorHandler.fromFireStoreError(e));
      } catch (e) {
        if (e.toString().contains('TimeoutException')) {
          FirestoreLogger.logResponse(
            operation: 'DELETE_ALL_NESTED_SUB_COLLECTIONS',
            path: path,
            success: false,
            error: 'TimeoutException',
          );
          return ApiResult.failure(FireStoreTimeoutException());
        }
        FirestoreLogger.logResponse(
          operation: 'DELETE_ALL_NESTED_SUB_COLLECTIONS',
          path: path,
          success: false,
          error: e.toString(),
        );
        return ApiResult.failure(
          FireStoreException('Unexpected error: ${e.toString()}'),
        );
      }
    });
  }
}
