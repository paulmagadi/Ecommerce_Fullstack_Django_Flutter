import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product_provider.dart';
import '../../widgets/product_item.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.products.isEmpty) {
          productProvider.fetchProducts();
          return const Center(child: CircularProgressIndicator());
        } else {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: GridView.builder(
              physics:
                  const NeverScrollableScrollPhysics(), // Disable GridView scrolling
              shrinkWrap: true, // Ensure GridView takes only required space
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 2.3 / 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: productProvider.products.length,
              itemBuilder: (ctx, index) {
                final product = productProvider.products[index];
                return ProductItem(product: product);
              },
            ),
          );
        }
      },
    );
  }
}
