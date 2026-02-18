// import 'package:cbl/cbl.dart' hide Logger;
// import 'package:cbl_flutter/cbl_flutter.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:logging/logging.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shikshapatri/app/core/shared/database/couchbase_index_creator.dart';
// import 'package:shikshapatri/app/core/shared/database/couchbase_prebuilt_database_copier.dart';
//
// /// Universal service to manage Couchbase Lite database operations
// ///
// /// This service provides only universal database access methods.
// /// Domain-specific queries should be handled in repositories.
// ///
// /// Usage:
// /// ```dart
// /// // Initialize in main.dart
// /// final dbService = await CouchbaseDatabaseService().init();
// /// Get.put(dbService);
// ///
// /// // Use via extension
// /// final query = QueryBuilder()
// ///     .select(SelectResult.all())
// ///     .from(DataSource.database(db))
// ///     .where(Expression.property('type').equalTo(Expression.string('shlok')));
// ///
// /// final results = await couchbaseDatabaseService.executeQuery(query);
// /// ```
// class CouchbaseDatabaseService extends GetxService {
//   // ============================================================================
//   // CONSTANTS
//   // ============================================================================
//
//   static const String _databaseName = 'shikshapatri';
//
//   static final Logger _logger = Logger('CouchbaseDatabaseService');
//
//   // ============================================================================
//   // PRIVATE FIELDS
//   // ============================================================================
//
//   Database? _database;
//   DatabaseConfiguration? _dbConfig;
//
//   // ============================================================================
//   // INITIALIZATION & DATABASE ACCESS
//   // ============================================================================
//
//   /// Initialize the service (call this in main.dart)
//   /// Note: CouchbaseLiteFlutter.init() should be called in main.dart first
//   Future<CouchbaseDatabaseService> init() async {
//     _logger.info('🚀 Initializing CouchbaseDatabaseService...');
//     try {
//       // Couchbase Lite should already be initialized in main.dart
//       // If not, try to initialize it here as a fallback
//       try {
//         await CouchbaseLiteFlutter.init();
//         _logger.info('✅ Couchbase Lite initialized in service');
//       } catch (e) {
//         // Already initialized or different error - proceed
//         _logger.fine('Couchbase Lite init check: $e');
//       }
//
//       await openDatabase();
//       _logger.info('✅ CouchbaseDatabaseService initialized successfully');
//     } catch (e) {
//       _logger.severe('❌ CouchbaseDatabaseService initialization failed: $e');
//       rethrow;
//     }
//     return this;
//   }
//
//   /// Initialize and open the database
//   /// This will copy the prebuilt database from assets if it doesn't exist
//   Future<Database> openDatabase() async {
//     try {
//       _logger.info('🔄 Starting database initialization...');
//
//       // Get application documents directory
//       final directory = await getApplicationDocumentsDirectory();
//       final dbDirectory = '${directory.path}/databases';
//       _logger.info('📁 Database directory: $dbDirectory');
//
//       // Create database configuration
//       _dbConfig = DatabaseConfiguration(directory: dbDirectory);
//
//       // Check if database already exists
//       final dbExists = await Database.exists(
//         _databaseName,
//         directory: dbDirectory,
//       );
//       if (dbExists) {
//         _logger.info('✅ Database already exists, opening...');
//       } else {
//         _logger.info(
//           '📦 Database does not exist, attempting to copy from assets...',
//         );
//       }
//
//       // Get current app version to check if database needs updating
//       String currentBuildNumber = '1';
//       try {
//         final packageInfo = await PackageInfo.fromPlatform();
//         currentBuildNumber = packageInfo.buildNumber;
//         _logger.info('📱 Current app build number: $currentBuildNumber');
//       } catch (e) {
//         _logger.warning('⚠️ Failed to get app version: $e. Using default build number.');
//       }
//
//       // Copy prebuilt database from assets if it doesn't exist or version changed
//       try {
//         _logger.info('📥 Attempting to copy/update prebuilt database from assets...');
//         await CouchbasePrebuiltDatabaseCopier.copy(
//           _databaseName,
//           _dbConfig!,
//           currentBuildNumber,
//         );
//         _logger.info('✅ Prebuilt database copied/updated successfully');
//       } catch (e) {
//         _logger.warning('⚠️ Failed to copy prebuilt database: $e');
//         _logger.info('💡 Creating empty database instead...');
//
//         // Database file not found in assets - create empty database instead
//         if (await Database.exists(_databaseName, directory: dbDirectory)) {
//           _logger.info('✅ Existing database found, will open it');
//         } else {
//           // Create a new empty database
//           _logger.info('🆕 Creating new empty database...');
//           _database = await Database.openAsync(_databaseName, _dbConfig!);
//           _logger.info('✅ Empty database created and opened successfully');
//           return _database!;
//         }
//       }
//
//       // Open the database
//       _logger.info('🔓 Opening database...');
//       _database = await Database.openAsync(_databaseName, _dbConfig!);
//       _logger.info('✅ Database opened successfully: $_databaseName');
//
//       // Create indexes for better query performance
//       try {
//         await CouchbaseIndexCreator.createAppIndexes(_database!);
//       } catch (e) {
//         _logger.warning('⚠️ Failed to create indexes: $e');
//         // Continue - indexes are optional for functionality
//       }
//
//       return _database!;
//     } catch (e, stackTrace) {
//       _logger.severe('❌ Failed to open database', e, stackTrace);
//       throw Exception('Failed to open database: $e');
//     }
//   }
//
//   /// Get the database instance (opens if not already open)
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     return await openDatabase();
//   }
//
//   /// Check if database service is registered and available
//   bool get isAvailable => Get.isRegistered<CouchbaseDatabaseService>();
//
//   /// Get database instance safely
//   Future<Database?> get databaseSafe async {
//     if (!isAvailable) return null;
//     try {
//       return await database;
//     } catch (e) {
//       if (kDebugMode) {
//         print('⚠️ Database error: $e');
//       }
//       return null;
//     }
//   }
//
//   /// Get the database instance synchronously (if already opened)
//   /// Returns null if database is not yet opened
//   Database? get databaseSync => _database;
//
//   /// Close the database
//   Future<void> closeDatabase() async {
//     if (_database != null) {
//       _logger.info('🔒 Closing database...');
//       await _database?.close();
//       _database = null;
//       _logger.info('✅ Database closed');
//     }
//   }
//
//   // ============================================================================
//   // UNIVERSAL QUERY METHODS
//   // ============================================================================
//
//   /// Universal query function to execute any query and return results as dictionaries
//   /// This is a generic function that can be used by repositories for custom queries
//   ///
//   /// Example:
//   /// ```dart
//   /// final db = await couchbaseDatabaseService.databaseSafe;
//   /// if (db == null) return [];
//   ///
//   /// final query = QueryBuilder()
//   ///     .select(SelectResult.all())
//   ///     .from(DataSource.database(db))
//   ///     .where(Expression.property('type').equalTo(Expression.string('shlok')))
//   ///     .orderBy(Ordering.property('number').ascending());
//   ///
//   /// final results = await couchbaseDatabaseService.executeQuery(query);
//   /// ```
//   Future<List<Dictionary>> executeQuery(Query query) async {
//     final db = await databaseSafe;
//     if (db == null) return [];
//
//     try {
//       final resultSet = await query.execute();
//       final results = await resultSet.allResults();
//
//       return results
//           .map((result) => result.dictionary(0))
//           .whereType<Dictionary>()
//           .toList();
//     } catch (e) {
//       _logError('executing query', e);
//       return [];
//     }
//   }
//
//   // ============================================================================
//   // ERROR HANDLING HELPERS
//   // ============================================================================
//
//   /// Log error with consistent format
//   void _logError(String operation, dynamic error) {
//     if (kDebugMode) {
//       print('❌ Error $operation: $error');
//     }
//     _logger.warning('Error $operation: $error');
//   }
//
//   // ============================================================================
//   // LIFECYCLE
//   // ============================================================================
//
//   @override
//   void onClose() {
//     closeDatabase();
//     super.onClose();
//   }
// }
