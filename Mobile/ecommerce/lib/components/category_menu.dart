import 'package:flutter/material.dart';

class CategoryMenu extends StatelessWidget {
  const CategoryMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Create a list of category items (e.g., buttons or cards)
          CategoryItem(
            icon: Icons.category, 
            title: 'Shoes',
            onPressed: () {
              // Handle category selection (e.g., navigate to the category screen)
            },
          ),
          CategoryItem(
            icon: Icons.category,
            title: 'T-Shirts',
            onPressed: () {},
          ),
          CategoryItem(
            icon: Icons.category,
            title: 'Dress',
            onPressed: () {},
          ),
          CategoryItem(
            icon: Icons.category,
            title: 'Dress',
            onPressed: () {},
          ),
          CategoryItem(
            icon: Icons.category,
            title: 'Dress',
            onPressed: () {},
          ),
          CategoryItem(
            icon: Icons.category,
            title: 'Dress',
            onPressed: () {},
          ),
          CategoryItem(
            icon: Icons.category,
            title: 'Dress',
            onPressed: () {},
          ),
          CategoryItem(
            icon: Icons.category,
            title: 'Dress',
            onPressed: () {},
          ),
          // Add more CategoryItem widgets as needed
        ],
      ),
    );
  }
}

// Define a custom widget for each category item
class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;

  const CategoryItem({
    required this.icon,
    required this.title,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24.0,
            ),
            const SizedBox(height: 4.0),
            Text(title),
          ],
        ),
      ),
    );
  }
}
