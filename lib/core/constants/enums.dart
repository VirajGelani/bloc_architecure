enum ValidationType {
  email,
  phone,
  password,
  confirmPassword,
  currentPassword,
  newPassword,
  companyName,
  city,
  pinCode,
  address,
  userName,
  fullName,
  country,
  issueNote,
}

enum PlatformType {
  android('Android'),
  ios('IOS');

  final String value;

  const PlatformType(this.value);
}

enum FolderType {
  documents('documents'),
  feedbacks('feedbacks');

  final String value;

  const FolderType(this.value);
}

enum LoginType {
  email('email'),
  google('google'),
  apple('apple');

  final String value;

  const LoginType(this.value);
}

enum Collection {
  users('shikshapatri_users'),
  sanskritLearnings('sanskrit_learnings'),
  agnaShloks('agna_shloks'),
  agnaProgressHistory('agna_progress_history'),
  quizzes('quizzes'),
  bookmarkItems('bookmarkItems'),
  bookmarks('bookmarks'),
  notes('notes'),
  readShloks('read_shloks'),
  feedbacks('feedback');

  final String name;

  const Collection(this.name);
}

enum LanguageType {
  english('en', 'US'),
  hindi('hi', 'IN'),
  gujarati('gu', 'IN');

  final String langCode;
  final String countryCode;

  const LanguageType(this.langCode, this.countryCode);
}

enum NotificationPayloadKey {
  notificationKey('notification_key'),
  deeplink('deeplink'),
  fallbackScreen('fallback_screen'),
  analyticsEventOpen('analytics_event_open'),
  featureActivityEvent('feature_activity_event');

  final String value;

  const NotificationPayloadKey(this.value);
}

enum AppState { foreground, background, kill }
