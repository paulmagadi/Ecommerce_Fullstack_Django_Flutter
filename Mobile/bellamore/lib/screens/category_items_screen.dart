import 'package:flutter/material.dart';
// import '../models/category.dart'; 
import '../models/product.dart';

class CategoryItemsScreen extends StatelessWidget {
  final Category category;

  const CategoryItemsScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: Center(
        child: Text('Items for ${category.name} will be displayed here.'),
      ),
    );
  }
}
