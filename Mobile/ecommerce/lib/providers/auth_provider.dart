import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  final AuthService _authService = AuthService();

  bool get isAuthenticated => _isAuthenticated;

  Future<void> register(String email, String password, String firstName, String lastName) async {
    bool success = await _authService.register(email, password, firstName, lastName);
    if (success) {
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    bool success = await _authService.login(email, password);
    if (success) {
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getString('token') != null;
    notifyListeners();
  }
}
