import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_item.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    if (productProvider.products.isEmpty) {
      // Fetch products if not already fetched
      productProvider.fetchProducts();
      return const Center(child: CircularProgressIndicator());
    }

    final products = productProvider.products;

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
        return ProductItem(product);
      },
    );
  }
}
