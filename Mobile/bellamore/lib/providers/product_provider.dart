import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
   bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    final url = Uri.parse('${Config.baseUrl}/api/products/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> productData = json.decode(response.body);
        _products = productData.map((data) => Product.fromJson(data)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      print('Error fetching products: $error');
      throw error;
    }
  }



  Future<void> fetchProductsByCategory(int categoryId) async {
    final url =
        Uri.parse('${Config.baseUrl}/api/products/?category=$categoryId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> productData = json.decode(response.body);
        _products = productData.map((data) => Product.fromJson(data)).toList();
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      print('Error fetching products by category: $error');
      throw error;
    }
  }

   
  
}
