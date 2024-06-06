import 'package:flutter/material.dart';

// Define the FeaturedScreen widget
class NewArrivalScreen extends StatelessWidget {
  const NewArrivalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NewArrivalScreen Products'),
      ),
      body: const Center(
        // Customize the body of the deals screen as needed
        child: Text('This is the New Arrival screen'),
      ),
    );
  }
}