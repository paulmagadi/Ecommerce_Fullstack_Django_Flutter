import 'package:flutter/material.dart';
// import '../screens/products.dart';
import '../models/product_model.dart';

// // Define a class to represent each product
// class AllProduct {
//   final String imageUrl;
//   final String title;
//   final double price;
//   final double salePrice;
//   final bool isSale;

//   AllProduct(
//       {required this.imageUrl,
//       required this.title,
//       required this.price,
//       required this.salePrice,
//       required this.isSale});
// }

class ProductsSection extends StatelessWidget {
  final List<Product> products;

  const ProductsSection(
      {Key? key, required this.products})
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
                  'Products',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                // "See More" button
              ],
            ),
          ),

          // Grid view of products
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
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return AllProductItem(product: product);
            },
          ),
        ],
      ),
    );
  }
}

// Define a custom widget for each product item
class AllProductItem extends StatelessWidget {
  final Product product;

  const AllProductItem({super.key, required this.product});
  // const AllProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
              product.image, // Use Image.network for remote images
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Error handling for failed image loading
                return const Icon(Icons.error, color: Colors.red);
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  // Display a CircularProgressIndicator while the image is loading
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
                // Product title
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    // Displaying prices
                    if (product.isSale) ...[
                      // If the product is on sale, display the old price (struck through)
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),

                      const SizedBox(
                          width:
                              4.0), // Add a small gap between old and new price

                      // Display the sale price
                      Text(
                        '\$${product.salePrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ] else ...[
                      // If the product is not on sale, display only the regular price
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
