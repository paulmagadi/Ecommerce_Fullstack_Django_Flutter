import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_paypal/flutter_paypal.dart';
import 'dart:convert';

import '../config.dart';

class PaymentScreen extends StatelessWidget {
  final double totalAmount;
  final List<Map<String, dynamic>> cartItems;
  final Map<String, dynamic> shippingAddress;
  final int userId;

  PaymentScreen({
    required this.totalAmount,
    required this.cartItems,
    required this.shippingAddress,
    required this.userId,
  });




  Future<void> createOrder(Map<String, dynamic> paymentDetails) async {
    const url = '${Config.baseUrl}/api/create-order/';

    final orderData = {
      'user_id': userId,
      'full_name': shippingAddress['fullName'],
      'email': shippingAddress['email'],
      'amount_paid': totalAmount,
      'shipping_address': shippingAddress,
      'items': cartItems
          .map((item) => {
                'product_id': item['product_id'],
                'quantity': item['quantity'],
                'price': item['price']
              })
          .toList(),
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 201) {
      print('Order created successfully');
    } else {
      print('Failed to create order: ${response.body}');
    }
  }

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
                    clientId:
                        "AaxWzEr1TgVI5DKpnRE_AC_TlNS5phi-2eBMpTE4paGto3_iSxFjTymtidazv1HhoTkQUOAZK9Bh5m3p",
                    secretKey:
                        "EIztDWw-t_luY_QoSNLLCfPUgGWjHWq9K8lw4LSzhj71Z31wlUF0K_gulzU-2r0nacLPvaao5-n0fx44",
                    returnURL: "https://samplesite.com/return",
                    cancelURL: "https://samplesite.com/cancel",
                    transactions: [
                      {
                        "amount": {
                          "total": totalAmount.toStringAsFixed(2),
                          "currency": "USD",
                          "details": {
                            "subtotal": totalAmount.toStringAsFixed(2),
                            "shipping": '0',
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
                          //   // "country_code": shippingAddress['country'] ?? '',
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

                      // Cast params to Map<String, dynamic>
                      Map<String, dynamic> stringParams =
                          params.cast<String, dynamic>();

                      await createOrder(stringParams);
                    },
                    onError: (error) {
                      print("onError: $error");
                    },
                    onCancel: (params) {
                      print('cancelled: $params');
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
