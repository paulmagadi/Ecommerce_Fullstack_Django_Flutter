import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isAuthenticated = false;
  String? _token;
  int? _userId; 
  String? _userName;
  String? _userEmail;

  bool get isAuthenticated => _isAuthenticated;
  User? get user => _user;
  int? get userId => _userId; 
  String? get userName => _userName;
  String? get userEmail => _userEmail;

  Future<void> login(String email, String password) async {
    // final url = Uri.parse('http://10.0.2.2:8000/api/auth/jwt/create/');
    final url = Uri.parse('${Config.baseUrl}/api/auth/jwt/create/');
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

      // Fetch user details
      await _fetchUserDetails();

      _isAuthenticated = true;
      notifyListeners();
    } else {
      throw Exception('Failed to login. Error: ${response.body}');
    }
  }

  Future<void> register(String email, String password1, String password2, String firstName, String lastName) async {
    final url = Uri.parse('${Config.baseUrl}/api/auth/users/');
    final response = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password1': password1,
        'password2': password2,
        'first_name': firstName,
        'last_name': lastName,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      await login(email, password1);
    } else {
      throw Exception('Failed to register. Error: ${response.body}');
    }
  }

  Future<void> _fetchUserDetails() async {
    final url = Uri.parse('${Config.baseUrl}/api/auth/users/me/');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _user = User.fromJson(data);
      _userId = _user?.id; 
      _userName = '${_user?.firstName} ${_user?.lastName}';
      _userEmail = _user?.email;
      _saveUserInfoToPrefs();
    } else {
      throw Exception('Failed to fetch user details. Error: ${response.body}');
    }
  }

  Future<void> _saveUserInfoToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', _userName ?? '');
    prefs.setString('userEmail', _userEmail ?? '');
    prefs.setInt('userId', _userId ?? 0); 
  }

  Future<void> _loadUserInfoFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName');
    _userEmail = prefs.getString('userEmail');
    _userId = prefs.getInt('userId'); 
  }

  Future<void> logout() async {
    _user = null;
    _isAuthenticated = false;
    _token = null;
    _userId = null; 
    _userName = null;
    _userEmail = null;

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userName');
    prefs.remove('userEmail');
    prefs.remove('userId'); 
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _userId = prefs.getInt('userId'); 
    if (_token != null && _userId != null) { 
      _isAuthenticated = true;
      await _loadUserInfoFromPrefs();
      notifyListeners();
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<int?> getUserId() async { 
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
}
