import 'package:flutter/material.dart';
import '../models/product_data.dart'; // Import the data functions 
import '../models/product_model.dart';// Import the model classes
import '../screens/product_details.dart'; // Import the product details screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home'),
      // ),
      body: FutureBuilder<List<Product>>(
        future: fetchProducts(), // Fetch data from the backend
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show an error message if data fetching fails
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final products = snapshot.data!;

            // Display the list of products
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  onTap: () {
                    // Navigate to ProductDetailsScreen when a product is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsScreen(product: product),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
