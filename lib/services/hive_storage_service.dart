import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveStorageService {
  late Box _secureBox;

  //encryption
  static const _encryptionBoxName = 'encryption_keys';
  static const _encryptionKeyField = 'secure_key';

  //common
  static const _secureBoxName = 'secure_box';
  static const _authTokenField = 'auth_token';
  static const _refreshTokenField = 'refresh_token';
  static const _userIdField = 'userId';
  static const _userData = 'userData';
  static const _tokenField =
      'token'; // use this for where auth less api need token

  Future<HiveStorageService> init() async {
    await Hive.initFlutter();

    final encryptionKey = await _getOrCreateKey();
    _secureBox = await Hive.openBox(
      _secureBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
    // Register all adapters
    registerAdapters();

    return this;
  }

  void registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      // Hive.registerAdapter(ScannedMachinesAdapter());
    }
  }

  Future<Uint8List> _getOrCreateKey() async {
    final keyBox = await Hive.openBox(_encryptionBoxName);
    if (!keyBox.containsKey(_encryptionKeyField)) {
      final key = Hive.generateSecureKey();
      await keyBox.put(_encryptionKeyField, base64UrlEncode(key));
    }
    final encodedKey = keyBox.get(_encryptionKeyField);
    return base64Url.decode(encodedKey);
  }

  Future<void> setUserId(String userId) => _secureBox.put(_userIdField, userId);

  Future<String?> get userId async => _secureBox.get(_userIdField);

  Future<void> setAuthToken(String token) =>
      _secureBox.put(_authTokenField, token);

  Future<String?> get authToken async => _secureBox.get(_authTokenField);

  Future<void> setRefreshToken(String token) =>
      _secureBox.put(_refreshTokenField, token);

  Future<String?> get refreshToken async => _secureBox.get(_refreshTokenField);

  Future<void> setToken(String token) => _secureBox.put(_tokenField, token);

  Future<String?> get token async => _secureBox.get(_tokenField);

  Future<void> deleteToken() async {
    await _secureBox.delete(_tokenField);
  }

  Future<void> clearTokens() async {
    await _secureBox.delete(_authTokenField);
    await _secureBox.delete(_refreshTokenField);
    await _secureBox.delete(_tokenField);
  }

  Future<void> clearSecureBox() async => _secureBox.clear();
}
