import 'package:flutter/material.dart';
import 'dart:math';

import '../models/product_data.dart';
import '../models/product_model.dart';

import '../components/category_menu.dart';
import '../components/banner.dart';
import '../components/banner_carousel.dart';

import '../components/deals.dart';
import '../components/featured.dart';
import '../components/products.dart';
import '../components/new_arrivals.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<List<Product>>(
        future: fetchProducts(), // Fetch products from backend
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display loading spinner while waiting for data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Display error message if fetching data fails
            return Center(child: Text('${snapshot.error}'));
          }

          final productsModel = snapshot.data!;

          // Filter products for different sections based on conditions
          final products =
              productsModel.where((product) => product.isFeatured).toList();

          final featuredProducts =
              productsModel.where((product) => product.isFeatured).toList();
          final endIndex =
              min(featuredProducts.length, 6); // Import 'dart:math';
          // Limit the featured products list to the first 6 items (or less if the list is shorter)
          final limitedFeaturedProducts = featuredProducts.sublist(0, endIndex);

          final dealsProducts =
              productsModel.where((product) => product.isSale).toList();

          final newArrivals =
              productsModel.where((product) => product.isNew).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Horizontal menu for categories
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CategoryMenu(),
              ),

              // Banner section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: BannerSection(),
              ),

              // BannerCarousel component
              const BannerCarousel(),

              // DealsSection component
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  child: DealsSection(
                    products: dealsProducts,
                  ),
                ),
              ),

              // FeaturedSection component
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: FeaturedSection(
                  featuredProducts: limitedFeaturedProducts,
                ),
              ),

              // New Arrivals Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: NewArrivalSection(
                  products: newArrivals,
                ),
              ),

              // All Products section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ProductsSection(
                  products: products,
                ),
              ),

              // Add other sections
            ],
          );
        },
      ),
    );
  }
}
