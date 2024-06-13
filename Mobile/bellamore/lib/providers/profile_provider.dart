import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// import '../models/profile.dart';

class Profile {
  final String user;
  final String? image;
  final String? phone;
  final String? address1;
  final String? address2;
  final String? city;
  final String? state;
  final String? zipcode;
  final String? country;

  Profile({
    required this.user,
    this.image,
    this.phone,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.zipcode,
    this.country,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      user: json['user'],
      image: json['image'] ?? 'default/pic.png',
      phone: json['phone'] ?? '',
      address1: json['address1'] ?? '',
      address2: json['address2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipcode: json['zipcode'] ?? '',
      country: json['country'] ?? '',
    );
  }
}

class ProfileProvider with ChangeNotifier {
  Profile? _profile;

  Profile? get profile => _profile;

  Future<void> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('http://10.0.2.2:8000/api/profile/1');
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
    required File? image,
    required String phone,
    required String address1,
    String? address2,
    required String city,
    required String state,
    required String zipcode,
    required String country,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('http://10.0.2.2:8000/api/profile/');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'image': image != null
            ? base64Encode(image.readAsBytesSync())
            : null, // Convert image to base64
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
      throw Exception(
          'Failed to update profile: ${errorData['message'] ?? 'Unknown error'}');
    }

    await fetchProfile();
  }
}
