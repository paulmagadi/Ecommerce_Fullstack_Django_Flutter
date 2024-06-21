import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_paypal/flutter_paypal.dart';
import 'dart:convert';
import '../config.dart';
import 'order_sucess_screen.dart';

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

  Future<void> createOrder(
      BuildContext context, Map<String, dynamic> paymentDetails) async {
    final url = Uri.parse('${Config.baseUrl}/api/create-order/');

    final formattedShippingAddress = '${shippingAddress['phone']}\n'
        '${shippingAddress['address1']}\n'
        '${shippingAddress['address2']}\n'
        '${shippingAddress['city']}\n'
        '${shippingAddress['state']}\n'
        '${shippingAddress['zipcode']}\n'
        '${shippingAddress['country']}';

    final orderData = {
      'user': userId,
      'full_name': shippingAddress['full_name'],
      'email': shippingAddress['email'],
      'amount_paid': totalAmount,
      'shipping_address': formattedShippingAddress,
      'items': cartItems
          .map((item) => {
                'product_id': item['productId'],
                'quantity': item['quantity'],
                'price': item['price'],
                'name': item['productName'],
              })
          .toList(),
      'payment_details': paymentDetails,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order created successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create order: ${response.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating order: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedShippingAddress =
        '${shippingAddress['phone']}, ${shippingAddress['address1']}, '
        '${shippingAddress['address2']}, ${shippingAddress['city']}, '
        '${shippingAddress['state']} ${shippingAddress['zipcode']}, ${shippingAddress['country']}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay with PayPal'),
      ),
      body: Center(
        child: Column(
          children: [
            // Order Details Card
            Card(
              margin: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ship to:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text('Full Name: ${shippingAddress['full_name'] ?? 'N/A'}'),
                    Text('Email: ${shippingAddress['email'] ?? 'N/A'}'),
                    const Text(
                      'Shipping Address:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      formattedShippingAddress,
                      style: TextStyle(fontSize: 14.0),
                      maxLines:
                          null, // Ensures the text can have multiple lines
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Items:',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    for (var item in cartItems)
                      Text(
                          '${item['productName']} x${item['quantity']} - \$${item['price']}'),
                    const Divider(),
                    Text(
                      'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // Payment Button
            TextButton(
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
                                  "name": item['productName'],
                                  "quantity": item['quantity'],
                                  "price": item['price'].toStringAsFixed(2),
                                  "currency": "USD"
                                };
                              }).toList(),
                            }
                          }
                        ],
                        note: "Contact us for any questions on your order.",
                        onSuccess: (Map params) {
                          Map<String, dynamic> stringParams =
                              params.cast<String, dynamic>();
                          createOrder(context, stringParams);

                          // Navigate to the Order Success Screen
                          // Navigator.of(context).pop(
                          //   MaterialPageRoute(
                          //     builder: (context) => OrderSuccessScreen(),
                          //   ),
                          // );
                        },
                        onError: (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Payment Error: $error')),
                          );
                        },
                        onCancel: (params) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Payment cancelled')),
                          );
                        },
                      ),
                    ),
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                }
              },
              child: const Text("Make Payment"),
            ),
          ],
        ),
      ),
    );
  }
}
