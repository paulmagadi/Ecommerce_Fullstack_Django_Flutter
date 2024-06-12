import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../../widgets/category_item.dart';

class CategoryView extends StatelessWidget {
  final List<Category> categories;

  const CategoryView({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return categories.isEmpty
        ? const Center(
            child:
                CircularProgressIndicator()) // Loading indicator if categories are empty
        : GridView.builder(
            shrinkWrap: true,
            physics:
                NeverScrollableScrollPhysics(), // Prevent grid scrolling inside a ScrollView
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.8 / 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: categories.length,
            itemBuilder: (ctx, index) {
              return CategoryItem(category: categories[index]);
            },
          );
  }
}

