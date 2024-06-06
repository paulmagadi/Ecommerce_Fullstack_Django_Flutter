import 'package:flutter/material.dart';
import '../screens/featured.dart';
import '../screens/product_details.dart';
import '../models/product_model.dart';

// Define maximum length for product name
const int maxNameLength = 20;

class FeaturedSection extends StatelessWidget {
  final List<Product> featuredProducts;

  const FeaturedSection({Key? key, required this.featuredProducts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Section title
                Text(
                  'Featured Products',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                // "See More" button
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FeaturedScreen(),
                      ),
                    );
                  },
                  child: const Text('See More'),
                ),
              ],
            ),
          ),
          // Grid view of featured products
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  3, // Adjust number of columns for different screen sizes
              childAspectRatio: 2 / 3, // Adjust aspect ratio for better layout
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
            ),
            itemCount: featuredProducts.length,
            itemBuilder: (context, index) {
              final product = featuredProducts[index];
              return FeaturedProductItem(product: product);
            },
          ),
        ],
      ),
    );
  }
}

class FeaturedProductItem extends StatelessWidget {
  final Product product;

  const FeaturedProductItem({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Truncate product name if it exceeds the maximum length
    String truncatedName = product.name.length > maxNameLength
        ? '${product.name.substring(0, maxNameLength)}...'
        : product.name;

    return GestureDetector(
      onTap: () {
        // Navigate to ProductDetailsScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error, color: Colors.red),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            // Product details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display truncated product title
                  Text(
                    truncatedName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4.0),
                  // Display old and new prices if on sale, otherwise regular price
                  if (product.isSale) ...[
                    Row(
                      children: [
                        // Old price (struck through)
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        // New price (highlighted)
                        Text(
                          '\$${product.salePrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Display regular price if not on sale
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
