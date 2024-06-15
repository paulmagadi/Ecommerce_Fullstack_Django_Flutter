import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import '../config.dart'; // Ensure this contains your base URL and other config

class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  final List<Map<String, dynamic>> cartItems; // Add cart items

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

      // Step 1: Get CSRF token
      final csrfResponse = await client.get(
        Uri.parse('${Config.baseUrl}/api/get_csrf_token/'),
      );

      if (csrfResponse.statusCode == 200) {
        final responseBody = jsonDecode(csrfResponse.body);
        final csrfToken = responseBody['csrfToken'];

        if (csrfToken == null) {
          print('Failed to retrieve CSRF token.');
          return;
        }

        // Step 2: Process payment
        final postResponse = await client.post(
          Uri.parse('${Config.baseUrl}/payment/process/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'X-CSRFToken': csrfToken,
          },
          body: jsonEncode({
            'totalAmount': widget.totalAmount,
            // 'cartItems': widget.cartItems,
          }),
        );

        if (postResponse.statusCode == 200) {
          final responseData = jsonDecode(postResponse.body);
          setState(() {
            _checkoutUrl = responseData['approvalUrl'];
          });
        } else {
          throw Exception(
              'Failed to initialize payment: ${postResponse.statusCode}');
        }
      } else {
        throw Exception(
            'Failed to fetch CSRF token. Status code: ${csrfResponse.statusCode}');
      }
    } catch (e) {
      print('Error initializing payment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay with PayPal'),
      ),
      body: _checkoutUrl != null
          ? InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(_checkoutUrl!)),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                ),
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStop: (controller, url) async {
                final returnUrl = '${Config.baseUrl}/payment/execute/';
                final cancelUrl = '${Config.baseUrl}/payment/cancel/';

                if (url.toString().startsWith(returnUrl)) {
                  _handlePaymentSuccess(url.toString());
                } else if (url.toString().startsWith(cancelUrl)) {
                  Navigator.pop(context);
                }
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void _handlePaymentSuccess(String url) async {
    final uri = Uri.parse(url);
    final paymentId = uri.queryParameters['paymentId'] ?? '';
    final payerId = uri.queryParameters['PayerID'] ?? '';

    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/payment/execute/'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'paymentId': paymentId,
          'payerId': payerId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final orderId = responseData['order_id'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment Successful! Order ID: $orderId')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Failed to execute payment');
      }
    } catch (e) {
      print('Error executing payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Failed!')),
      );
    }
  }
}
