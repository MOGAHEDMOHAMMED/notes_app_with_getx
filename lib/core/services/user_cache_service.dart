import 'package:shared_preferences/shared_preferences.dart';

class UserCacheService {
  static const String _keyUsername = 'username';
  static const String _keyEmail = 'email';

  Future<void> saveUserData(String username, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyEmail, email);
  }

  Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString(_keyUsername) ?? 'مستخدم';
    String email = prefs.getString(_keyEmail) ?? '';
    return {'name': name, 'email': email};
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyEmail);
  }
}