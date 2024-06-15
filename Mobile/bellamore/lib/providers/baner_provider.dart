// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/banner.dart';

class ApiService {
  static const String apiUrl = '${Config.baseUrl}/api/banners/';

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
