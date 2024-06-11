// models/product.dart
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
  final bool isNew;

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
    this.isNew,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['profile_image'],
      price: json['price'].toDouble(),
      isSale: json['is_sale'],
      salePrice: json['sale_price']?.toDouble(),
      discount: json['discount']?.toDouble(),
      percentageDiscount: json['percentage_discount']?.toDouble(),
      slug: json['slug'],
      stockQuantity: json['stock_quantity'],
      brand: json['brand'],
      material: json['material'],
      category: json['category'],
      color: json['color'],
      size: json['size'],
      isNew: json['new']
    );
  }
}
