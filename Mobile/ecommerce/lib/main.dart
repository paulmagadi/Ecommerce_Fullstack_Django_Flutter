import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'providers/auth_provider.dart';
import 'home_page.dart';
import 'models/cart.dart';
import 'screens/static/about.dart';
import 'screens/static/contact.dart';
import 'screens/static/help.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Cart(),
      child: MaterialApp(
        title: 'Bellamore Apparels',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: const HomePage(),
        routes: {
          '/about': (context) => AboutPage(),
          '/help': (context) => HelpPage(),
          '/contact': (context) => ContactUsPage(),
        },
      ),
    );
  }
}
