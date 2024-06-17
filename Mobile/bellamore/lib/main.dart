import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/shipping_address_provider.dart';
import 'screens/home_page.dart';
import 'screens/login_screen.dart';
// import 'screens/product_list_screen.dart';
import 'screens/profile_info_form.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'screens/shipping_address_form_screen.dart';
import 'screens/static/about.dart';
import 'screens/static/contact.dart';
import 'screens/static/help.dart';

// child: Text('Base URL: ${dotenv.env['BASE_URL']}'),

void main() async {
  // await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ShippingAddressProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
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
        '/shipping_address_form': (context) => ShippingAddressForm(),
        '/profile': (context) => ProfileScreen(),
        '/home': (context) => HomePage(),
        '/about': (context) => AboutPage(),
        '/help': (context) => HelpPage(),
        '/contact': (context) => ContactUsPage(),
        // '/product_list': (context) => ProductListScreen(),
      },
    );
  }
}
