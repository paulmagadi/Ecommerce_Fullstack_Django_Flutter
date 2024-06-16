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
  String? _checkoutUrl;
  bool _isLoading = true;
  String? _errorMessage;

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
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to initialize payment: ${postResponse.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error initializing payment: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pay with PayPal')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _initializePayment,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _checkoutUrl != null
                  ? InAppWebView(
                      initialUrlRequest: URLRequest(url: Uri.parse(_checkoutUrl!)),
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          useOnLoadResource: true,
                          javaScriptEnabled: true,
                        ),
                      ),
                      onWebViewCreated: (controller) {},
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
                  : Center(
                      child: Text('Unable to load payment page.'),
                    ),
    );
  }
}
