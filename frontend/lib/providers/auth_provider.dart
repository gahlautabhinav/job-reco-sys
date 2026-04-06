import 'package:flutter/foundation.dart';
import '../data/repositories/auth_repository.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo;

  AuthProvider(this._repo);

  AuthStatus _status = AuthStatus.unknown;
  String? _username;
  bool _isLoading = false;

  AuthStatus get status => _status;
  String? get username => _username;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /// Call once on startup to restore session.
  Future<void> initialize() async {
    final saved = await _repo.getLoggedInUser();
    if (saved != null) {
      _username = saved;
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  /// Returns null on success, error message on failure.
  Future<String?> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    final error = await _repo.login(username, password);
    if (error == null) {
      _username = username.trim().toLowerCase();
      _status = AuthStatus.authenticated;
    }
    _isLoading = false;
    notifyListeners();
    return error;
  }

  /// Returns null on success, error message on failure.
  Future<String?> register(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    final error = await _repo.register(username, password);
    if (error == null) {
      _username = username.trim().toLowerCase();
      _status = AuthStatus.authenticated;
    }
    _isLoading = false;
    notifyListeners();
    return error;
  }

  Future<void> logout() async {
    await _repo.logout();
    _username = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
