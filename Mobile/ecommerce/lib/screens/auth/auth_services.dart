import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthServices {
  static const String baseUrl = 'http://10.0.2.2:8000/api/csrf/';

  static Future<String?> fetchCsrfToken() async {
    final response = await http.get(Uri.parse('${baseUrl}csrf/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['csrfToken'];
    } else {
      return null;
    }
  }

  static Future<http.Response> login(String email, String password, String csrfToken) async {
    final response = await http.post(
      Uri.parse('${baseUrl}login/'),
      headers: {
        'Content-Type': 'application/json',
        'X-CSRFToken': csrfToken,
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    return response;
  }
}
