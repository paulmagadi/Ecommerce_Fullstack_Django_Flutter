import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

class PayPalService {
  final String clientId;
  final String secret;
  final String mode; // 'sandbox' or 'live'
  final String returnUrl;
  final String cancelUrl;

  PayPalService({
    required this.clientId,
    required this.secret,
    required this.mode,
    required this.returnUrl,
    required this.cancelUrl,
  });

  String get baseUrl => mode == 'sandbox'
      ? 'https://api-m.sandbox.paypal.com'
      : 'https://api-m.paypal.com';

  Future<String?> getAccessToken() async {
    final response = await http.post(
      Uri.parse('$baseUrl/v1/oauth2/token'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$secret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      print('Failed to get access token: ${response.body}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> createOrder(String accessToken, double total) async {
    final response = await http.post(
      Uri.parse('$baseUrl/v2/checkout/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "intent": "CAPTURE",
        "purchase_units": [
          {
            "amount": {
              "currency_code": "USD",
              "value": total.toStringAsFixed(2),
            },
          },
        ],
        "application_context": {
          "return_url": returnUrl,
          "cancel_url": cancelUrl,
        },
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print('Failed to create order: ${response.body}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> captureOrder(String accessToken, String orderId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/v2/checkout/orders/$orderId/capture'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print('Failed to capture order: ${response.body}');
      return null;
    }
  }
}
