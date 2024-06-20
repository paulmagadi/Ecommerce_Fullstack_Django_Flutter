import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/category_provider.dart'; // Import the CategoryProvider
import '../widgets/banner_carousel.dart';
import 'home_view/category_view.dart';
import 'home_view/deals_view.dart';
import 'home_view/product_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Use MultiProvider to provide multiple providers
      providers: [
        ChangeNotifierProvider(
            create: (_) => ProductProvider()..fetchProducts()),
        ChangeNotifierProvider(
            create: (_) => CategoryProvider()
              ..fetchCategories()), // Provide CategoryProvider
      ],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<ProductProvider>(
            builder: (context, productProvider, _) {
              return Column(
                children: [
                  CategoryView(
                    categories:
                        Provider.of<CategoryProvider>(context).categories,
                  ), 

                  const SizedBox(height: 10),
                  const BannerCarousel(),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      Text(
                        'Deals',
                        style: TextStyle(fontSize: 34),
                      ),
                    ],
                  ),
                  const DealsView(),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      Text(
                        'Products',
                        style: TextStyle(fontSize: 34),
                      ),
                    ],
                  ),
                  const ProductsView(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
