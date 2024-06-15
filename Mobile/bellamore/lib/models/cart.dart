
import 'product.dart';



class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product,  this.quantity = 1});

  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'productName': product.name,
      'quantity': quantity,
      'price': product.isSale ? product.salePrice : product.price,
    };
  }
}





