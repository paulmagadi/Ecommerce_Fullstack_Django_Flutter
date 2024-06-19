import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';

class ShippingAddress {
  final int id;
  final int user;
  final String? phone;
  final String? fullName;
  final String? email;
  final String? address1;
  final String? address2;
  final String? city;
  final String? state;
  final String? zipcode;
  final String? country;

  ShippingAddress({
    required this.id,
    required this.user,
    this.phone,
    this.fullName,
    this.email,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.zipcode,
    this.country,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id'],
      user: json['user'],
      phone: json['phone'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      address1: json['address1'] ?? '',
      address2: json['address2'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipcode: json['zipcode'] ?? '',
      country: json['country'] ?? '',
    );
  }

  toMap() {}
}

class ShippingAddressProvider with ChangeNotifier {
  ShippingAddress? _shippingAddress;

  ShippingAddress? get shippingAddress => _shippingAddress;

  Future<void> fetchShippingAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');

    if (token == null || userId == null) {
      throw Exception('No token or user ID found');
    }

    final url = Uri.parse('${Config.baseUrl}/api/shipping-address/$userId/');
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
      throw Exception('Failed to fetch shipping address');
    }
  }

  Future<void> updateShippingAddress({
    required int user,
    String? phone,
    String? fullName,
    String? email,
    String? address1,
    String? address2,
    String? city,
    String? state,
    String? zipcode,
    String? country,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found');
    }

    final url = Uri.parse('${Config.baseUrl}/api/shipping-address/$user/');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'phone': phone,
        'full_name': fullName,
        'email': email,
        'address1': address1,
        'address2': address2,
        'city': city,
        'state': state,
        'zipcode': zipcode,
        'country': country,
      }),
    );

    if (response.statusCode == 200) {
      await fetchShippingAddress(); // Refresh shipping address data
    } else {
      final errorData = json.decode(response.body);
      throw Exception('Failed to update shipping address: $errorData');
    }
  }
}
