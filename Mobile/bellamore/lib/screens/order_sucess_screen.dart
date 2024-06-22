import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentSuccessScreen extends StatelessWidget {
  final String paymentToken;

  PaymentSuccessScreen({required this.paymentToken});

  Future<void> verifyPayment(BuildContext context) async {
    final url = Uri.parse('https://yourapp.com/verify-payment');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'paymentToken': paymentToken}),
    );

    if (response.statusCode == 200) {
      // Payment verified successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment verified successfully!')),
      );
      // Proceed with order processing
    } else {
      // Verification failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment verification failed: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Success'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => verifyPayment(context),
          child: Text('Verify Payment'),
        ),
      ),
    );
  }
}
