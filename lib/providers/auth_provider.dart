import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  AuthStatus _status = AuthStatus.unknown;
  UserModel? _user;
  String? _error;
  bool _loading = false;

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get error => _error;
  bool get loading => _loading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    _service.authStateChanges.listen((firebaseUser) async {
      if (firebaseUser == null) {
        _status = AuthStatus.unauthenticated;
        _user = null;
      } else {
        _user = await _service.getCurrentUserModel();
        _status = AuthStatus.authenticated;
      }
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    _loading = true; _error = null; notifyListeners();
    try {
      _user = await _service.signIn(email, password);
      _status = AuthStatus.authenticated;
      return true;
    } catch (e) {
      _error = _friendlyError(e.toString());
      return false;
    } finally {
      _loading = false; notifyListeners();
    }
  }

  Future<bool> signUp({
    required String name, required String email, required String password,
    required String department, required String semester, required String phone,
  }) async {
    _loading = true; _error = null; notifyListeners();
    try {
      _user = await _service.signUp(
        name: name, email: email, password: password,
        department: department, semester: semester, phone: phone,
      );
      _status = AuthStatus.authenticated;
      return true;
    } catch (e) {
      _error = _friendlyError(e.toString());
      return false;
    } finally {
      _loading = false; notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _service.signOut();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> sendPasswordReset(String email) async {
    try {
      await _service.sendPasswordReset(email);
      return true;
    } catch (_) {
      return false;
    }
  }

  void clearError() { _error = null; notifyListeners(); }

  String _friendlyError(String raw) {
    if (raw.contains('wrong-password') || raw.contains('invalid-credential')) {
      return 'Incorrect email or password.';
    }
    if (raw.contains('user-not-found')) return 'No account found with this email.';
    if (raw.contains('email-already-in-use')) return 'An account already exists with this email.';
    if (raw.contains('weak-password')) return 'Password must be at least 6 characters.';
    if (raw.contains('network')) return 'Network error. Check your connection.';
    return 'Something went wrong. Please try again.';
  }
}
