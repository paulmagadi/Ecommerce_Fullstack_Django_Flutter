import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../services/paypal_service.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;

  PaymentScreen({required this.totalAmount});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _checkoutUrl;
  final String _returnUrl = 'https://your-app.com/return';
  final String _cancelUrl = 'https://your-app.com/cancel';
  String _accessToken = '';

  @override
  void initState() {
    super.initState();
    _initializePayment();

    // Enable virtual display for the WebView
    // WebView.platform = SurfaceAndroidWebView();
  }

  Future<void> _initializePayment() async {
    PayPalService payPalService = PayPalService(
      clientId: 'AaxWzEr1TgVI5DKpnRE_AC_TlNS5phi-2eBMpTE4paGto3_iSxFjTymtidazv1HhoTkQUOAZK9Bh5m3p',
      secret: 'EIztDWw-t_luY_QoSNLLCfPUgGWjHWq9K8lw4LSzhj71Z31wlUF0K_gulzU-2r0nacLPvaao5-n0fx44',
      mode: 'sandbox',
      returnUrl: _returnUrl,
      cancelUrl: _cancelUrl,
    );

    String? accessToken = await payPalService.getAccessToken();
    if (accessToken != null) {
      setState(() {
        _accessToken = accessToken;
      });
      var order = await payPalService.createOrder(accessToken, widget.totalAmount);
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
                // No need to store the webViewController if it's not used
              },
              navigationDelegate: (NavigationRequest request) {
                if (request.url.contains(_returnUrl)) {
                  _handlePaymentSuccess();
                } else if (request.url.contains(_cancelUrl)) {
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

  void _handlePaymentSuccess() async {
    PayPalService payPalService = PayPalService(
      clientId: 'AaxWzEr1TgVI5DKpnRE_AC_TlNS5phi-2eBMpTE4paGto3_iSxFjTymtidazv1HhoTkQUOAZK9Bh5m3p',
      secret: 'EIztDWw-t_luY_QoSNLLCfPUgGWjHWq9K8lw4LSzhj71Z31wlUF0K_gulzU-2r0nacLPvaao5-n0fx44',
      mode: 'sandbox',
      returnUrl: _returnUrl,
      cancelUrl: _cancelUrl,
    );

    var order = await payPalService.captureOrder(_accessToken, 'order_id');
    if (order != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment Successful!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment Failed!')),
      );
    }
  }
}
