// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_paypal/flutter_paypal.dart';
// // import 'package:bellamore/providers/auth_provider.dart';
// // import 'package:provider/provider.dart';
// import 'dart:convert';
// import '../config.dart';

// class PaymentScreen extends StatelessWidget {
//   final double totalAmount;
//   final List<Map<String, dynamic>> cartItems;
//   final Map<String, dynamic> shippingAddress;
//   final int userId;

//   PaymentScreen({
//     required this.totalAmount,
//     required this.cartItems,
//     required this.shippingAddress,
//     required this.userId,
//   });

//   Future<void> createOrder(
//       BuildContext context, Map<String, dynamic> paymentDetails) async {
//     final url = Uri.parse('${Config.baseUrl}/api/create-order/');
//     // final authProvider = Provider.of<AuthProvider>(context, listen: false);

//     final orderData = {
//       'user': userId, // use userId directly
//       'full_name': shippingAddress['fullName'],
//       'email': shippingAddress['email'],
//       'amount_paid': totalAmount,
//       'shipping_address': shippingAddress,
//       'items': cartItems
//           .map((item) => {
//                 'product_id': item['productId'],
//                 'quantity': item['quantity'],
//                 'price': item['price'],
//                 'name':
//                     item['productName'], // Ensure 'productName' exists in item
//               })
//           .toList(),
//       'payment_details': paymentDetails,
//     };

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(orderData),
//       );

//       if (response.statusCode == 201) {
//         print('Order created successfully');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Order created successfully')),
//         );
//       } else {
//         print('Failed to create order: ${response.body}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to create order: ${response.body}')),
//         );
//       }
//     } catch (error) {
//       print('Error creating order: $error');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error creating order: $error')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Pay with PayPal'),
//       ),
//       body: Center(
//         child: TextButton(
//           onPressed: () async {
//             try {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (BuildContext context) => UsePaypal(
//                     sandboxMode: true,
//                     clientId:
//                         "AaxWzEr1TgVI5DKpnRE_AC_TlNS5phi-2eBMpTE4paGto3_iSxFjTymtidazv1HhoTkQUOAZK9Bh5m3p",
//                     secretKey:
//                         "EIztDWw-t_luY_QoSNLLCfPUgGWjHWq9K8lw4LSzhj71Z31wlUF0K_gulzU-2r0nacLPvaao5-n0fx44",
//                     returnURL: "https://samplesite.com/return",
//                     cancelURL: "https://samplesite.com/cancel",
//                     transactions: [
//                       {
//                         "amount": {
//                           "total": totalAmount.toStringAsFixed(2),
//                           "currency": "USD",
//                           "details": {
//                             "subtotal": totalAmount.toStringAsFixed(2),
//                             "shipping": '0',
//                             "shipping_discount": 0
//                           }
//                         },
//                         "description": "Order payment",
//                         "item_list": {
//                           "items": cartItems.map((item) {
//                             return {
//                               "name": item[
//                                   'productName'], // Ensure 'productName' exists in item
//                               "quantity": item['quantity'],
//                               "price": item['price'].toStringAsFixed(2),
//                               "currency": "USD"
//                             };
//                           }).toList(),
//                         }
//                       }
//                     ],
//                     note: "Contact us for any questions on your order.",
//                     onSuccess: (Map params) {
//                       print("onSuccess: $params");
//                       Map<String, dynamic> stringParams =
//                           params.cast<String, dynamic>();
//                       createOrder(context, stringParams);
//                     },
//                     onError: (error) {
//                       print("onError: $error");
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Payment Error: $error')),
//                       );
//                     },
//                     onCancel: (params) {
//                       print('Payment cancelled: $params');
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Payment cancelled')),
//                       );
//                     },
//                   ),
//                 ),
//               );
//             } catch (error) {
//               print('Error initiating payment: $error');
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Error: $error')),
//               );
//             }
//           },
//           child: const Text("Make Payment"),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_paypal/flutter_paypal.dart';
// import 'package:provider/provider.dart';
// import 'dart:convert';
// import '../config.dart';
// import '../providers/shipping_address_provider.dart';

// class PaymentScreen extends StatelessWidget {
//   final double totalAmount;
//   final List<Map<String, dynamic>> cartItems;
//   final int userId;

//   PaymentScreen({
//     required this.totalAmount,
//     required this.cartItems,
//     required this.userId,
//   });

