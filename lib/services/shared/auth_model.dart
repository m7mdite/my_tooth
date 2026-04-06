import 'package:shared_preferences/shared_preferences.dart';

class AuthModel {
  String? _token;
  String? id;
  String? email;
  String? role;

  
  

  
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    _token = token;
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    if (_token == null) {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
    }
    return _token;
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _token = null;
  }

  Future<void> saveId(String id) async {
    final prefs = await SharedPreferences.getInstance();

    id = id;
    await prefs.setString('id', id);
  }

  Future<String?> getId() async {
    if (id == null) {
      final prefs = await SharedPreferences.getInstance();
      id = prefs.getString('id');
    }
    return id;
  }

  Future<void> saveEmail(String e) async {
    final prefs = await SharedPreferences.getInstance();
    email = e;
    await prefs.setString('email', e);
  }

  Future<String?> getEmail() async {
    if (email == null) {
      final prefs = await SharedPreferences.getInstance();
      email = prefs.getString('email');
    }
    return email;
  }
  Future<void> saveRole(String r) async {
    final prefs = await SharedPreferences.getInstance();
    role = r;
    await prefs.setString('role', r);
  }

  Future<String?> getRole() async {
    if (role == null) {
      final prefs = await SharedPreferences.getInstance();
      role = prefs.getString('role');
    }
    return role;
  }
}
