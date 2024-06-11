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

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'],
//       name: json['name'],
//       description: json['description'],
//       imageUrl: json['profile_image'],
//       price: json['price'].toDouble(),
//       isSale: json['is_sale'],
//       salePrice: json['sale_price']?.toDouble(),
//       discount: json['discount']?.toDouble(),
//       percentageDiscount: json['percentage_discount']?.toDouble(),
//       slug: json['slug'],
//       stockQuantity: json['stock_quantity'],
//       brand: json['brand'],
//       material: json['material'],
//       category: json['category'],
//       color: json['color'],
//       size: json['size'],
//     );
//   }
// }



  // Factory constructor to parse JSON data into a Product instance
  factory Product.fromJson(Map<String, dynamic> json) {
    // Safely parse the numeric fields using tryParse and handle null values
    double? parseDouble(dynamic value) {
      if (value is num) {
        return value.toDouble();
      } else if (value is String) {
        return double.tryParse(value);
      }
      return null;  // Return null if parsing fails
    }

    int? parseInt(dynamic value) {
      if (value is num) {
        return value.toInt();
      } else if (value is String) {
        return int.tryParse(value);
      }
      return null;  // Return null if parsing fails
    }

    // Handle the parsing of numeric values
    double? price = parseDouble(json['price']);
    double? salePrice = parseDouble(json['sale_price']);
    double? discount = parseDouble(json['discount']);
    int? percentageDiscount = parseInt(json['percentage_discount']);
    
    if (price == null || salePrice == null || discount == null || percentageDiscount == null) {
        throw const FormatException('Invalid data format');
    }

    return Product(
      id: json['id'],
      name: json['name'] as String,
      description: json['description'] as String,
      price: price,
      imageUrl: json['image'] as String,
      isSale: json['is_sale'] as bool,
      salePrice: salePrice,
      stockQuantity: json['stock_quantity'] as int,
      discount: discount,
      percentageDiscount: json['percentageDiscount'],
      slug: json['slug'],
      brand: json['brand'],
      material: json['material'],
      category: json['category'],
      color: json['color'],
      size: json['size'],
    );
  }
}
