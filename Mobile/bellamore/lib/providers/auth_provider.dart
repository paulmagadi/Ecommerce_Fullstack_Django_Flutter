import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String email, String password) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/auth/jwt/create/');
    final response = await http.post(
      url,
      body: json.encode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _token = data['access'];
      _isAuthenticated = true;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', _token!);
      notifyListeners();
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> register(String email, String password) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/auth/users/');
    final response = await http.post(
      url,
      body: json.encode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      await login(email, password);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<void> logout() async {
    _token = null;
    _isAuthenticated = false;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (_token != null) {
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