//   Future<void> createOrder(BuildContext context, Map<String, dynamic> paymentDetails) async {
//     final url = Uri.parse('${Config.baseUrl}/api/create-order/');

//     final shippingAddressProvider = Provider.of<ShippingAddressProvider>(context, listen: false);

//     final shippingAddresss = shippingAddressProvider.shippingAddress;

//     final orderData = {
//       'user': userId,
//       'full_name': shippingAddresss?.fullName,
//       'email': shippingAddresss?.email,
//       'amount_paid': totalAmount,
//       'shipping_address': shippingAddresss?.address1,
//       'items': cartItems
//           .map((item) => {
//                 'product_id': item['productId'],
//                 'quantity': item['quantity'],
//                 'price': item['price'],
//                 'name': item['productName'],
//               })
//           .toList(),
//       'payment_details': paymentDetails,
//     };

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(orderData),
//       );

//       if (response.statusCode == 201) {
//         print('Order created successfully');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Order created successfully')),
//         );
//       } else {
//         print('Failed to create order: ${response.body}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to create order: ${response.body}')),
//         );
//       }
//     } catch (error) {
//       print('Error creating order: $error');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error creating order: $error')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {

//     final shippingAddressProvider = Provider.of<ShippingAddressProvider>(context);
//     final shippingAddresss = shippingAddressProvider.shippingAddress;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Pay with PayPal'),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             // Order Details Card
//             Card(
//               margin: const EdgeInsets.all(16.0),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Order Details',
//                       style: TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8.0),
//                     // Text('Full Name: ${shippingAddress['fullName']}'),
//                     // Text('Email: ${shippingAddress['email']}'),
//                     // Text('Shipping Address: ${shippingAddress['address']}'),

//                     Text('Full Name: ${shippingAddresss?.fullName ?? 'N/A'}'),
//                       Text('Email: ${shippingAddresss?.email ?? 'N/A'}'),
//                       Text(
//                           'Shipping Address: ${shippingAddresss?.address1 ?? 'N/A'}, ${shippingAddresss?.city ?? 'N/A'}, ${shippingAddresss?.state ?? 'N/A'}, ${shippingAddresss?.zipcode ?? 'N/A'}, ${shippingAddresss?.country ?? 'N/A'}'),
//                     const SizedBox(height: 8.0),
//                     const Text(
//                       'Items:',
//                       style: TextStyle(
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     for (var item in cartItems)
//                       Text(
//                           '${item['productName']} x${item['quantity']} - \$${item['price']}'),
//                     const Divider(),
//                     Text(
//                       'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
//                       style: const TextStyle(
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20.0),
//             // Payment Button
//             TextButton(
//               onPressed: () async {
//                 try {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (BuildContext context) => UsePaypal(
//                         sandboxMode: true,
//                         clientId: "AaxWzEr1TgVI5DKpnRE_AC_TlNS5phi-2eBMpTE4paGto3_iSxFjTymtidazv1HhoTkQUOAZK9Bh5m3p",
//                         secretKey: "EIztDWw-t_luY_QoSNLLCfPUgGWjHWq9K8lw4LSzhj71Z31wlUF0K_gulzU-2r0nacLPvaao5-n0fx44",
//                         returnURL: "https://samplesite.com/return",
//                         cancelURL: "https://samplesite.com/cancel",
//                         transactions: [
//                           {
//                             "amount": {
//                               "total": totalAmount.toStringAsFixed(2),
//                               "currency": "USD",
//                               "details": {
//                                 "subtotal": totalAmount.toStringAsFixed(2),
//                                 "shipping": '0',
//                                 "shipping_discount": 0
//                               }
//                             },
//                             "description": "Order payment",
//                             "item_list": {
//                               "items": cartItems.map((item) {
//                                 return {
//                                   "name": item['productName'],
//                                   "quantity": item['quantity'],
//                                   "price": item['price'].toStringAsFixed(2),
//                                   "currency": "USD"
//                                 };
//                               }).toList(),
//                             }
//                           }
//                         ],
//                         note: "Contact us for any questions on your order.",
//                         onSuccess: (Map params) {
//                           print("onSuccess: $params");
//                           Map<String, dynamic> stringParams =
//                               params.cast<String, dynamic>();
//                           createOrder(context, stringParams);
//                         },
//                         onError: (error) {
//                           print("onError: $error");
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Payment Error: $error')),
//                           );
//                         },
//                         onCancel: (params) {
//                           print('Payment cancelled: $params');
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Payment cancelled')),
//                           );
//                         },
//                       ),
//                     ),
//                   );
//                 } catch (error) {
//                   print('Error initiating payment: $error');
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Error: $error')),
//                   );
//                 }
//               },
//               child: const Text("Make Payment"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_paypal/flutter_paypal.dart';
// import 'package:provider/provider.dart';
// import 'dart:convert';
// import '../config.dart';
// import '../providers/shipping_address_provider.dart';

