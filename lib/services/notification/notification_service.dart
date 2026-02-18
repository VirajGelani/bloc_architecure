// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io' show Platform;
//
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shikshapatri/app/core/constants/enums.dart';
// import 'package:shikshapatri/app/routes/app_pages.dart';
// import 'package:shikshapatri/app/services/notification/notification_activity_service.dart';
// import 'package:shikshapatri/app/services/notification/notification_config.dart';
// import 'package:shikshapatri/app/utils/extension.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// import '../../modules/bottombar/controllers/bottombar_controller.dart';
//
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}
//
// @pragma('vm:entry-point')
// void notificationTapBackground(NotificationResponse response) {
//   log('Notification tapped in background/terminated: ${response.payload}');
// }
//
// class NotificationService extends GetxService {
//   static final NotificationService instance = NotificationService._internal();
//
//   bool _isHandlingTap = false;
//   DateTime? _lastTapTime;
//
//
//   // ============================================
//   // 🧪 TEST MODE FLAG - REMOVE IN PRODUCTION 🧪
//   // ============================================
//   // Set this to true to test all notifications immediately (1-4 minutes delay)
//   // Set to false for normal production behavior
//   // TODO: Remove this flag and test mode code before production release
//   static const bool isTestMode = false;
//
//   // ============================================
//   // END TEST MODE FLAG
//   // ============================================
//
//   factory NotificationService() => instance;
//
//   NotificationService._internal();
//
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _local =
//       FlutterLocalNotificationsPlugin();
//
//   Future<NotificationService> init() async {
//     tz.initializeTimeZones();
//     await _setupTimezone();
//
//     if (Platform.isAndroid) {
//       final notifStatus = await Permission.notification.status;
//       log('🔔 Notification permission: $notifStatus');
//       if (!notifStatus.isGranted) {
//         log('🔔 REQUESTING notification permission...');
//         final result = await Permission.notification.request();
//         log('🔔 Permission result: $result');
//       }
//
//       final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
//       log('⏰ Exact alarm permission: $exactAlarmStatus');
//     }
//
//     // Request permissions
//     await _fcm.requestPermission(alert: true, badge: true, sound: true);
//     if (kDebugMode) {
//       // print('FCM Token: ${await _fcm.getToken()}');
//     }
//
//     // FCM tap handlers
//     FirebaseMessaging.onMessageOpenedApp.listen(
//       (msg) => _handleTap(msg.data, AppState.background),
//     );
//     final initial = await _fcm.getInitialMessage();
//     // if (initial != null && !_didHandleInitialLaunch) {
//     //   _didHandleInitialLaunch = true;
//     //   _handleTap(initial.data, AppState.kill);
//     // }
//
//     // Initialize local notifications
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const ios = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//     await _local.initialize(
//       const InitializationSettings(android: android, iOS: ios),
//       onDidReceiveNotificationResponse: (res) {
//         if (res.payload != null) {
//           _handleTap(jsonDecode(res.payload!), AppState.foreground);
//         }
//       },
//       onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
//     );
//
//     // final details = await _local.getNotificationAppLaunchDetails();
//     // if ((details?.didNotificationLaunchApp ?? false) && !_didHandleInitialLaunch) {
//     //   final payload = details?.notificationResponse?.payload;
//     //   if (payload != null && payload.isNotEmpty) {
//     //     try {
//     //       _didHandleInitialLaunch = true;
//     //       final data = jsonDecode(payload);
//     //       _handleTap(data, AppState.kill);
//     //     } catch (e) {
//     //       log('Error handling killed state payload: $e');
//     //     }
//     //   }
//     // }
//
//     // Create channels (important for Android)
//     await _createChannels();
//
//     // FCM foreground handler
//     FirebaseMessaging.onMessage.listen((msg) {
//       final n = msg.notification;
//       if (n != null) {
//         _showNotification(
//           title: n.title!,
//           body: n.body!,
//           payload: jsonEncode(msg.data),
//         );
//       }
//     });
//
//     // ============================================
//     // 🧪 TEST MODE - REMOVE IN PRODUCTION 🧪
//     // ============================================
//     // Change isTestMode constant above to true to test all notifications
//     // This will schedule all notifications to fire in 1-4 minutes for testing
//     // TODO: Remove this test mode before production release
//     if (isTestMode) {
//       log('🧪 TEST MODE ENABLED - Scheduling test notifications...');
//       await _scheduleTestNotifications();
//     } else {
//       // Normal production mode - schedule notifications at their configured times
//       await scheduleAllNotifications();
//     }
//     // ============================================
//     // END TEST MODE
//     // ============================================
//
//     return this;
//   }
//
//   Future<void> _createChannels() async {
//     if (!Platform.isAndroid) return;
//
//     final androidPlugin = _local
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >();
//     if (androidPlugin == null) return;
//
//     const channels = [
//       AndroidNotificationChannel(
//         'default_channel',
//         'General',
//         description: 'All app notifications',
//         importance: Importance.high,
//       ),
//       AndroidNotificationChannel(
//         'daily_shlok_channel',
//         'Daily Shlok',
//         description: 'Your daily spiritual reminder',
//         importance: Importance.max,
//         playSound: true,
//         enableVibration: true,
//       ),
//       AndroidNotificationChannel(
//         'reading_nudge_channel',
//         'Reading Reminder',
//         description: 'Continue your reading journey',
//         importance: Importance.high,
//         playSound: true,
//         enableVibration: true,
//       ),
//       AndroidNotificationChannel(
//         'quiz_nudge_channel',
//         'Quiz Challenge',
//         description: 'Test your knowledge',
//         importance: Importance.high,
//         playSound: true,
//         enableVibration: true,
//       ),
//       AndroidNotificationChannel(
//         'sanskrit_nudge_channel',
//         'Sanskrit Learning',
//         description: 'Learn Sanskrit daily',
//         importance: Importance.high,
//         playSound: true,
//         enableVibration: true,
//       ),
//     ];
//
//     for (final channel in channels) {
//       await androidPlugin.createNotificationChannel(channel);
//     }
//     log('Notification channels created');
//   }
//
//   Future<void> _showNotification({
//     required String title,
//     required String body,
//     required String payload,
//   }) async {
//     const android = AndroidNotificationDetails('default_channel', 'General');
//     const ios = DarwinNotificationDetails();
//     await _local.show(
//       DateTime.now().millisecondsSinceEpoch.hashCode,
//       title,
//       body,
//       const NotificationDetails(android: android, iOS: ios),
//       payload: payload,
//     );
//   }
//
//   Future<void> _setupTimezone() async {
//     try {
//       final TimezoneInfo tzName = await FlutterTimezone.getLocalTimezone();
//       tz.setLocalLocation(tz.getLocation(tzName.identifier));
//       log('Timezone set: $tzName');
//     } catch (e) {
//       tz.setLocalLocation(tz.getLocation('UTC'));
//       log('Timezone fallback to UTC');
//     }
//   }
//
//   Future<AndroidScheduleMode> _getBestScheduleMode() async {
//     if (!Platform.isAndroid) return AndroidScheduleMode.exactAllowWhileIdle;
//
//     final androidInfo = await DeviceInfoPlugin().androidInfo;
//
//     // Android 11 and below - use exact mode
//     if (androidInfo.version.sdkInt < 31) {
//       return AndroidScheduleMode.exactAllowWhileIdle;
//     }
//
//     // Android 12+ - check for exact alarm permission
//     var status = await Permission.scheduleExactAlarm.status;
//     if (!status.isGranted) {
//       log('⏰ Requesting exact alarm permission...');
//       status = await Permission.scheduleExactAlarm.request();
//       log('⏰ Exact alarm permission result: $status');
//     }
//
//     // CRITICAL FIX: Use exactAllowWhileIdle if permission is granted!
//     if (status.isGranted) {
//       log('✅ Using exactAllowWhileIdle (most reliable)');
//       return AndroidScheduleMode.exactAllowWhileIdle;
//     }
//
//     // Fallback: Try alarmClock mode
//     final can =
//         await _local
//             .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin
//             >()
//             ?.canScheduleExactNotifications() ??
//         false;
//
//     if (can) {
//       log('⚠️ Using alarmClock mode (fallback)');
//       return AndroidScheduleMode.alarmClock;
//     }
//
//     // Last resort: inexact mode (least reliable)
//     log(
//       '⚠️ Using inexactAllowWhileIdle (least accurate - may not fire on time)',
//     );
//     return AndroidScheduleMode.inexactAllowWhileIdle;
//   }
//
//   Future<void> _handleTap(Map<String, dynamic> data, AppState state) async {
//     if (_shouldIgnoreTap()) return;
//
//     _isHandlingTap = true;
//     try {
//       log('Notification tapped: $data (state: $state)');
//
//       final key = data[NotificationPayloadKey.notificationKey.value] as String?;
//       if (key == null) return;
//
//       // 1. First ensure we are on BottomBar
//       await _bringToBottomBarIfNeeded(state);
//
//       // 2. Get controller safely
//       if (!Get.isRegistered<BottombarController>()) {
//         log('BottombarController not found yet');
//         return;
//       }
//       final bottomController = Get.find<BottombarController>();
//
//       // 3. Switch tab
//       if (key == NotificationKey.shlokDaily.value) {
//         bottomController.changeTab(0);
//       } else if (key == NotificationKey.readingNudge.value) {
//         bottomController.changeTab(1);
//       } else if (key == NotificationKey.sanskritNudge.value) {
//         // For sanskrit we need context → wait until context is available
//         if (Get.context != null) {
//           bottomController.changeTab(3, context: Get.context);
//         } else {
//           // Fallback: just change tab without context (if your changeTab allows it)
//           bottomController.changeTab(3);
//         }
//       } else if (key == NotificationKey.quizNudge.value) {
//         if (!getStorageService.isUserLoggedIn) {
//           if (Get.context != null) {
//             showLoginDialog(Get.context!);
//           }
//           return;
//         }
//         if (Get.currentRoute != Routes.QUIZ_SCREEN) {
//           Get.toNamed(Routes.QUIZ_SCREEN);
//         }
//       }
//     } finally {
//       _isHandlingTap = false;
//     }
//   }
//
//   Future<void> _bringToBottomBarIfNeeded(AppState state) async {
//     if (state == AppState.kill) {
//       // For killed state we already wait in BottombarController.onReady()
//       return;
//     }
//     if (!Get.isRegistered<BottombarController>()) {
//       Get.offAllNamed(Routes.BOTTOMBAR);
//     } else if (Get.currentRoute != Routes.BOTTOMBAR) {
//       // For background: make sure we are on BOTTOMBAR route
//       // Pop everything until we reach BottomBar
//       Get.until((route) => route.settings.name == Routes.BOTTOMBAR);
//
//       // Small delay to let navigation settle
//       await Future.delayed(const Duration(milliseconds: 150));
//     }
//
//     // Extra safety: if BottombarController is not ready yet, wait a bit
//     int attempts = 0;
//     while (!Get.isRegistered<BottombarController>() && attempts < 15) {
//       await Future.delayed(const Duration(milliseconds: 100));
//       attempts++;
//     }
//   }
//
//   /// Schedule all notifications based on configuration
//   Future<void> scheduleAllNotifications() async {
//     log('📅 Scheduling all notifications...');
//
//     for (final config in NotificationConfigs.all) {
//       try {
//         await scheduleNotification(config);
//       } catch (e) {
//         log('❌ Error scheduling ${config.notificationKey.value}: $e');
//       }
//     }
//
//     log('✅ All notifications scheduled');
//   }
//
//   // ============================================
//   // 🧪 TEST MODE METHOD - REMOVE IN PRODUCTION 🧪
//   // ============================================
//   /// Schedule all notifications with short delays (1-2 minutes) for testing
//   /// This method is only called when 'testnotification' key is true
//   /// TODO: Remove this method before production release
//   Future<void> _scheduleTestNotifications() async {
//     log('🧪 TEST MODE: Scheduling notifications with 1-2 minute delays...');
//
//     for (int i = 0; i < NotificationConfigs.all.length; i++) {
//       final config = NotificationConfigs.all[i];
//       try {
//         // Check if notification is enabled
//         final isEnabled = getStorageService.getBool(
//           'notification_${config.toggleKey}',
//           defaultValue: true,
//         );
//
//         if (!isEnabled) {
//           log('⏭️ Skipping ${config.notificationKey.value} - disabled by user');
//           continue;
//         }
//
//         // Cancel existing notification
//         await _local.cancel(config.notificationId);
//
//       // Schedule for ~20 seconds from now (staggered by 2-3 seconds each)
//       final now = tz.TZDateTime.now(tz.local);
//       final delaySeconds = 20 + (i * 3); // 20s, 23s, 26s, 29s
//       final scheduled = now.add(Duration(seconds: delaySeconds));
//
//         // Get user language
//         var languageCode = getStorageService.getAppLanguage.split('_').first;
//         if (languageCode.isEmpty) {
//           final locale = Get.locale;
//           languageCode = locale?.languageCode ?? 'en';
//         }
//
//         // Get title and body
//         final title = config.getTitle(languageCode);
//         final body = config.getBody(languageCode);
//
//         if (title.isEmpty || body.isEmpty) {
//           log('⚠️ Empty title/body for ${config.notificationKey.value}');
//           continue;
//         }
//
//         log(
//           '🧪 TEST: Scheduling ${config.notificationKey.value} for ${scheduled.toLocal()} (in ${1 + i} minute(s))',
//         );
//
//         // Get best schedule mode
//         final mode = await _getBestScheduleMode();
//
//         // Create notification details
//         final channelId = _getChannelId(config.notificationKey);
//         final androidDetails = AndroidNotificationDetails(
//           channelId,
//           _getChannelName(config.notificationKey),
//           importance: Importance.high,
//           priority: Priority.high,
//           playSound: true,
//           enableVibration: true,
//         );
//         const iosDetails = DarwinNotificationDetails(
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//           interruptionLevel: InterruptionLevel.active,
//         );
//         final details = NotificationDetails(
//           android: androidDetails,
//           iOS: iosDetails,
//         );
//
//         // Create payload
//         final payload = jsonEncode({
//           NotificationPayloadKey.notificationKey.value:
//               config.notificationKey.value,
//           NotificationPayloadKey.deeplink.value: config.deeplink,
//           NotificationPayloadKey.fallbackScreen.value: config.fallbackScreen,
//           NotificationPayloadKey.analyticsEventOpen.value:
//               config.analyticsEventOpen,
//           NotificationPayloadKey.featureActivityEvent.value:
//               config.featureActivityEvent,
//         });
//
//         // Schedule test notification (one-time, no repeat)
//         await _local.zonedSchedule(
//           config.notificationId,
//           '[TEST] $title',
//           body,
//           scheduled,
//           details,
//           androidScheduleMode: mode,
//           payload: payload,
//         );
//
//         log('✅ TEST: Scheduled ${config.notificationKey.value} successfully');
//       } catch (e, s) {
//         log('❌ TEST: Error scheduling ${config.notificationKey.value}: $e');
//         log('Stack trace: $s');
//       }
//     }
//
//   log('🧪 TEST MODE: All test notifications scheduled!');
//   log('🧪 TEST MODE: Notifications will fire in ~20-30 seconds');
//   log('🧪 TEST MODE: Remember to disable test mode before production!');
// }
//
//   // ============================================
//   // END TEST MODE METHOD
//   // ============================================
//
//   /// Schedule a single notification based on config
//   Future<void> scheduleNotification(NotificationConfig config) async {
//     // Check if notification is enabled
//     final isEnabled = getStorageService.getBool(
//       'notification_${config.toggleKey}',
//       defaultValue: true, // Default to enabled
//     );
//
//     if (!isEnabled) {
//       // Cancel existing notification if disabled
//       await _local.cancel(config.notificationId);
//       log('⏭️ Cancelled ${config.notificationKey.value} - disabled by user');
//       return;
//     }
//
//     // Check activity suppression rules
//     final activityService = NotificationActivityService.instance;
//     final shouldSuppress = await activityService.shouldSuppressNotification(
//       notificationKey: config.notificationKey,
//       inactivityHours: config.inactivityHours,
//       suppressIfUsedToday: config.suppressIfUsedToday,
//       cooldownHours: config.cooldownHours,
//       maxPerDay: config.maxPerDay,
//       maxPerWeek: config.maxPerWeek,
//     );
//
//     if (shouldSuppress) {
//       log(
//         '⏭️ Skipping ${config.notificationKey.value} - suppressed by activity rules',
//       );
//       return;
//     }
//
//     try {
//       // Cancel existing notification
//       await _local.cancel(config.notificationId);
//
//       // Parse time
//       final timeParts = config.timeLocal.split(':');
//       final hour = int.parse(timeParts[0]);
//       final minute = int.parse(timeParts[1]);
//
//       // Calculate scheduled time
//       final now = tz.TZDateTime.now(tz.local);
//       tz.TZDateTime scheduled;
//
//       if (config.repeatRule == RepeatRule.daily) {
//         // Daily: schedule for today or tomorrow
//         scheduled = tz.TZDateTime(
//           tz.local,
//           now.year,
//           now.month,
//           now.day,
//           hour,
//           minute,
//         );
//         if (scheduled.isBefore(now)) {
//           scheduled = scheduled.add(const Duration(days: 1));
//         }
//       } else {
//         // Weekly: find next matching day
//         scheduled = _nextWeeklyTime(now, hour, minute, config.daysOfWeek ?? []);
//       }
//
//       // Get user language
//       var languageCode = getStorageService.getAppLanguage.split('_').first;
//       if (languageCode.isEmpty) {
//         final locale = Get.locale;
//         languageCode = locale?.languageCode ?? 'en';
//       }
//
//       // Get title and body
//       final title = config.getTitle(languageCode);
//       final body = config.getBody(languageCode);
//
//       if (title.isEmpty || body.isEmpty) {
//         log('⚠️ Empty title/body for ${config.notificationKey.value}');
//         return;
//       }
//
//       log(
//         '📅 Scheduling ${config.notificationKey.value} for ${scheduled.toLocal()}',
//       );
//
//       // Get best schedule mode
//       final mode = await _getBestScheduleMode();
//
//       // Create notification details
//       final channelId = _getChannelId(config.notificationKey);
//       final androidDetails = AndroidNotificationDetails(
//         channelId,
//         _getChannelName(config.notificationKey),
//         importance: Importance.high,
//         priority: Priority.high,
//         playSound: true,
//         enableVibration: true,
//       );
//       const iosDetails = DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//         interruptionLevel: InterruptionLevel.active,
//       );
//       final details = NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//       );
//
//       // Create payload
//       final payload = jsonEncode({
//         NotificationPayloadKey.notificationKey.value:
//             config.notificationKey.value,
//         NotificationPayloadKey.deeplink.value: config.deeplink,
//         NotificationPayloadKey.fallbackScreen.value: config.fallbackScreen,
//         NotificationPayloadKey.analyticsEventOpen.value:
//             config.analyticsEventOpen,
//         NotificationPayloadKey.featureActivityEvent.value:
//             config.featureActivityEvent,
//       });
//
//       // Schedule notification
//       if (config.repeatRule == RepeatRule.daily) {
//         await _local.zonedSchedule(
//           config.notificationId,
//           title,
//           body,
//           scheduled,
//           details,
//           androidScheduleMode: mode,
//           matchDateTimeComponents: DateTimeComponents.time,
//           payload: payload,
//         );
//       } else {
//         // Weekly: schedule for specific days
//         await _local.zonedSchedule(
//           config.notificationId,
//           title,
//           body,
//           scheduled,
//           details,
//           androidScheduleMode: mode,
//           matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
//           payload: payload,
//         );
//       }
//
//       log('✅ Scheduled ${config.notificationKey.value} successfully');
//
//       // Record that notification was scheduled
//       await activityService.recordNotificationSent(config.notificationKey);
//     } catch (e, s) {
//       log('❌ Error scheduling ${config.notificationKey.value}: $e');
//       log('Stack trace: $s');
//     }
//   }
//
//   /// Get next weekly time for specific days
//   tz.TZDateTime _nextWeeklyTime(
//     tz.TZDateTime now,
//     int hour,
//     int minute,
//     List<int> daysOfWeek,
//   ) {
//     // daysOfWeek: 1=Monday, 7=Sunday
//     // Dart DateTime.weekday: 1=Monday, 7=Sunday
//
//     var scheduled = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       hour,
//       minute,
//     );
//
//     // Find next matching day
//     for (int i = 0; i < 7; i++) {
//       final checkDate = scheduled.add(Duration(days: i));
//       if (daysOfWeek.contains(checkDate.weekday)) {
//         if (checkDate.isAfter(now)) {
//           return checkDate;
//         }
//       }
//     }
//
//     // If no match found this week, go to next week
//     scheduled = scheduled.add(const Duration(days: 7));
//     for (int i = 0; i < 7; i++) {
//       final checkDate = scheduled.add(Duration(days: i));
//       if (daysOfWeek.contains(checkDate.weekday)) {
//         return checkDate;
//       }
//     }
//
//     // Fallback (shouldn't happen)
//     return scheduled;
//   }
//
//   /// Get channel ID for notification
//   String _getChannelId(NotificationKey notificationKey) {
//     switch (notificationKey) {
//       case NotificationKey.shlokDaily:
//         return 'daily_shlok_channel';
//       case NotificationKey.readingNudge:
//         return 'reading_nudge_channel';
//       case NotificationKey.quizNudge:
//         return 'quiz_nudge_channel';
//       case NotificationKey.sanskritNudge:
//         return 'sanskrit_nudge_channel';
//     }
//   }
//
//   /// Get channel name for notification
//   String _getChannelName(NotificationKey notificationKey) {
//     switch (notificationKey) {
//       case NotificationKey.shlokDaily:
//         return 'Daily Shlok';
//       case NotificationKey.readingNudge:
//         return 'Reading Reminder';
//       case NotificationKey.quizNudge:
//         return 'Quiz Challenge';
//       case NotificationKey.sanskritNudge:
//         return 'Sanskrit Learning';
//     }
//   }
//
//   bool _shouldIgnoreTap() {
//     final now = DateTime.now();
//
//     // Prevent double taps at same time
//     if (_isHandlingTap) return true;
//
//     // Prevent quick repeated taps within 800ms
//     if (_lastTapTime != null &&
//         now.difference(_lastTapTime!).inMilliseconds < 800) {
//       return true;
//     }
//
//     _lastTapTime = now;
//     return false;
//   }
//
//   /// Enable/disable a notification type
//   Future<void> setNotificationEnabled(String toggleKey, bool enabled) async {
//     await getStorageService.setBool('notification_$toggleKey', enabled);
//
//     // Reschedule all notifications when toggles change
//     await scheduleAllNotifications();
//   }
//
//   /// Get notification enabled status
//   bool isNotificationEnabled(String toggleKey) {
//     return getStorageService.getBool(
//       'notification_$toggleKey',
//       defaultValue: true,
//     );
//   }
// }
//
// class PendingNotification {
//   static Map<String, dynamic>? payload;
//   static AppState? launchState;
//
//   static void clear() {
//     payload = null;
//     launchState = null;
//   }
//
//   static bool get hasPending => payload != null;
// }
