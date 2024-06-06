import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white, //set Text and icon colors to white
        title: const Text('Help'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'How to Use This App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('1. To register click Register.\n'
                '2. To Login click Login.\n'),
            const SizedBox(height: 16),
            const Text(
              'FAQs',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Q: Do you have a store?\nA: Yes we have a store.\n\n',
            ),
            const SizedBox(height: 16),
            const Text(
              'Contact Support',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Text(
            //   'If you need further assistance, please contact us at:\n'
            //   'support@taskmaster.com',
            // ),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                      text:
                          "If you need further assistance, please contact us at:\n",
                      style: TextStyle()),
                  TextSpan(
                      text: "support@taskmaster.com",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



