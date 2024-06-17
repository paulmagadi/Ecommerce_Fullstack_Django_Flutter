import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config.dart';

class OrderProvider {

  Future<void> createOrder({
    required int userId,
    required String fullName,
    required String email,
    required double amountPaid,
    required Map<String, dynamic> shippingAddress,
    required List<Map<String, dynamic>> items,
  }) async {
    final url = Uri.parse('${Config.baseUrl}/api/create_order/');

    final body = jsonEncode({
      'user_id': userId,
      'full_name': fullName,
      'email': email,
      'amount_paid': amountPaid,
      'shipping_address': shippingAddress,
      'items': items,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      print('Order created successfully: ${responseData['order_id']}');
    } else {
      print('Failed to create order: ${response.statusCode} - ${response.body}');
    }
  }
}
