// widgets/product_item.dart
import 'package:flutter/material.dart';

import '../models/product.dart';


class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(
        product.imageUrl,
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black87,
        title: Text(
          product.name,
          textAlign: TextAlign.center,
        ),
        subtitle: Text('\$${product.price.toString()}'),
        
      ),
    );
  }
}
