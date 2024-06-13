class ProductImage {
  final int id;
  final String imageUrl;

  ProductImage({required this.id, required this.imageUrl});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] as int,
      imageUrl: json['product_images'] as String,
    );
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final String profileImage;
  final List<ProductImage> productImages;
  final double price;
  final bool isSale;
  final double? salePrice;
  final double? discount;
  final double? percentageDiscount;
  final String slug;
  final int stockQuantity;
  final String? brand;
  final String? material;
  final ProductCategory category;
  final String? color;
  final String? size;
  final bool isNew;
  final bool inStock;
  final String?  keyWords;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.profileImage,
    required this.productImages,
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
    this.keyWords,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Parse the list of product images
    List<ProductImage> parseProductImages(dynamic jsonImages) {
      if (jsonImages is List) {
        return jsonImages.map((img) => ProductImage.fromJson(img)).toList();
      }
      return [];
    }

    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      profileImage: json['profile_image'] as String,
      productImages:
          parseProductImages(json['product_images']), // Parse productImages
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      isSale: json['is_sale'] as bool? ?? false,
      salePrice: json['sale_price'] != null
          ? double.tryParse(json['sale_price'].toString())
          : null,
      discount: json['discount'] != null
          ? double.tryParse(json['discount'].toString())
          : null,
      percentageDiscount: json['percentage_discount'] != null
          ? double.tryParse(json['percentage_discount'].toString())
          : null,
      slug: json['slug'] as String? ?? '',
      stockQuantity: json['stock_quantity'] as int? ?? 0,
      brand: json['brand'] as String?,
      material: json['material'] as String?,
      category: ProductCategory.fromJson(json['category']),
      color: json['color'] as String?,
      size: json['size'] as String?,
      isNew: json['is_new'] as bool? ?? true,
      inStock: json['in_stock'] as bool? ?? true,
      keyWords: json['key_words'] as String?,
    );
  }
}

class ProductCategory {
  final int id;
  final String name;
  final String? description;
  final String? image;

  ProductCategory({
    required this.id,
    required this.name,
    this.description,
    this.image,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
    );
  }
}
