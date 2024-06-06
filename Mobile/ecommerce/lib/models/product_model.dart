class Product {
  final String name;
  final String description;
  final double price;
  final String image;
  final bool isSale;
  final double salePrice;
  final bool inStock;
  final int stockQuantity;
  final double discount;
  final int percentageDiscount;
  final bool isNew;
  final bool isFeatured;
  final bool isListed;
  final DateTime createdAt;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.isSale,
    required this.salePrice,
    required this.inStock,
    required this.stockQuantity,
    required this.discount,
    required this.percentageDiscount,
    required this.isNew,
    required this.isFeatured,
    required this.isListed,
    required this.createdAt,
  });
  

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
      name: json['name'] as String,
      description: json['description'] as String,
      price: price,
      image: json['image'] as String,
      isSale: json['is_sale'] as bool,
      salePrice: salePrice,
      inStock: json['in_stock'] as bool,
      stockQuantity: json['stock_quantity'] as int,
      discount: discount,
      percentageDiscount: percentageDiscount,
      isNew: json['is_new'] as bool,
      isFeatured: json['is_featured'] as bool,
      isListed: json['is_listed'] as bool,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
