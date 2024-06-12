import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../models/category.dart';
import '../../models/product.dart';

class CategoryItemsScreen extends StatelessWidget {
  final Category category;

  const CategoryItemsScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          List<Product> categoryProducts = productProvider.products.where((product) {
            return product.category.id == category.id;
          }).toList();

          if (categoryProducts.isEmpty) {
            return const Center(child: Text('No products available in this category.'));
          }

          return ListView.builder(
            itemCount: categoryProducts.length,
            itemBuilder: (context, index) {
              final product = categoryProducts[index];
              return ListTile(
                leading: Image.network(
                  product.profileImage,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(product.name),
                subtitle: Text('${product.price.toStringAsFixed(2)} \$'),
                onTap: () {
                  // Navigate to the Product Detail Screen if needed
                },
              );
            },
          );
        },
      ),
    );
  }
}
