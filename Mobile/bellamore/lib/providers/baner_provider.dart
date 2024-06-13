// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/banner.dart';

class ApiService {
  final String apiUrl = 'http://10.0.2.2:8000/api/mobile-banners/';

  Future<List<MobileBanner>> fetchBanners() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((banner) => MobileBanner.fromJson(banner)).toList();
    } else {
      throw Exception('Failed to load banners');
    }
  }
}
