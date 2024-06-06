import 'package:flutter/material.dart';
import 'package:myapp/screens/category.dart';

import '../components/home/banner_carousel.dart';
import 'product_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(children: [
          
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Categories',
              style: TextStyle(fontSize: 34),
            ),
          ]),
          CategoryView(),
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
