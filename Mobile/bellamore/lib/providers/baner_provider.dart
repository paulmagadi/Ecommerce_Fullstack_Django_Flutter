// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/banner.dart';

class ApiService {
  static const String apiUrl = 'http://10.0.2.2:8000/api/banners/';

  Future<List<MobileBanner>> fetchBanners() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => MobileBanner.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load banners');
    }
  }
}
