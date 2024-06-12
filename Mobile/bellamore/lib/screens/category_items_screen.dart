import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../models/category.dart';
import '../../widgets/product_item.dart'; // Import the ProductItem widget

class CategoryItemsScreen extends StatelessWidget {
  final Category category;

  const CategoryItemsScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    // Fetch products when the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productProvider.fetchProductsByCategory(category.id);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          final categoryProducts = productProvider.products.where((product) {
            return product.category.id == category.id;
          }).toList();

          if (categoryProducts.isEmpty) {
            return const Center(child: Text('No products available in this category.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Adjust this value to change the number of columns
              childAspectRatio: 3 / 4, // Adjust to change item dimensions
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: categoryProducts.length,
            itemBuilder: (ctx, index) {
              final product = categoryProducts[index];
              return ProductItem(product: product); // Use the ProductItem widget
            },
          );
        },
      ),
    );
  }
}
