import 'package:flutter/material.dart';
// import '../../models/product.dart';
import '../../models/category.dart';
import '../../widgets/category_item.dart';

class CategoryView extends StatelessWidget {
  final List<Category> categories;

  const CategoryView({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,  // Number of columns in the grid
        childAspectRatio: 3 / 2,
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
