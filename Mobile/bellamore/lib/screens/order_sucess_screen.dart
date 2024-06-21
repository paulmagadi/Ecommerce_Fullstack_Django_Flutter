import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatelessWidget {
  // final double totalAmount;
  // final List<Map<String, dynamic>> orderedItems;
  // final Map<String, dynamic> shippingAddress;

  // OrderSuccessScreen({
  //   required this.totalAmount,
  //   required this.orderedItems,
  //   required this.shippingAddress,
  // });

  @override
  Widget build(BuildContext context) {
    // final formattedShippingAddress =
    //     '${shippingAddress['phone']}, ${shippingAddress['address1']}, '
    //     '${shippingAddress['address2']}, ${shippingAddress['city']}, '
    //     '${shippingAddress['state']} ${shippingAddress['zipcode']}, ${shippingAddress['country']}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Success'),
        automaticallyImplyLeading: false, // Prevents back navigation
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thank you for your purchase!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Your order has been placed successfully.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                    context); // Navigate back to the main screen or home
              },
              child: Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }
}
