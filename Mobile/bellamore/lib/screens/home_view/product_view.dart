import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_item.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    return FutureBuilder<List<Product>>(
      future: productProvider.fetchProductsFuture(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading spinner
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle error
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Handle empty data
          return const Center(child: Text('No products available.'));
        }

        // Data is available
        final products = snapshot.data!;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1.7 / 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemCount: products.length,
          itemBuilder: (ctx, index) {
            final product = products[index];
            return ProductItem(product: product);
          },
        );
      },
    );
  }
}
