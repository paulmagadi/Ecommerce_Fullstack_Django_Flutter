import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

class PaymentScreen extends StatelessWidget {
  final double totalAmount;
  final List<Map<String, dynamic>> cartItems;
  // final Map<String, String> shippingAddress;

  PaymentScreen({
    required this.totalAmount,
    required this.cartItems,
    // required this.shippingAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay with PayPal'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            try {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => UsePaypal(
                    sandboxMode: true,
                    clientId: "AaxWzEr1TgVI5DKpnRE_AC_TlNS5phi-2eBMpTE4paGto3_iSxFjTymtidazv1HhoTkQUOAZK9Bh5m3p", // Replace with your PayPal client ID
                    secretKey: "EIztDWw-t_luY_QoSNLLCfPUgGWjHWq9K8lw4LSzhj71Z31wlUF0K_gulzU-2r0nacLPvaao5-n0fx44", // Replace with your PayPal secret key
                    returnURL: "https://samplesite.com/return",
                    cancelURL: "https://samplesite.com/cancel",
                    transactions: [
                      {
                        "amount": {
                          "total": totalAmount.toStringAsFixed(2),
                          "currency": "USD",
                          "details": {
                            "subtotal": totalAmount.toStringAsFixed(2),
                            "shipping": '0', // Optionally set actual shipping cost
                            "shipping_discount": 0
                          }
                        },
                        "description": "Order payment",
                        "item_list": {
                          "items": cartItems.map((item) {
                            return {
                              "name": item['name'],
                              "quantity": item['quantity'],
                              "price": item['price'].toStringAsFixed(2),
                              "currency": "USD"
                            };
                          }).toList(),
                          // "shipping_address": {
                          //   "recipient_name": shippingAddress['fullName'] ?? '',
                          //   "line1": shippingAddress['address1'] ?? '',
                          //   "line2": shippingAddress['address2'] ?? '',
                          //   "city": shippingAddress['city'] ?? '',
                          //   "country_code": shippingAddress['country'] ?? '',
                          //   "postal_code": shippingAddress['zipcode'] ?? '',
                          //   "phone": shippingAddress['phone'] ?? '',
                          //   "state": shippingAddress['state'] ?? ''
                          // },
                        }
                      }
                    ],
                    note: "Contact us for any questions on your order.",
                    onSuccess: (Map params) async {
                      print("onSuccess: $params");
                      // Handle successful payment here
                    },
                    onError: (error) {
                      print("onError: $error");
                      // Handle error here
                    },
                    onCancel: (params) {
                      print('cancelled: $params');
                      // Handle cancellation here
                    },
                  ),
                ),
              );
            } catch (error) {
              print('Error initiating payment: $error');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $error')),
              );
            }
          },
          child: const Text("Make Payment"),
        ),
      ),
    );
  }
}
