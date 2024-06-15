// screens/payment_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  final List<Map<String, dynamic>> cartItems;

  PaymentScreen({required this.totalAmount, required this.cartItems});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late InAppWebViewController _webViewController;
  String? _checkoutUrl;

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  Future<void> _initializePayment() async {
    try {
      final client = http.Client();

      // Get CSRF token
      final getResponse = await client.get(Uri.parse('${Config.baseUrl}/api/get_csrf_token/'));
      final csrfToken = jsonDecode(getResponse.body)['csrfToken'];

      if (csrfToken == null) {
        throw Exception('Failed to retrieve CSRF token.');
      }

      // Post payment process
      final postResponse = await client.post(
        Uri.parse('${Config.baseUrl}/payment/process/'),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': csrfToken,
        },
        body: jsonEncode({
          'totalAmount': widget.totalAmount,
          'cartItems': widget.cartItems,
        }),
      );

      if (postResponse.statusCode == 200) {
        final responseData = jsonDecode(postResponse.body);
        setState(() {
          _checkoutUrl = responseData['approvalUrl'];
        });
      } else {
        throw Exception('Failed to initialize payment: ${postResponse.statusCode}');
      }
    } catch (e) {
      print('Error initializing payment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pay with PayPal')),
      body: _checkoutUrl != null
          ? InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(_checkoutUrl!)),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  useOnLoadResource: true,
                  javaScriptEnabled: true,
                ),
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStop: (controller, url) async {
                if (url?.host == 'success-url.com') {
                  // Handle payment success
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Payment successful!')),
                  );
                } else if (url?.host == 'cancel-url.com') {
                  // Handle payment cancellation
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Payment cancelled!')),
                  );
                }
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
