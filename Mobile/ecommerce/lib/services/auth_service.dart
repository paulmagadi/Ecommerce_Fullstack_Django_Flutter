import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_api_service.dart';

class AuthService {
  final ApiService apiService = ApiService();

  Future<bool> register(String email, String password, String firstName, String lastName) async {
    final response = await apiService.postRequest('users/', {
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
    });

    return response.statusCode == 201;
  }

  Future<bool> login(String email, String password) async {
    final response = await apiService.postRequest('jwt/create/', {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      String token = data['access'];
      await apiService.storeToken(token);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
