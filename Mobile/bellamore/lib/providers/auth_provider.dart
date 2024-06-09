import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isAuthenticated = false;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  User? get user => _user;

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
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', _token!);
      _isAuthenticated = true;
      notifyListeners();
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> register(String email, String password, String firstName, String lastName) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/auth/users/');
    final response = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      await login(email, password);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<void> logout() async {
    _user = null;
    _isAuthenticated = false;
    _token = null;
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
