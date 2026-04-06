import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database_service.dart';

class AuthRepository {
  final DatabaseService _db;
  static const _prefKey = 'logged_in_user';

  AuthRepository(this._db);

  String _hash(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  /// Returns null on success, or an error message string.
  Future<String?> register(String username, String password) async {
    if (username.trim().isEmpty) return 'Username is required';
    if (password.length < 6) return 'Password must be at least 6 characters';

    final ok = await _db.createUser(username, _hash(password));
    if (!ok) return 'Username already taken';

    await _persist(username.trim().toLowerCase());
    return null;
  }

  /// Returns null on success, or an error message string.
  Future<String?> login(String username, String password) async {
    if (username.trim().isEmpty) return 'Username is required';
    if (password.isEmpty) return 'Password is required';

    final stored = await _db.getUserPasswordHash(username);
    if (stored == null) return 'No account found for that username';
    if (stored != _hash(password)) return 'Incorrect password';

    await _persist(username.trim().toLowerCase());
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKey);
  }

  Future<String?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefKey);
  }

  Future<void> _persist(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, username);
  }
}
