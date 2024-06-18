import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_item.dart';
import '../models/product.dart';

class DealsScreen extends StatefulWidget {
  @override
  _DealsScreenState createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  @override
  Widget build(BuildContext context) {

    
    final productProvider = Provider.of<ProductProvider>(context);
    final List<Product> dealsProducts = productProvider.products.where((product) => product.isSale).toList();
    

    return Scaffold(
      appBar: AppBar(
        title: Text('Deals'),
      ),
      body: dealsProducts.isEmpty
          ? Center(child: Text('No deals available.'))
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 2.3 / 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: dealsProducts.length,
              itemBuilder: (ctx, index) {
                return ProductItem(product: dealsProducts[index]);
              },
            ),
    );
  }
}

