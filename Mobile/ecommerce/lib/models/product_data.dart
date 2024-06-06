import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_model.dart';

const String apiUrl = 'http://10.0.2.2:8000/api/products/';

Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/products'));

  if (response.statusCode == 200) {
    // Parse the JSON response
    List<dynamic> data = jsonDecode(response.body);
    // Map the data to Product objects
    return data.map((product) => Product.fromJson(product)).toList();
  } else {
    // Throw an exception if the response is not 200 OK
    throw Exception('Failed to load products');
  }
}

