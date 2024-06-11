import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/profile_provider.dart';
import 'screens/home_page.dart';
import 'screens/login_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/profile_info_form.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'screens/static/about.dart';
import 'screens/static/contact.dart';
import 'screens/static/help.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
         ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bellamore',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/profile_form': (context) => ProfileFormScreen(),
        '/profile': (context) => ProfileScreen(),
        '/home': (context) => HomePage(),
        '/about': (context) => AboutPage(),
        '/help': (context) => HelpPage(),
        '/contact': (context) => ContactUsPage(),
        '/product_list': (context) => ProductListScreen(),

        
        
      },
    );
  }
}
