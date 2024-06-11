class Product {
  final int id;
  final String name;
  final String description;
  final String profileImage;
  // final List<String> productImages;
  final double price;
  final bool isSale;
  final double? salePrice;
  final double? discount;
  final double? percentageDiscount;
  final String slug;
  final int stockQuantity;
  final String? brand;
  final String? material;
  final Category category;
  final String? color;
  final String? size;
  final bool isNew;
  final bool inStock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.profileImage,
    // required this.productImages,
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
    required this.isNew,
    required this.inStock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<String> parseImages(dynamic jsonImages) {
      if (jsonImages is List) {
        return jsonImages.map((img) => img as String).toList();
      }
      return [];
    }

    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      profileImage: json['profile_image'] as String,
      // productImages: parseImages(json['product_images']),
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      isSale: json['is_sale'] as bool? ?? false,
      salePrice: json['sale_price'] != null ? double.tryParse(json['sale_price'].toString()) : null,
      discount: json['discount'] != null ? double.tryParse(json['discount'].toString()) : null,
      percentageDiscount: json['percentage_discount'] != null ? double.tryParse(json['percentage_discount'].toString()) : null,
      slug: json['slug'] as String? ?? '',
      stockQuantity: json['stock_quantity'] as int? ?? 0,
      brand: json['brand'] as String?,
      material: json['material'] as String?,
      category: Category.fromJson(json['category']),
      color: json['color'] as String?,
      size: json['size'] as String?,
      isNew: json['is_new'] as bool? ?? true,
      inStock: json['in_stock'] as bool? ?? true,
    );
  }
}

class Category {
  final String name;
  final String? description;
  final String? image;

  Category({
    required this.name,
    this.description,
    this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
    );
  }
}
