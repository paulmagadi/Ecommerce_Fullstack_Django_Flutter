import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config.dart';

class PaymentService {
  // static const String baseUrl = 'http://your-django-server-url.com';

  Future<Map<String, dynamic>> initiatePayment(double totalAmount, List<Map<String, dynamic>> cartItems) async {
    final String initiatePaymentUrl = '${Config.baseUrl}/payment/process/';

    try {
      final response = await http.post(
        Uri.parse(initiatePaymentUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          // Add any other headers if needed
        },
        body: jsonEncode({
          'totalAmount': totalAmount,
          'cartItems': cartItems,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to initiate payment');
      }
    } catch (e) {
      print('Error initiating payment: $e');
      throw e;
    }
  }

  Future<void> executePayment(String paymentId, String payerId) async {
    final String executePaymentUrl = '${Config.baseUrl}/payment/execute/?paymentId=$paymentId&PayerID=$payerId';

    try {
      final response = await http.get(Uri.parse(executePaymentUrl));

      if (response.statusCode == 200) {
        print('Payment executed successfully');
      } else {
        throw Exception('Failed to execute payment');
      }
    } catch (e) {
      print('Error executing payment: $e');
      throw e;
    }
  }
}
