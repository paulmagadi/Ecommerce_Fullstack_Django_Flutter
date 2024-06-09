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
    final url = Uri.parse('http://10.0.0.1:8000/api/auth/login/');
    final response = await http.post(
      url,
      body: json.encode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _user = User.fromJson(data['user']);
      _token = data['token'];
      _isAuthenticated = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      notifyListeners();
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<void> register(String email, String password) async {
    final url = Uri.parse('http://10.0.0.1:8000/api/auth/register/');
    final response = await http.post(
      url,
      body: json.encode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      await login(email, password);
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  Future<void> logout() async {
    _user = null;
    _isAuthenticated = false;
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (_token != null) {
      // Optionally, verify the token or fetch user data with it
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<http.Response> authenticatedRequest(String method, Uri url, {dynamic body}) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    switch (method.toUpperCase()) {
      case 'POST':
        return http.post(url, headers: headers, body: json.encode(body));
      case 'GET':
        return http.get(url, headers: headers);
      case 'PUT':
        return http.put(url, headers: headers, body: json.encode(body));
      case 'DELETE':
        return http.delete(url, headers: headers);
      default:
        throw Exception('Unsupported HTTP method');
    }
  }
}
