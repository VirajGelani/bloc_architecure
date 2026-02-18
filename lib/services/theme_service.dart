import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxController {
  static const String _themeModeKey = 'themeMode';
  final GetStorage _storage = GetStorage();

  Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  ThemeService() {
    _loadThemeMode();
  }

  @override
  void onInit() {
    super.onInit();
    // Theme is already loaded in constructor, no need to load again
  }

  void _loadThemeMode() {
    try {
      final savedThemeMode = _storage.read(_themeModeKey);
      debugPrint('📖 Loading theme mode from storage: $savedThemeMode');
      if (savedThemeMode != null) {
        // Convert string to ThemeMode
        if (savedThemeMode == 'dark') {
          themeMode.value = ThemeMode.dark;
          debugPrint('✅ Loaded dark theme');
        } else if (savedThemeMode == 'light') {
          themeMode.value = ThemeMode.light;
          debugPrint('✅ Loaded light theme');
        } else {
          themeMode.value = ThemeMode.system;
          debugPrint('✅ Loaded system theme');
        }
      } else {
        // Default to light theme if no saved preference
        themeMode.value = ThemeMode.light;
        debugPrint('ℹ️ No saved theme found, defaulting to light theme');
      }
      update();
    } catch (e) {
      // If there's an error, default to light theme
      debugPrint('❌ Error loading theme mode: $e');
      themeMode.value = ThemeMode.light;
      update();
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
    await _saveThemeMode();
    update();
  }

  Future<void> _saveThemeMode() async {
    try {
      String themeModeString;
      if (themeMode.value == ThemeMode.dark) {
        themeModeString = 'dark';
      } else if (themeMode.value == ThemeMode.light) {
        themeModeString = 'light';
      } else {
        themeModeString = 'system';
      }
      // Write synchronously to ensure immediate persistence
      _storage.write(_themeModeKey, themeModeString);
      // Verify the write was successful
      final saved = _storage.read(_themeModeKey);
      if (saved == themeModeString) {
        debugPrint('✅ Theme mode saved successfully: $themeModeString');
      } else {
        debugPrint(
          '⚠️ Theme mode save verification failed. Expected: $themeModeString, Got: $saved',
        );
      }
    } catch (e) {
      debugPrint('❌ Error saving theme mode: $e');
    }
  }
}
