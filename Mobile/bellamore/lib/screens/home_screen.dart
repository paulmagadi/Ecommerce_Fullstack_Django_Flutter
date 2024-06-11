import 'package:bellamore/screens/home_view/product_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../widgets/banner_carousel.dart';
import 'home_view/category_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductProvider()..fetchProducts(), 
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Categories',
                    style: TextStyle(fontSize: 34),
                  ),
                ],
              ),
              const CategoryView(), 

              const SizedBox(height: 10),
              BannerCarousel(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Products',
                    style: TextStyle(fontSize: 34),
                  ),
                ],
              ),
              const ProductsView(), 
            ],
          ),
        ),
      ),
    );
  }
}
