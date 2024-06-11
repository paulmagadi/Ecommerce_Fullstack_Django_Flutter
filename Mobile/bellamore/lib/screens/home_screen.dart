
import 'package:bellamore/screens/home_view/product_view.dart';
import 'package:flutter/material.dart';

import '../widgets/banner_carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(children: [
          
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Categories',
              style: TextStyle(fontSize: 34),
            ),
          ]),
          // CategoryView(),
          SizedBox(height: 10,),
          BannerCarousel(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Products',
              style: TextStyle(fontSize: 34),
            ),
          ]),
          ProductsView(),
        ]),
      ),
    );
  }
}