// class PaymentScreen extends StatelessWidget {
//   final double totalAmount;
//   final List<Map<String, dynamic>> cartItems;
//   final int userId;

//   PaymentScreen({
//     required this.totalAmount,
//     required this.cartItems,
//     required this.userId,
//   });

//   Future<void> createOrder(
//       BuildContext context, Map<String, dynamic> paymentDetails) async {
//     final url = Uri.parse('${Config.baseUrl}/api/create-order/');
//     final shippingAddressProvider =
//         Provider.of<ShippingAddressProvider>(context, listen: false);

//     final shippingAddress = shippingAddressProvider.shippingAddress;

//     if (shippingAddress == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Shipping address is not available')),
//       );
//       return;
//     }

//     final orderData = {
//       'user': userId,
//       'full_name': shippingAddress.address1,
//       'email': shippingAddress.email ,
//       'amount_paid': totalAmount,
//       // 'shipping_address': '${shippingAddress.address1}, ${shippingAddress.city}, ${shippingAddress.state}, ${shippingAddress.zipcode }, ${shippingAddress.country}',
//       'shipping_address': shippingAddress.address1,
//       'items': cartItems
//           .map((item) => {
//                 'product_id': item['productId'],
//                 'quantity': item['quantity'],
//                 'price': item['price'],
//                 'name': item['productName'],
//               })
//           .toList(),
//       'payment_details': paymentDetails,
//     };

//     try {
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(orderData),
//       );

