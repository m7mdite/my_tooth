import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const String _tokenKey = 'auth_token';
  static const String _roleKey = 'user_role';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // ✅ دالة للتحقق من المنصة
  bool get shouldUseSecureStorage => !kIsWeb && !Platform.isWindows;

  Future<void> saveToken(String token) async {
    if (shouldUseSecureStorage) {
      await _storage.write(key: _tokenKey, value: token);
    }
  }

  Future<String?> getToken() async {
    if (shouldUseSecureStorage) {
      return await _storage.read(key: _tokenKey);
    }
    return null;
  }

  Future<void> deleteToken() async {
    if (shouldUseSecureStorage) {
      await _storage.delete(key: _tokenKey);
    }
  }

  Future<void> saveRole(String role) async {
    if (shouldUseSecureStorage) {
      await _storage.write(key: _roleKey, value: role);
    }
  }

  Future<String?> getRole() async {
    if (shouldUseSecureStorage) {
      return await _storage.read(key: _roleKey);
    }
    return null;
  }

  Future<void> deleteRole() async {
    if (shouldUseSecureStorage) {
      await _storage.delete(key: _roleKey);
    }
  }

  Future<void> clearAll() async {
    if (shouldUseSecureStorage) {
      await _storage.deleteAll();
    }
  }
}