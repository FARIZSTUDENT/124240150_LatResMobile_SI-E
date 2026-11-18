import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _usersKey = 'users';
  static const _loggedKey = 'logged_in_user';

  static Future<Map<String, String>> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw == null) return {};
    return Map<String, String>.from(jsonDecode(raw) as Map);
  }

  static Future<String?> register(String username, String password) async {
    username = username.trim();
    if (username.isEmpty || password.isEmpty) {
      return 'Username dan password wajib diisi.';
    }
    final users = await _loadUsers();
    if (users.containsKey(username)) {
      return 'Username sudah terdaftar.';
    }
    users[username] = password;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
    return null;
  }

  static Future<bool> login(String username, String password) async {
    username = username.trim();
    final users = await _loadUsers();
    if (users[username] == null || users[username] != password) return false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loggedKey, username);
    return true;
  }

  static Future<String?> currentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_loggedKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedKey);
  }
}
