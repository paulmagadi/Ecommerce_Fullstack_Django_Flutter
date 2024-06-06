import 'dart:convert';
import 'package:http/http.dart' as http;
import 'category_model.dart';

Future<List<Product>> fetchProducts() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/products/'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((product) => Product.fromJson(product)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}