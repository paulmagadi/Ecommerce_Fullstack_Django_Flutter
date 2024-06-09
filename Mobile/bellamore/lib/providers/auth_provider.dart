import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  User? get user => _user;

  Future<void> login(String email, String password) async {
    final url = Uri.parse('http:10.0.0.2:8000/api/auth/login/'); // Update with your URL
    final response = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _user = User.fromJson(data['user']);
      _isAuthenticated = true;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token']);
      notifyListeners();
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> register(String email, String password) async {
    final url = Uri.parse('http:10.0.0.2:8000/api/auth/register/'); // Update with your URL
    final response = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      await login(email, password);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<void> logout() async {
    _user = null;
    _isAuthenticated = false;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      // Fetch user info with token or set authenticated state
      _isAuthenticated = true;
      notifyListeners();
    }
  }
}
