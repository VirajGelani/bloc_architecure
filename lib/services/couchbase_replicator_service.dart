// import 'package:cbl/cbl.dart' hide Logger;
// import 'package:flutter/foundation.dart';
// import 'package:logging/logging.dart';
//
// /// Service to manage Couchbase database replication in the background
// ///
// /// This service handles continuous pull replication from the Couchbase Sync Gateway,
// /// keeping the local database synchronized with the remote server.
// ///
// /// Usage:
// /// ```dart
// /// // Initialize in main.dart after database service
// /// final replicatorService = await CouchbaseReplicatorService().init(database);
// /// Get.put(replicatorService);
// /// ```
// class CouchbaseReplicatorService {
//   // ============================================================================
//   // CONSTANTS
//   // ============================================================================
//
//   static final Logger _logger = Logger('CouchbaseReplicatorService');
//
//   // ============================================================================
//   // PRIVATE FIELDS
//   // ============================================================================
//
//   Replicator? _replicator;
//   Database? _database;
//   bool _isReplicating = false;
//   int _totalDocumentsReplicated = 0;
//   ReplicatorActivityLevel _previousActivity = ReplicatorActivityLevel.idle;
//
//   // ============================================================================
//   // OBSERVABLES
//   // ============================================================================
//
//   /// Current replication activity level
//   final Rx<ReplicatorActivityLevel> replicationActivity =
//       ReplicatorActivityLevel.idle;
//
//   /// Number of documents replicated in the last sync
//   final RxInt documentsReplicated = 0.obs;
//
//   /// Last error message, if any
//   final RxString lastError = ''.obs;
//
//   // ============================================================================
//   // INITIALIZATION
//   // ============================================================================
//
//   /// Initialize and start the replicator service
//   /// This will start continuous pull replication from the sync gateway
//   /// This method is called every time the app launches, ensuring replication
//   /// restarts even if the app was killed or user hasn't opened it in days
//   Future<CouchbaseReplicatorService> init(Database database) async {
//     _logger.info('🚀 Initializing CouchbaseReplicatorService...');
//     _logger.info(
//       '📱 App launch detected - Replication will sync all changes since last sync',
//     );
//     _database = database;
//
//     try {
//       // Validate configuration
//       if (URLs.couchURL.isEmpty) {
//         _logger.warning(
//           '⚠️ Couchbase URL not configured, skipping replication',
//         );
//         return this;
//       }
//
//       await _startReplication();
//       _logger.info('✅ CouchbaseReplicatorService initialized successfully');
//       _logger.info(
//         '🔄 Continuous replication active - Database will stay synced in background',
//       );
//     } catch (e, stackTrace) {
//       _logger.severe(
//         '❌ CouchbaseReplicatorService initialization failed',
//         e,
//         stackTrace,
//       );
//       lastError.value = e.toString();
//       // Don't throw - allow app to continue without replication
//     }
//
//     return this;
//   }
//
//   /// Start the replication process
//   Future<void> _startReplication() async {
//     final database = _database;
//     if (database == null) {
//       throw Exception('Database not initialized');
//     }
//
//     if (_isReplicating) {
//       _logger.info('🔄 Replication already running');
//       return;
//     }
//
//     try {
//       _logger.info('📡 Starting replication listeners...');
//
//       // Build the endpoint URL
//       // URL format should match scripts/db-sync.sh:
//       // Staging: wss://syncgateway.swaminarayan.faith/shikshapatri-staging
//       // Production: wss://syncgateway.swaminarayan.faith/shikshapatri (or similar)
//       final endpointUri = Uri.parse(URLs.couchURL);
//       final target = UrlEndpoint(endpointUri);
//
//       _logger.info('🔗 Replication endpoint: ${URLs.couchURL}');
//
//       // Create authenticator if credentials are provided
//       Authenticator? authenticator;
//       if (URLs.couchUsername.isNotEmpty && URLs.couchPassword.isNotEmpty) {
//         authenticator = BasicAuthenticator(
//           username: URLs.couchUsername,
//           password: URLs.couchPassword,
//         );
//         _logger.info('🔐 Using Basic Authentication');
//       } else {
//         _logger.info('🔓 No authentication configured');
//       }
//
//       // Create replicator configuration
//       // Note: continuous=true ensures replication keeps running in background
//       // This will sync all changes from server, including latest data on app launch
//       final config = ReplicatorConfiguration(
//         target: target,
//         authenticator: authenticator,
//         replicatorType: ReplicatorType.pull,
//         continuous: true, // Keep replicating in the background
//       )..addCollection(await database.defaultCollection);
//
//       _logger.info(
//         '📡 Replicator configured: Pull replication (continuous) | '
//         'Will sync all changes from server on app launch and keep syncing in background',
//       );
//
//       // Create replicator instance
//       final replicator = await Replicator.create(config);
//       _replicator = replicator;
//
//       // Add change listener to track replication status
//       replicator.addChangeListener((change) {
//         _handleReplicationStatusChange(change);
//       });
//
//       // Add document replication listener to track document sync
//       replicator.addDocumentReplicationListener((change) {
//         _handleDocumentReplication(change);
//       });
//
//       // Start the replicator
//       await replicator.start();
//       _isReplicating = true;
//       _previousActivity = ReplicatorActivityLevel.idle;
//       _totalDocumentsReplicated = 0;
//       _logger.info(
//         '✅ Started continuous replication from sync gateway: ${URLs.couchURL}',
//       );
//       _logger.info('🔄 Background replication service is now active');
//     } catch (e, stackTrace) {
//       _logger.severe('❌ Failed to start replication', e, stackTrace);
//       lastError.value = e.toString();
//       _isReplicating = false;
//       rethrow;
//     }
//   }
//
//   // ============================================================================
//   // EVENT HANDLERS
//   // ============================================================================
//
//   /// Handle replication status changes
//   void _handleReplicationStatusChange(ReplicatorChange change) {
//     final status = change.status;
//     final currentActivity = status.activity;
//     replicationActivity.value = currentActivity;
//
//     final completed = status.progress.completed;
//
//     _logger.info(
//       '📊 Replication Status: ${currentActivity.name} | '
//       'Progress: $completed documents completed | '
//       'Error: ${status.error ?? "None"}',
//     );
//
//     // Log when replication completes in background
//     if (_previousActivity == ReplicatorActivityLevel.busy &&
//         currentActivity == ReplicatorActivityLevel.idle) {
//       if (_totalDocumentsReplicated > 0) {
//         _logger.info(
//           '✅ Background replication completed successfully! | '
//           'Total documents synced: $completed | '
//           'Total documents in this session: $_totalDocumentsReplicated',
//         );
//       } else {
//         _logger.info(
//           '✅ Background replication cycle completed | '
//           'No new documents to sync (database is up to date)',
//         );
//       }
//       _totalDocumentsReplicated = 0; // Reset for next session
//     }
//
//     // Log when replication starts
//     if (_previousActivity != ReplicatorActivityLevel.busy &&
//         currentActivity == ReplicatorActivityLevel.busy) {
//       _logger.info('🔄 Background replication started...');
//     }
//
//     // Log when replication is stopped
//     if (_previousActivity == ReplicatorActivityLevel.busy &&
//         currentActivity == ReplicatorActivityLevel.stopped) {
//       _logger.info(
//         '⏸️ Background replication stopped | '
//         'Documents synced: $completed',
//       );
//     }
//
//     // Log reconnection attempts and successful reconnections
//     if (_previousActivity == ReplicatorActivityLevel.offline &&
//         currentActivity == ReplicatorActivityLevel.busy) {
//       if (status.error != null) {
//         _logger.info(
//           '🔄 Reconnection attempt: Retrying replication after error...',
//         );
//       } else {
//         _logger.info('✅ Reconnection successful: Replication resumed');
//       }
//     }
//
//     _previousActivity = currentActivity;
//
//     if (status.error != null) {
//       final errorStr = status.error.toString();
//       lastError.value = errorStr;
//       _logger.warning('⚠️ Replication error: $errorStr');
//     } else {
//       lastError.value = '';
//     }
//   }
//
//   /// Handle document replication events
//   void _handleDocumentReplication(DocumentReplication change) {
//     final documentCount = change.documents.length;
//     documentsReplicated.value = documentCount;
//
//     if (documentCount > 0) {
//       _totalDocumentsReplicated += documentCount;
//
//       _logger.info(
//         '📥 Background replication: $documentCount document(s) synced from server',
//       );
//
//       // Log document IDs for debugging (optional)
//       if (kDebugMode) {
//         for (final doc in change.documents) {
//           _logger.fine('  - Document ID: ${doc.id}');
//         }
//       }
//
//       // Log completion summary for this batch
//       _logger.info(
//         '✅ Batch replication completed: $documentCount document(s) updated in local Couchbase Lite database',
//       );
//     }
//   }
//
//   // ============================================================================
//   // PUBLIC METHODS
//   // ============================================================================
//
//   /// Stop the replicator
//   Future<void> stop() async {
//     if (_replicator != null && _isReplicating) {
//       _logger.info('🛑 Stopping replication...');
//       await _replicator!.stop();
//       _isReplicating = false;
//       replicationActivity.value = ReplicatorActivityLevel.idle;
//       _logger.info('✅ Replication stopped');
//     }
//   }
//
//   /// Restart the replicator
//   Future<void> restart() async {
//     _logger.info('🔄 Restarting replication...');
//     await stop();
//     await _startReplication();
//   }
//
//   /// Check if replication is currently active
//   bool get isReplicating => _isReplicating;
//
//   /// Get current replicator instance
//   Replicator? get replicator => _replicator;
//
//   // ============================================================================
//   // LIFECYCLE
//   // ============================================================================
//
//   @override
//   void onClose() {
//     stop();
//     _replicator = null;
//     _database = null;
//     super.onClose();
//   }
// }
