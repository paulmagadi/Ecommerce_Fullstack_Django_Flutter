import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/profile.dart';

class ProfileProvider with ChangeNotifier {
  Profile? _profile;

  Profile? get profile => _profile;

  Future<void> fetchProfile(String token) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/profile/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _profile = Profile.fromJson(data);
      notifyListeners();
    } else {
      throw Exception('Failed to fetch profile');
    }
  }

  Future<void> updateProfile({
    required String token,
    required File? image,
    required String phone,
    required String address1,
    String? address2,
    required String city,
    required String state,
    required String zipcode,
    required String country,
  }) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/profile/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'image': image != null
            ? base64Encode(image.readAsBytesSync())
            : null,
        'phone': phone,
        'address1': address1,
        'address2': address2 ?? '',
        'city': city,
        'state': state,
        'zipcode': zipcode,
        'country': country,
      }),
    );

    if (response.statusCode != 200) {
      final errorData = json.decode(response.body);
      throw Exception('Failed to update profile: ${errorData['message'] ?? 'Unknown error'}');
    }

    await fetchProfile(token);
  }
}
