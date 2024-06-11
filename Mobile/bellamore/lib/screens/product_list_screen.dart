// screens/product_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_item.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (ctx, i) => ProductItem(products[i]),
            ),
    );
  }
}
