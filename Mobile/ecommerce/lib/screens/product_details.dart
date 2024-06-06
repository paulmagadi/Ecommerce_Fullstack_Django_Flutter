import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the product image
            Image.network(
              product.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, color: Colors.red),
            ),

            // Display product title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),

            // Display old price and new price
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  if (product.isSale) ...[
                    // Old price if the product is on sale (struck through)
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                  ],
                  // Display the sale price
                  Text(
                    '\$${product.salePrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Display product description
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.description,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),

            // Add more sections as needed...
          ],
        ),
      ),
    );
  }
}
