class Product {
  final String name;

  Product({
    required this.name,
  });

  // Factory constructor to parse JSON data into a Product instance
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] as String,
    );
  }
}
