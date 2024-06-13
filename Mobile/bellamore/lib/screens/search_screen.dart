// search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../widgets/product_item.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];

  void _searchProducts() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final query = _searchController.text.toLowerCase();

    setState(() {
      _searchResults = productProvider.products.where((product) {
        return product.name.toLowerCase().contains(query) ||
            product.keyWords!.toLowerCase().contains(query) ||
            product.material!.toLowerCase().contains(query) ||
            product.color!.toLowerCase().contains(query) ||
            product.brand!.toLowerCase().contains(query) ||
            product.category.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search products...',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: _searchProducts,
            ),
          ),
          onSubmitted: (value) => _searchProducts(),
        ),
      ),
      body: _searchResults.isEmpty
          ? Center(child: Text('No products found.'))
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 2.3 / 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: _searchResults.length,
              itemBuilder: (ctx, index) {
                final product = _searchResults[index];
                return ProductItem(product: product);
              },
            ),
    );
  }
}
