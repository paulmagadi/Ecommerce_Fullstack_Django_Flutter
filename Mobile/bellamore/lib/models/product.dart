class Product {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final bool isSale;
  final double? salePrice;
  final double? discount;
  final double? percentageDiscount;
  final String slug;
  final int stockQuantity;
  final String? brand;
  final String? material;
  final String category;
  final String? color;
  final String? size;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.isSale,
    this.salePrice,
    this.discount,
    this.percentageDiscount,
    required this.slug,
    required this.stockQuantity,
    this.brand,
    this.material,
    required this.category,
    this.color,
    this.size,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null; 
    }

    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    // Access nested 'url' field inside 'image' map
    String imageUrl = json['profile_image']?['url'] as String? ?? 'https://via.placeholder.com/150';
    // String imagesUrl = json['product_images']?['url'] as String ;

    return Product(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Unknown Product',
      description: json['description'] as String? ?? '',
      imageUrl: imageUrl,
      // imagesUrl: imagesUrl,
      price: parseDouble(json['price']) ?? 0.0,
      isSale: json['is_sale'] as bool? ?? false,
      salePrice: parseDouble(json['sale_price']),
      discount: parseDouble(json['discount']),
      percentageDiscount: parseDouble(json['percentage_discount']),
      slug: json['slug'] as String? ?? '',
      stockQuantity: json['stock_quantity'] as int? ?? 0,
      brand: json['brand'] as String?,
      material: json['material'] as String?,
      category: json['category'] as String? ?? 'Unknown',
      color: json['color'] as String?,
      size: json['size'] as String?,
    );
  }
}
