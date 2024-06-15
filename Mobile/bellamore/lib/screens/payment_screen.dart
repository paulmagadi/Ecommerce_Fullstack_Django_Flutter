import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
// import 'package:cookie_jar/cookie_jar.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;

  PaymentScreen({required this.totalAmount});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // ignore: unused_field
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

      // Step 1: Make a GET request to get the CSRF token.
      final getResponse = await client.get(
        Uri.parse('${Config.baseUrl}/api/get_csrf_token/'),
      );

      if (getResponse.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(getResponse.body);
        final csrfToken = responseBody['csrfToken'];

        if (csrfToken == null) {
          print('Failed to retrieve CSRF token.');
          return;
        }

        // Step 2: Make a POST request with the CSRF token.
        final postResponse = await client.post(
          Uri.parse('${Config.baseUrl}/payment/process/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'X-CSRFToken': csrfToken,
          },
          body: jsonEncode(<String, dynamic>{
            'totalAmount': widget.totalAmount,
          }),
        );

        if (postResponse.statusCode == 200) {
          final Map<String, dynamic> responseData =
              jsonDecode(postResponse.body);
          setState(() {
            _checkoutUrl = responseData['approvalUrl'];
          });
        } else {
          throw Exception(
              'Failed to initialize payment: ${postResponse.statusCode}');
        }
      } else {
        throw Exception(
            'Failed to fetch CSRF token. Status code: ${getResponse.statusCode}');
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
    try {
      final response = await http.post(
        Uri.parse(
            '$url?paymentId=payment_id&PayerID=payer_id'), // Update with actual parameters
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'paymentId': 'payment_id', // Replace with actual paymentId
          'PayerID': 'payer_id', // Replace with actual PayerID
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment Successful!')),
        );
        Navigator.pop(
            context); // Navigate back to the previous screen after success
      } else {
        throw Exception('Failed to execute payment');
      }
    } catch (e) {
      print('Error executing payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment Failed!')),
      );
    }
  }
}
