import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/product_provider.dart';
import '../../widgets/product_item.dart';

class DealsView extends StatelessWidget {
  const DealsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.products.isEmpty) {
          // Fetch products only if they are not already fetched
          if (!productProvider.isLoading) {
            productProvider.fetchProducts();
          }
          return const Center(child: CircularProgressIndicator());
        } else {
          final dealsProducts = productProvider.products
              .where((product) => product.isSale)
              .toList();

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
              height: 260, // Specify a fixed height for the horizontal list
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dealsProducts.length,
                itemBuilder: (ctx, index) {
                  final product = dealsProducts[index];
                  return Container(
                    width: 190, // Set a fixed width for each item
                    padding: const EdgeInsets.all(4.0),
                    child: ProductItem(product: product),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
