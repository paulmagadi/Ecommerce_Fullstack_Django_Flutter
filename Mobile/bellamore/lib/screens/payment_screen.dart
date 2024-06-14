import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../services/paypal_service.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late WebViewController _webViewController;
  String? _checkoutUrl;
  final String _returnUrl = 'https://your-app.com/return';
  final String _cancelUrl = 'https://your-app.com/cancel';

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  Future<void> _initializePayment() async {
    PayPalService payPalService = PayPalService(
      clientId: 'YOUR_PAYPAL_CLIENT_ID',
      secret: 'YOUR_PAYPAL_SECRET',
      returnUrl: _returnUrl,
      cancelUrl: _cancelUrl,
    );

    String? accessToken = await payPalService.getAccessToken();
    if (accessToken != null) {
      double totalAmount = 100.0; // Replace with your total amount
      var order = await payPalService.createOrder(accessToken, totalAmount);
      if (order != null) {
        setState(() {
          _checkoutUrl = order['links'].firstWhere((link) => link['rel'] == 'approve')['href'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay with PayPal'),
      ),
      body: _checkoutUrl != null
          ? WebView(
              initialUrl: _checkoutUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController = webViewController;
              },
              navigationDelegate: (NavigationRequest request) {
                if (request.url.contains(_returnUrl)) {
                  // Handle the return from PayPal
                  _handlePaymentSuccess();
                } else if (request.url.contains(_cancelUrl)) {
                  // Handle the cancellation
                  Navigator.pop(context);
                }
                return NavigationDecision.navigate;
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void _handlePaymentSuccess() {
    // Capture the order after successful payment
    PayPalService payPalService = PayPalService(
      clientId: 'YOUR_PAYPAL_CLIENT_ID',
      secret: 'YOUR_PAYPAL_SECRET',
      returnUrl: _returnUrl,
      cancelUrl: _cancelUrl,
    );

    // Replace 'order_id' with the actual order ID obtained from PayPal
    payPalService.captureOrder('ACCESS_TOKEN', 'order_id').then((order) {
      if (order != null) {
        // Handle successful payment
        print('Payment Successful: $order');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment Successful!')),
        );
        Navigator.pop(context);
      } else {
        // Handle payment failure
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment Failed!')),
        );
      }
    });
  }
}
