import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _tokenKey = 'auth_token';
  static const _roleKey = 'user_role';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async =>
      await _storage.write(key: _tokenKey, value: token);
  Future<String?> getToken() async => await _storage.read(key: _tokenKey);
  Future<void> deleteToken() async => await _storage.delete(key: _tokenKey);

  Future<void> saveRole(String role) async =>
      await _storage.write(key: _roleKey, value: role);
  Future<String?> getRole() async => await _storage.read(key: _roleKey);
  Future<void> deleteRole() async => await _storage.delete(key: _roleKey);

  Future<void> clearAll() async => await _storage.deleteAll();
}