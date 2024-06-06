import 'package:ecommerce/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar_with_label/curved_navigation_bar.dart';
// import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/services.dart';

// import 'package:badges/badges.dart' as badges;

import './screens/home.dart';
import './screens/category.dart';
import './screens/deals.dart';
import './screens/cart.dart';
import './screens/account.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      // systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      // systemNavigationBarIconBrightness: Brightness.light,
    ));
    return MaterialApp(
      title: 'Bellamore',
      theme: ThemeData(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const CategoryScreen(),
    const DealsScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        titleTextStyle: const TextStyle(fontSize: 40, color: blackColor),
        backgroundColor: whiteColor,
        foregroundColor: blackColor,
        // leading: const Image(
        //   image: AssetImage("assets/images/bellamore.png"),
        //   height: 40,
        // ),
        title: const Text('Bellamore'),
      ),
      body: _pages[_selectedIndex],
      // backgroundColor: bgColor,
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          CurvedNavigationBarItem(icon: const Icon(Icons.home), label: "Home"),
          CurvedNavigationBarItem(
              icon: const Icon(Icons.category), label: "Category"),
          CurvedNavigationBarItem(icon: const Icon(Icons.home), label: "Deals"),
          CurvedNavigationBarItem(
              icon: const Icon(Icons.shopping_cart), label: "Cart"),
          CurvedNavigationBarItem(
              icon: const Icon(Icons.person), label: "Account"),
        ],
        onTap: (index) {
          // Update the state when an item is tapped
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
