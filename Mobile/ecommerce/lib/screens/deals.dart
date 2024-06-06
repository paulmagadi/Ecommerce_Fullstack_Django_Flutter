import 'package:flutter/material.dart';

// Define a class to represent each deal
class Deal {
  final String imageUrl;
  final String title;
  final double oldPrice;
  final double newPrice;

  Deal({
    required this.imageUrl,
    required this.title,
    required this.oldPrice,
    required this.newPrice,
  });
}

class DealsScreen extends StatelessWidget {
  const DealsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deals'),
      ),
      body: const Center(
        // Customize the body of the deals screen as needed
        child: Text('This is the deals screen'),
      ),
    );
  }
}
