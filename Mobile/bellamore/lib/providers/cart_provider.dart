import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _cartItems = {};

  Map<int, CartItem> get cartItems => _cartItems;

  void addToCart(Product product, int quantity) {
    if (_cartItems.containsKey(product.id)) {
      if (_cartItems[product.id]!.quantity + quantity <= product.stockQuantity) {
        _cartItems[product.id]!.quantity += quantity;
      } else {
        _cartItems[product.id]!.quantity = product.stockQuantity;
      }
    } else {
      if (quantity <= product.stockQuantity) {
        _cartItems[product.id] = CartItem(product: product, quantity: quantity);
      } else {
        _cartItems[product.id] = CartItem(product: product, quantity: product.stockQuantity);
      }
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void incrementItem(int productId) {
    if (_cartItems.containsKey(productId)) {
      if (_cartItems[productId]!.quantity < _cartItems[productId]!.product.stockQuantity) {
        _cartItems[productId]!.quantity++;
      }
      notifyListeners();
    }
  }

  void decrementItem(int productId) {
    if (_cartItems.containsKey(productId) && _cartItems[productId]!.quantity > 1) {
      _cartItems[productId]!.quantity--;
    } else {
      _cartItems.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  int get itemCount => _cartItems.length;

  double get totalAmount {
    double total = 0.0;
    _cartItems.forEach((key, cartItem) {
      total += cartItem.product.isSale
          ? cartItem.product.salePrice! * cartItem.quantity
          : cartItem.product.price * cartItem.quantity;
    });
    return total;
  }
}
