import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../widgets/category_item.dart';

class CategoryView extends StatelessWidget {
  final List<Category> categories;

  const CategoryView({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return categories.isEmpty
        ? const Center(child: CircularProgressIndicator()) // Loading indicator if categories are empty
        : SingleChildScrollView(
          
            scrollDirection: Axis.horizontal, // Enable horizontal scrolling
            child: Row(
              children: categories.map((category) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10), // Spacing between items
                  child: CategoryItem(category: category),
                );
              }).toList(),
            ),
          );
  }
}
