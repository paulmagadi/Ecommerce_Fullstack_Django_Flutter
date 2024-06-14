import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShippingAddress {
  final int user;
  final String? phone;
  final String? address1;
  final String? address2;
  final String? city;
  final String? state;
  final String? zipcode;
  final String? country;

  ShippingAddress({
    required this.user,
    this.phone,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.zipcode,
    this.country,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      user: json['user'],
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

class ShippingAddressProvider with ChangeNotifier {
  ShippingAddress? _shippingAddress;

  ShippingAddress? get profile => _shippingAddress;

  Future<void> fetchShippingAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');

    if (token == null || userId == null) {
      throw Exception('No token or user ID found');
    }

    final url = Uri.parse('http://10.0.2.2:8000/api/shipping-address/$userId/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _shippingAddress = ShippingAddress.fromJson(data);
      notifyListeners();
    } else {
      throw Exception('Failed to fetch profile');
    }
  }

  Future<void> updateProfile({
    String? phone,
    String? address1,
    String? address2,
    String? city,
    String? state,
    String? zipcode,
    String? country,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');

    if (token == null || userId == null) {
      throw Exception('No token or user ID found');
    }

    final url = Uri.parse('http://10.0.2.2:8000/api/shipping-address/$userId/');
    final request = http.MultipartRequest('PUT', url);
    request.headers['Authorization'] = 'Bearer $token';

    if (phone != null) request.fields['phone'] = phone;
    if (address1 != null) request.fields['address1'] = address1;
    if (address2 != null) request.fields['address2'] = address2;
    if (city != null) request.fields['city'] = city;
    if (state != null) request.fields['state'] = state;
    if (zipcode != null) request.fields['zipcode'] = zipcode;
    if (country != null) request.fields['country'] = country;

   

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        await fetchShippingAddress(); 
      } else {
        final errorData = await response.stream.bytesToString();
        throw Exception('Failed to update profile: $errorData');
      }
    } catch (error) {
      throw Exception('Failed to update profile: $error');
    }
  }
}
