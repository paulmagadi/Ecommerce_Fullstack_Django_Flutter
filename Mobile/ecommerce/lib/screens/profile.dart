import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: 
    SingleChildScrollView(
      child: Row(
        children: [
          Text('Account')
        ],
      ),
    ));
  }
}




