import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ForceUpdateService {
  static const String _androidMinVersionKey =
      'shikshapatri_minimum_app_version';
  static const String _iosMinVersionKey = 'shikshapatri_minimum_app_version';

  final FirebaseRemoteConfig _remoteConfig;

  ForceUpdateService(this._remoteConfig);

  /// Initialize and fetch remote config
  static Future<FirebaseRemoteConfig> initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: kDebugMode
            ? const Duration(minutes: 1)
            : const Duration(hours: 1),
      ),
    );

    // Set default values
    await remoteConfig.setDefaults({
      _androidMinVersionKey: '0.0.0',
      _iosMinVersionKey: '0.0.0',
    });

    try {
      await remoteConfig.fetchAndActivate();
      debugPrint('✅ Remote Config fetched and activated');
    } catch (e) {
      debugPrint('⚠️ Remote Config fetch error: $e');
      // Continue with default values
    }

    return remoteConfig;
  }

  /// Get instance of ForceUpdateService
  static ForceUpdateService getInstance() {
    return ForceUpdateService(FirebaseRemoteConfig.instance);
  }

  /// Check if force update is required
  Future<bool> isForceUpdateRequired() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final minVersion = Platform.isAndroid
          ? _remoteConfig.getString(_androidMinVersionKey)
          : _remoteConfig.getString(_iosMinVersionKey);

      debugPrint('Current app version: $currentVersion');
      debugPrint('Minimum required version: $minVersion');

      if (minVersion.isEmpty || minVersion == '0.0.0') {
        return false;
      }

      return _compareVersions(currentVersion, minVersion) < 0;
    } catch (e) {
      debugPrint('⚠️ Error checking force update: $e');
      return false;
    }
  }

  /// Compare two version strings (e.g., "1.2.3" vs "1.2.4")
  /// Returns negative if version1 < version2, 0 if equal, positive if version1 > version2
  int _compareVersions(String version1, String version2) {
    final v1Parts = version1
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();
    final v2Parts = version2
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();

    // Pad shorter version with zeros
    while (v1Parts.length < v2Parts.length) {
      v1Parts.add(0);
    }
    while (v2Parts.length < v1Parts.length) {
      v2Parts.add(0);
    }

    for (int i = 0; i < v1Parts.length; i++) {
      if (v1Parts[i] < v2Parts[i]) {
        return -1;
      } else if (v1Parts[i] > v2Parts[i]) {
        return 1;
      }
    }
    return 0;
  }
}
