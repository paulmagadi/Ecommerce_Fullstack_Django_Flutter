import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../screens/category_items_screen.dart';

class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryItemsScreen(category: category),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(3), // Margin around each item
        padding: const EdgeInsets.all(5), // Padding inside the container
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple.withOpacity(0.8),
              Colors.purple,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(5), // Rounded corners
          image: DecorationImage(
            image: NetworkImage(category.image ?? ''),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4), BlendMode.darken),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 24, // Increased font size for emphasis
                    fontWeight: FontWeight.bold, // Bold font weight
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
                height:
                    5), // Space between text and additional content if needed
            // Additional content like a description or category count can be added here
          ],
        ),
      ),
    );
  }
}
