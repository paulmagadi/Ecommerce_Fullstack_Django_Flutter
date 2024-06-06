import 'package:flutter/material.dart';

class DealsScreen extends StatelessWidget {
  const DealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: 
    SingleChildScrollView(
      child: Row(
        children: [
          Text('Deals')
        ],
      ),
    ));
  }
}