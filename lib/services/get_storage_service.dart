import 'package:get_storage/get_storage.dart';

class GetStorageService {
  static const String isLoggedInKey = "isLoggedIn";
  static const String appLanguageKey = "appLanguage";

  final GetStorage _box;

  GetStorageService(this._box);

  bool get isUserLoggedIn => getBool(isLoggedInKey);

  String get appLanguage => getString(appLanguageKey);

  // ----------- STRING -----------

  Future<void> setString(String key, String value) async {
    try {
      await _box.write(key, value);
    } catch (e) {
      throw StorageException('Failed to save string: $e');
    }
  }

  String getString(String key, {String defaultValue = ''}) {
    try {
      return _box.read(key) ?? defaultValue;
    } catch (e) {
      throw StorageException('Failed to read string: $e');
    }
  }

  // ----------- BOOL -----------

  Future<void> setBool(String key, bool value) async {
    try {
      await _box.write(key, value);
    } catch (e) {
      throw StorageException('Failed to save bool: $e');
    }
  }

  bool getBool(String key, {bool defaultValue = false}) {
    try {
      return _box.read(key) ?? defaultValue;
    } catch (e) {
      throw StorageException('Failed to read bool: $e');
    }
  }

  // ----------- INT -----------

  Future<void> setInt(String key, int value) async {
    try {
      await _box.write(key, value);
    } catch (e) {
      throw StorageException('Failed to save int: $e');
    }
  }

  int getInt(String key, {int defaultValue = -1}) {
    try {
      return _box.read(key) ?? defaultValue;
    } catch (e) {
      throw StorageException('Failed to read int: $e');
    }
  }

  // ----------- DOUBLE -----------

  Future<void> setDouble(String key, double value) async {
    try {
      await _box.write(key, value);
    } catch (e) {
      throw StorageException('Failed to save double: $e');
    }
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    try {
      return (_box.read(key) as num?)?.toDouble() ?? defaultValue;
    } catch (e) {
      throw StorageException('Failed to read double: $e');
    }
  }

  // ----------- UTIL -----------

  bool hasData(String key) {
    return _box.hasData(key);
  }

  Future<void> remove(String key) async {
    try {
      await _box.remove(key);
    } catch (e) {
      throw StorageException('Failed to remove key: $e');
    }
  }

  Future<void> clearAllData() async {
    try {
      await _box.erase();
    } catch (e) {
      throw StorageException('Failed to clear storage: $e');
    }
  }
}

class StorageException implements Exception {
  final String message;

  StorageException(this.message);

  @override
  String toString() => 'StorageException: $message';
}