//       if (response.statusCode == 201) {
//         print('Order created successfully');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Order created successfully')),
//         );
//       } else {
//         print('Failed to create order: ${response.body}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to create order: ${response.body}')),
//         );
//       }
//     } catch (error) {
//       print('Error creating order: $error');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error creating order: $error')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final shippingAddressProvider =
//         Provider.of<ShippingAddressProvider>(context);
//     final shippingAddress = shippingAddressProvider.shippingAddress;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Pay with PayPal'),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             if (shippingAddress != null)
//               Card(
//                 margin: const EdgeInsets.all(16.0),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Order Details',
//                         style: TextStyle(
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 8.0),
//                       Text('Full Name: ${shippingAddress.fullName ?? 'N/A'}'),
//                       Text('Email: ${shippingAddress.email ?? 'N/A'}'),
//                       Text(
//                           'Shipping Address: ${shippingAddress.address1 ?? 'N/A'}, ${shippingAddress.city ?? 'N/A'}, ${shippingAddress.state ?? 'N/A'}, ${shippingAddress.zipcode ?? 'N/A'}, ${shippingAddress.country ?? 'N/A'}'),
//                       const SizedBox(height: 8.0),
//                       const Text(
//                         'Items:',
//                         style: TextStyle(
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       for (var item in cartItems)
//                         Text(
//                             '${item['productName']} x${item['quantity']} - \$${item['price']}'),
//                       const Divider(),
//                       Text(
//                         'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
//                         style: const TextStyle(
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 20.0),
//             TextButton(
//               onPressed: () async {
//                 try {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (BuildContext context) => UsePaypal(
//                         sandboxMode: true,
//                         clientId:
//                             "AaxWzEr1TgVI5DKpnRE_AC_TlNS5phi-2eBMpTE4paGto3_iSxFjTymtidazv1HhoTkQUOAZK9Bh5m3p",
//                         secretKey:
//                             "EIztDWw-t_luY_QoSNLLCfPUgGWjHWq9K8lw4LSzhj71Z31wlUF0K_gulzU-2r0nacLPvaao5-n0fx44",
//                         returnURL: "https://samplesite.com/return",
//                         cancelURL: "https://samplesite.com/cancel",
//                         transactions: [
//                           {
//                             "amount": {
//                               "total": totalAmount.toStringAsFixed(2),
//                               "currency": "USD",
//                               "details": {
//                                 "subtotal": totalAmount.toStringAsFixed(2),
//                                 "shipping": '0',
//                                 "shipping_discount": 0
//                               }
//                             },
//                             "description": "Order payment",
//                             "item_list": {
//                               "items": cartItems.map((item) {
//                                 return {
//                                   "name": item['productName'],
//                                   "quantity": item['quantity'],
//                                   "price": item['price'].toStringAsFixed(2),
//                                   "currency": "USD"
//                                 };
//                               }).toList(),
//                             }
//                           }
//                         ],
//                         note: "Contact us for any questions on your order.",
//                         onSuccess: (Map params) {
//                           print("onSuccess: $params");
//                           Map<String, dynamic> stringParams =
//                               params.cast<String, dynamic>();
//                           createOrder(context, stringParams);
//                         },
//                         onError: (error) {
//                           print("onError: $error");
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Payment Error: $error')),
//                           );
//                         },
//                         onCancel: (params) {
//                           print('Payment cancelled: $params');
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Payment cancelled')),
//                           );
//                         },
//                       ),
//                     ),
//                   );
//                 } catch (error) {
//                   print('Error initiating payment: $error');
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Error: $error')),
//                   );
//                 }
//               },
//               child: const Text("Make Payment"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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

  Future<void> createOrder(
      BuildContext context, Map<String, dynamic> paymentDetails) async {
    final url = Uri.parse('${Config.baseUrl}/api/create-order/');

    // final shipping =
    //     '${shippingAddress['address1']}, ${shippingAddress['address2']}, ${shippingAddress['city']}, ${shippingAddress['state']} ${shippingAddress['zipcode']}, ${shippingAddress['country']}';

//     String shipping = '''
// ${shippingAddress['phone']}
// ${shippingAddress['address1']}
// ${shippingAddress['address2']}
// ${shippingAddress['city']}
// ${shippingAddress['state']}
// ${shippingAddress['zipcode']}
// ${shippingAddress['country']}
// ''';

    final shipping = '${shippingAddress['phone']}\n'
        '${shippingAddress['address1']}\n'
        '${shippingAddress['address2']}\n'
        '${shippingAddress['city']}\n'
        '${shippingAddress['state']}\n'
        '${shippingAddress['zipcode']}\n'
        '${shippingAddress['country']}';

    // String jsonData = jsonEncode(payload);

    final orderData = {
      'user': userId,
      'full_name': shippingAddress['full_name'],
      'email': shippingAddress['email'],
      'amount_paid': totalAmount,
      'shipping_address': shipping,
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
        print('Order created successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order created successfully')),
        );
      } else {
        print('Failed to create order: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create order: ${response.body}')),
        );
      }
    } catch (error) {
      print('Error creating order: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating order: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final shipping =
        '${shippingAddress['phone']}, ${shippingAddress['address1']}, ${shippingAddress['address2']}, ${shippingAddress['city']}, ${shippingAddress['state']} ${shippingAddress['zipcode']}, ${shippingAddress['country']}';

    // Using triple quotes
//     String shipping = '''
// ${shippingAddress['phone']}
// ${shippingAddress['address1']}
// ${shippingAddress['address2']}
// ${shippingAddress['city']}
// ${shippingAddress['state']}
// ${shippingAddress['zipcode']}
// ${shippingAddress['country']}
// ''';

    // Using interpolation and \n
    // String address2 =
    //   '${shipping['phone']}\n'
    //   '${shipping['shipping_address1']}\n'
    //   '${shipping['shipping_address2']}\n'
    //   '${shipping['city']}\n'
    //   '${shipping['state']}\n'
    //   '${shipping['zipcode']}\n'
    //   '${shipping['country']}';

    // Using List and join
    // String address3 = [
    //   shipping['phone'],
    //   shipping['shipping_address1'],
    //   shipping['shipping_address2'],
    //   shipping['city'],
    //   shipping['state'],
    //   shipping['zipcode'],
    //   shipping['country']
    // ].join('\n');

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
                    Text('Shipping Address: ${shipping}'),
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
                          print("onSuccess: $params");
                          Map<String, dynamic> stringParams =
                              params.cast<String, dynamic>();
                          createOrder(context, stringParams);
                        },
                        onError: (error) {
                          print("onError: $error");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Payment Error: $error')),
                          );
                        },
                        onCancel: (params) {
                          print('Payment cancelled: $params');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Payment cancelled')),
                          );
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
          ],
        ),
      ),
    );
  }
}
