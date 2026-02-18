// import 'dart:developer';
// import 'package:get/get.dart';
// import 'package:shikshapatri/app/core/constants/enums.dart';
// import 'package:shikshapatri/app/services/get_storage_service.dart';
// import 'package:shikshapatri/app/utils/extension.dart';
//
// /// Service to track notification activity and enforce limits
// class NotificationActivityService extends GetxService {
//   static final NotificationActivityService instance =
//       NotificationActivityService._internal();
//   factory NotificationActivityService() => instance;
//   NotificationActivityService._internal();
//
//   /// Check if notification should be suppressed based on activity
//   Future<bool> shouldSuppressNotification({
//     required NotificationKey notificationKey,
//     required int inactivityHours,
//     required bool suppressIfUsedToday,
//     required int cooldownHours,
//     required int maxPerDay,
//     required int maxPerWeek,
//   }) async {
//     // Check if feature was used today (suppress if used)
//     if (suppressIfUsedToday) {
//       final lastActivity = _getLastActivity(notificationKey);
//       if (lastActivity != null) {
//         final now = DateTime.now();
//         final today = DateTime(now.year, now.month, now.day);
//         final activityDate = DateTime(
//           lastActivity.year,
//           lastActivity.month,
//           lastActivity.day,
//         );
//         if (activityDate.isAtSameMomentAs(today)) {
//           log('🔔 Suppressing ${notificationKey.value} - feature used today');
//           return true;
//         }
//       }
//     }
//
//     // Check inactivity hours
//     final lastActivity = _getLastActivity(notificationKey);
//     if (lastActivity != null) {
//       final hoursSinceActivity = DateTime.now()
//           .difference(lastActivity)
//           .inHours;
//       if (hoursSinceActivity < inactivityHours) {
//         log(
//           '🔔 Suppressing ${notificationKey.value} - only $hoursSinceActivity hours since activity (need $inactivityHours)',
//         );
//         return true;
//       }
//     }
//
//     // Check cooldown
//     final lastSent = _getLastSent(notificationKey);
//     if (lastSent != null) {
//       final hoursSinceSent = DateTime.now().difference(lastSent).inHours;
//       if (hoursSinceSent < cooldownHours) {
//         log(
//           '🔔 Suppressing ${notificationKey.value} - cooldown active ($hoursSinceSent/$cooldownHours hours)',
//         );
//         return true;
//       }
//     }
//
//     // Check max per day
//     final todayCount = _getTodayCount(notificationKey);
//     if (todayCount >= maxPerDay) {
//       log(
//         '🔔 Suppressing ${notificationKey.value} - max per day reached ($todayCount/$maxPerDay)',
//       );
//       return true;
//     }
//
//     // Check max per week
//     final weekCount = _getWeekCount(notificationKey);
//     if (weekCount >= maxPerWeek) {
//       log(
//         '🔔 Suppressing ${notificationKey.value} - max per week reached ($weekCount/$maxPerWeek)',
//       );
//       return true;
//     }
//
//     return false;
//   }
//
//   /// Record that notification was sent
//   Future<void> recordNotificationSent(NotificationKey notificationKey) async {
//     final now = DateTime.now();
//     await getStorageService.setString(
//       '${GetStorageService.notificationLastSentPrefix}${notificationKey.value}',
//       now.toIso8601String(),
//     );
//     _incrementTodayCount(notificationKey);
//     _incrementWeekCount(notificationKey);
//     log('📝 Recorded notification sent: ${notificationKey.value}');
//   }
//
//   /// Record feature activity (when user opens/uses the feature)
//   Future<void> recordFeatureActivity(NotificationKey notificationKey) async {
//     final now = DateTime.now();
//     await getStorageService.setString(
//       '${GetStorageService.notificationActivityPrefix}${notificationKey.value}',
//       now.toIso8601String(),
//     );
//     log('📝 Recorded feature activity: ${notificationKey.value}');
//   }
//
//   /// Get last activity time for a feature
//   DateTime? _getLastActivity(NotificationKey notificationKey) {
//     final timestamp = getStorageService.getString(
//       '${GetStorageService.notificationActivityPrefix}${notificationKey.value}',
//     );
//     if (timestamp.isEmpty) return null;
//     try {
//       return DateTime.parse(timestamp);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   /// Get last sent time for a notification
//   DateTime? _getLastSent(NotificationKey notificationKey) {
//     final timestamp = getStorageService.getString(
//       '${GetStorageService.notificationLastSentPrefix}${notificationKey.value}',
//     );
//     if (timestamp.isEmpty) return null;
//     try {
//       return DateTime.parse(timestamp);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   /// Get today's count for a notification
//   int _getTodayCount(NotificationKey notificationKey) {
//     final today = DateTime.now();
//     final todayKey =
//         '${GetStorageService.notificationCountPrefix}${notificationKey.value}_${today.year}_${today.month}_${today.day}';
//     return getStorageService.getInt(todayKey, defaultValue: 0);
//   }
//
//   /// Increment today's count
//   Future<void> _incrementTodayCount(NotificationKey notificationKey) async {
//     final today = DateTime.now();
//     final todayKey =
//         '${GetStorageService.notificationCountPrefix}${notificationKey.value}_${today.year}_${today.month}_${today.day}';
//     final current = _getTodayCount(notificationKey);
//     await getStorageService.setInt(todayKey, current + 1);
//   }
//
//   /// Get week's count for a notification
//   int _getWeekCount(NotificationKey notificationKey) {
//     final now = DateTime.now();
//     final weekStart = now.subtract(Duration(days: now.weekday - 1));
//     final weekKey =
//         '${GetStorageService.notificationCountPrefix}${notificationKey.value}_week_${weekStart.year}_${weekStart.month}_${weekStart.day}';
//     return getStorageService.getInt(weekKey, defaultValue: 0);
//   }
//
//   /// Increment week's count
//   Future<void> _incrementWeekCount(NotificationKey notificationKey) async {
//     final now = DateTime.now();
//     final weekStart = now.subtract(Duration(days: now.weekday - 1));
//     final weekKey =
//         '${GetStorageService.notificationCountPrefix}${notificationKey.value}_week_${weekStart.year}_${weekStart.month}_${weekStart.day}';
//     final current = _getWeekCount(notificationKey);
//     await getStorageService.setInt(weekKey, current + 1);
//   }
//
//   /// Clean up old count data (call periodically)
//   Future<void> cleanupOldData() async {
//     // This can be called periodically to clean up old count data
//     // For now, we'll rely on the date-based keys to naturally expire
//     log('🧹 Notification activity cleanup completed');
//   }
// }
