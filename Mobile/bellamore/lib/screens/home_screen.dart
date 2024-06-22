import 'package:bellamore/screens/deals_screen.dart';
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
                  const SizedBox(height: 5),
                  const BannerCarousel(),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(color: Colors.orange),
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Deals',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DealsScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'See More',
                                // style: TextStyle(fontSize: 18),
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_double_arrow_right,
                              size: 16.0,
                              color: Colors.grey,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const DealsView(),
                  Container(
                    decoration: BoxDecoration(color: Colors.orange),
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Products',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ProductsScreen(),
                                //   ),
                                // );
                              },
                              child: const Text(
                                'See More',
                                // style: TextStyle(fontSize: 18),
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_double_arrow_right,
                              size: 16.0,
                              color: Colors.grey,
                            ),
                          ],
                        )
                      ],
                    ),
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
