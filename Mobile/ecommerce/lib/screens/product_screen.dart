import 'package:flutter/material.dart';
import '../models/data.dart';
import '../widgets/product_item.dart';


class ProductsScreen extends StatelessWidget {
  final String categoryId;
  final String categoryTitle;

  ProductsScreen({
    required this.categoryId,
    required this.categoryTitle,
  });

  @override
  Widget build(BuildContext context) {
    final categoryProducts = DUMMY_PRODUCTS.where((prod) {
      return prod.categoryId == categoryId;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: GridView.builder(
        // padding: const EdgeInsets.all(15),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: categoryProducts.length,
        itemBuilder: (ctx, index) {
          return ProductItem(
            id: categoryProducts[index].id,
            title: categoryProducts[index].title,
            imageUrl: categoryProducts[index].imageUrl,
            price: categoryProducts[index].price,
          );
        },
      ),
    );
  }
}
