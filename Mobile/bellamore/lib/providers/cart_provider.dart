import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/product.dart';


class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _cartItems = {};  // Stores cart items with product IDs as keys

  Map<int, CartItem> get cartItems => _cartItems;  // Getter for the cart items

  // Adds a product to the cart or updates its quantity
  void addToCart(Product product, int quantity) {
    if (_cartItems.containsKey(product.id)) {
      // If the item is already in the cart, update the quantity without exceeding stock
      if (_cartItems[product.id]!.quantity + quantity <= product.stockQuantity) {
        _cartItems[product.id]!.quantity += quantity;
      } else {
        _cartItems[product.id]!.quantity = product.stockQuantity;
      }
    } else {
      // If the item is new to the cart, add it with the given quantity
      if (quantity <= product.stockQuantity) {
        _cartItems[product.id] = CartItem(product: product, quantity: quantity);
      } else {
        _cartItems[product.id] = CartItem(product: product, quantity: product.stockQuantity);
      }
    }
    notifyListeners();  // Notify listeners about the state change
  }

  // Removes a product from the cart by its ID
  void removeFromCart(int productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  // Increments the quantity of a product in the cart
  void incrementItem(int productId) {
    if (_cartItems.containsKey(productId)) {
      // Ensure the quantity does not exceed the stock quantity
      if (_cartItems[productId]!.quantity < _cartItems[productId]!.product.stockQuantity) {
        _cartItems[productId]!.quantity++;
      }
      notifyListeners();
    }
  }

  // Decrements the quantity of a product in the cart or removes it if the quantity becomes zero
  void decrementItem(int productId) {
    if (_cartItems.containsKey(productId) && _cartItems[productId]!.quantity > 1) {
      _cartItems[productId]!.quantity--;
    } else {
      _cartItems.remove(productId);
    }
    notifyListeners();
  }

  // Clears the entire cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Returns the total number of unique items in the cart
  int get itemCount => _cartItems.length;

  // Calculates the total amount for all items in the cart

// double get totalAmount {
//   double total = 0.0;
//   _cartItems.forEach((key, cartItem) {
//     total += cartItem.product.isSale
//         ? cartItem.product.salePrice! * cartItem.quantity
//         : cartItem.product.price * cartItem.quantity;
//   });
//   return total;
// }
double get totalAmount {
  return _cartItems.values
      .fold(0.0, (sum, item) => sum + (item.product.isSale ? item.product.salePrice : item.product.price)! * item.quantity);
}


 // Returns a list of cart items as maps
  List<Map<String, dynamic>> get cartItemsMap {
    return _cartItems.values.map((item) => item.toMap()).toList();
  }

}