import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import '../models/category.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('${Config.baseUrl}/api/categories/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> categoryData = json.decode(response.body);
        _categories = categoryData.map((data) => Category.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      print('Error fetching categories: $error');
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
