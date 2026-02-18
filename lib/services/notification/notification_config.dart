// import 'package:shikshapatri/app/core/constants/enums.dart';
// import 'package:shikshapatri/app/services/notification/notification_localization_helper.dart';
// import 'package:shikshapatri/l10n/app_localizations.dart';
//
// /// Notification configuration model based on spreadsheet requirements
// class NotificationConfig {
//   final NotificationKey notificationKey;
//   final String toggleKey;
//   final String timeLocal; // Format: "HH:mm"
//   final RepeatRule repeatRule;
//   final List<int>? daysOfWeek; // 1=Monday, 7=Sunday, null for DAILY
//   final int inactivityHours;
//   final bool suppressIfUsedToday;
//   final List<String Function(AppLocalizations)> titleGetters;
//   final List<String Function(AppLocalizations)> bodyGetters;
//   final String deeplink;
//   final String fallbackScreen;
//   final int cooldownHours;
//   final int maxPerDay;
//   final int maxPerWeek;
//   final int ttlHours;
//   final String analyticsEventOpen;
//   final String featureActivityEvent;
//   final int notificationId;
//
//   NotificationConfig({
//     required this.notificationKey,
//     required this.toggleKey,
//     required this.timeLocal,
//     required this.repeatRule,
//     this.daysOfWeek,
//     required this.inactivityHours,
//     required this.suppressIfUsedToday,
//     required this.titleGetters,
//     required this.bodyGetters,
//     required this.deeplink,
//     required this.fallbackScreen,
//     required this.cooldownHours,
//     required this.maxPerDay,
//     required this.maxPerWeek,
//     required this.ttlHours,
//     required this.analyticsEventOpen,
//     required this.featureActivityEvent,
//     required this.notificationId,
//   });
//
//   /// Get random title based on language using localization
//   String getTitle(String languageCode) {
//     if (titleGetters.isEmpty) return '';
//     final index = DateTime.now().millisecondsSinceEpoch % titleGetters.length;
//     return NotificationLocalizationHelper.getLocalizedString(
//       languageCode,
//       titleGetters[index],
//     );
//   }
//
//   /// Get random body based on language using localization
//   String getBody(String languageCode) {
//     if (bodyGetters.isEmpty) return '';
//     final index = DateTime.now().millisecondsSinceEpoch % bodyGetters.length;
//     return NotificationLocalizationHelper.getLocalizedString(
//       languageCode,
//       bodyGetters[index],
//     );
//   }
// }
//
// enum RepeatRule { daily, weekly }
//
// /// Predefined notification configurations from spreadsheet
// class NotificationConfigs {
//   static final shlokDaily = NotificationConfig(
//     notificationKey: NotificationKey.shlokDaily,
//     toggleKey: 'shlok_of_the_day',
//     timeLocal: '7:30',
//     repeatRule: RepeatRule.daily,
//     inactivityHours: 20,
//     suppressIfUsedToday: true,
//     titleGetters: [
//       (l) => l.notif_shlok_daily_title_1,
//       (l) => l.notif_shlok_daily_title_2,
//       (l) => l.notif_shlok_daily_title_3,
//     ],
//     bodyGetters: [
//       (l) => l.notif_shlok_daily_body_1,
//       (l) => l.notif_shlok_daily_body_2,
//       (l) => l.notif_shlok_daily_body_3,
//     ],
//     deeplink: 'app://shlok/daily',
//     fallbackScreen: 'app://home',
//     cooldownHours: 18,
//     maxPerDay: 1,
//     maxPerWeek: 7,
//     ttlHours: 12,
//     analyticsEventOpen: 'notif_open_shlok_daily',
//     featureActivityEvent: 'shlok_opened',
//     notificationId: 101,
//   );
//
//   static final readingNudge = NotificationConfig(
//     notificationKey: NotificationKey.readingNudge,
//     toggleKey: 'continue_reading_journey',
//     timeLocal: '20:15',
//     repeatRule: RepeatRule.weekly,
//     inactivityHours: 48,
//     suppressIfUsedToday: true,
//     titleGetters: [
//       (l) => l.notif_reading_nudge_title_1,
//       (l) => l.notif_reading_nudge_title_2,
//       (l) => l.notif_reading_nudge_title_3,
//     ],
//     bodyGetters: [
//       (l) => l.notif_reading_nudge_body_1,
//       (l) => l.notif_reading_nudge_body_2,
//       (l) => l.notif_reading_nudge_body_3,
//     ],
//     deeplink: 'app://reading/home',
//     fallbackScreen: 'app://home',
//     cooldownHours: 24,
//     maxPerDay: 1,
//     maxPerWeek: 3,
//     ttlHours: 4,
//     analyticsEventOpen: 'notif_open_reading_nudge',
//     featureActivityEvent: 'reading_opened',
//     notificationId: 102,
//   );
//
//   static final quizNudge = NotificationConfig(
//     notificationKey: NotificationKey.quizNudge,
//     toggleKey: 'continue_try_quiz',
//     timeLocal: '18:45',
//     repeatRule: RepeatRule.weekly,
//     daysOfWeek: [2, 4, 6], // Tuesday, Thursday, Saturday
//     inactivityHours: 48,
//     suppressIfUsedToday: true,
//     titleGetters: [
//       (l) => l.notif_quiz_nudge_title_1,
//       (l) => l.notif_quiz_nudge_title_2,
//       (l) => l.notif_quiz_nudge_title_3,
//     ],
//     bodyGetters: [
//       (l) => l.notif_quiz_nudge_body_1,
//       (l) => l.notif_quiz_nudge_body_2,
//       (l) => l.notif_quiz_nudge_body_3,
//     ],
//     deeplink: 'app://quiz/home',
//     fallbackScreen: 'app://home',
//     cooldownHours: 48,
//     maxPerDay: 1,
//     maxPerWeek: 2,
//     ttlHours: 5,
//     analyticsEventOpen: 'notif_open_quiz_nudge',
//     featureActivityEvent: 'quiz_opened',
//     notificationId: 103,
//   );
//
//   static final sanskritNudge = NotificationConfig(
//     notificationKey: NotificationKey.sanskritNudge,
//     toggleKey: 'sanskrit_learning_journey',
//     timeLocal: '19:00',
//     repeatRule: RepeatRule.weekly,
//     daysOfWeek: [1, 3, 5], // Monday, Wednesday, Friday
//     inactivityHours: 48,
//     suppressIfUsedToday: true,
//     titleGetters: [
//       (l) => l.notif_sanskrit_nudge_title_1,
//       (l) => l.notif_sanskrit_nudge_title_2,
//       (l) => l.notif_sanskrit_nudge_title_3,
//     ],
//     bodyGetters: [
//       (l) => l.notif_sanskrit_nudge_body_1,
//       (l) => l.notif_sanskrit_nudge_body_2,
//       (l) => l.notif_sanskrit_nudge_body_3,
//     ],
//     deeplink: 'app://sanskrit/home',
//     fallbackScreen: 'app://home',
//     cooldownHours: 22,
//     maxPerDay: 1,
//     maxPerWeek: 3,
//     ttlHours: 5,
//     analyticsEventOpen: 'notif_open_sanskrit_nudge',
//     featureActivityEvent: 'sanskrit_opened',
//     notificationId: 104,
//   );
//
//   static List<NotificationConfig> get all => [
//     shlokDaily,
//     readingNudge,
//     quizNudge,
//     sanskritNudge,
//   ];
// }
