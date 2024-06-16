import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _cartItems =
      {}; // Stores cart items with product IDs as keys

  Map<int, CartItem> get cartItems => _cartItems; // Getter for the cart items
  // Save cart items to SharedPreferences
  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItemsJson =
        _cartItems.values.map((item) => json.encode(item.toMap())).toList();
    prefs.setStringList('cartItems', cartItemsJson);
  }

  // Load cart items from SharedPreferences
  Future<void> _loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cartItemsJson = prefs.getStringList('cartItems');
    if (cartItemsJson != null) {
      _cartItems.clear();
      for (String itemJson in cartItemsJson) {
        Map<String, dynamic> itemMap = json.decode(itemJson);
        Product product = await _fetchProductById(
            itemMap['productId']); // Fetch product details by ID
        _cartItems[itemMap['productId']] = CartItem(
          product: product,
          quantity: itemMap['quantity'],
        );
      }
    }
  }

  // Fetch product details by ID
  Future<Product> _fetchProductById(int productId) async {
    // Implement your logic to fetch product details by its ID
    // This could be an API call or fetching from a local database
    throw UnimplementedError(); // Replace with actual implementation
  }

  void addToCart(Product product, int quantity) async {
    if (product.stockQuantity == 0) {}
    if (_cartItems.containsKey(product.id)) {
      // If the item is already in the cart, update the quantity without exceeding stock
      if (_cartItems[product.id]!.quantity + quantity <=
          product.stockQuantity) {
        _cartItems[product.id]!.quantity += quantity;
      } else {
        _cartItems[product.id]!.quantity = product.stockQuantity;
      }
    } else {
      // If the item is new to the cart, add it with the given quantity
      if (quantity <= product.stockQuantity) {
        _cartItems[product.id] = CartItem(product: product, quantity: quantity);
      } else {
        _cartItems[product.id] =
            CartItem(product: product, quantity: product.stockQuantity);
      }
    }
    notifyListeners(); // Notify listeners about the state change
    // Save cart state
    await _saveCartToPrefs();
  }

  // Removes a product from the cart by its ID
  void removeFromCart(int productId) async {
    _cartItems.remove(productId);
    notifyListeners();
    // Save cart state
    await _saveCartToPrefs();
  }

  // Increments the quantity of a product in the cart
  void incrementItem(int productId) async {
    if (_cartItems.containsKey(productId)) {
      // Ensure the quantity does not exceed the stock quantity
      if (_cartItems[productId]!.quantity <
          _cartItems[productId]!.product.stockQuantity) {
        _cartItems[productId]!.quantity++;
      }
      notifyListeners();
    }
    // Save cart state
    await _saveCartToPrefs();
  }

  // Decrements the quantity of a product in the cart or removes it if the quantity becomes zero
  void decrementItem(int productId) async {
    if (_cartItems.containsKey(productId) &&
        _cartItems[productId]!.quantity > 1) {
      _cartItems[productId]!.quantity--;
    } else {
      _cartItems.remove(productId);
    }
    notifyListeners();
    // Save cart state
    await _saveCartToPrefs();
  }

  // Clears the entire cart
  void clearCart() async {
    _cartItems.clear();
    notifyListeners();
    // Save cart state
    await _saveCartToPrefs();
  }

  // Returns the total number of unique items in the cart
  int get itemCount => _cartItems.length;

  // Calculates the total amount for all items in the cart

  double get totalAmount {
    return _cartItems.values.fold(
        0.0,
        (sum, item) =>
            sum +
            (item.product.isSale
                    ? item.product.salePrice
                    : item.product.price)! *
                item.quantity);
  }

  List<Map<String, dynamic>> get cartItemsMap {
    return _cartItems.values.map((item) => item.toMap()).toList();
  }

  // Load cart state when the provider is initialized
  Future<void> initializeCart() async {
    await _loadCartFromPrefs();
    notifyListeners(); // Notify listeners to update the UI
  }
}
