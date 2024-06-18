import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_item.dart';
import '../models/product.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';

  void _searchProducts() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final results = await productProvider.searchProducts(_searchController.text);
      setState(() {
        _searchResults = results;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Error searching products: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty && _errorMessage.isEmpty
              ? Center(child: Text('No products found.'))
              : _errorMessage.isNotEmpty
                  ? Center(child: Text(_errorMessage))
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
