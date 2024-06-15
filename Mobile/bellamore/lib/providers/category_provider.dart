import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import '../models/product.dart';
import '../models/category.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories => _categories;

  Future<void> fetchCategories() async {
    final url = Uri.parse('${Config.baseUrl}/api/categories/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> categoryData = json.decode(response.body);
        _categories = categoryData.map((data) => Category.fromJson(data)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      print('Error fetching categories: $error');
      throw error;
    }
  }

  Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    final url = Uri.parse('${Config.baseUrl}/api/products/?category=$categoryId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> productData = json.decode(response.body);
        return productData.map((data) => Product.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      print('Error fetching products by category: $error');
      throw error;
    }
  }
}
