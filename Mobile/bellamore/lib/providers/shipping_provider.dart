
import 'package:flutter/material.dart';
import '../models/shipping_address.dart';
// import '../providers/shipping_address_provider.dart';

class ShippingAddressProvider with ChangeNotifier {
  ShippingAddress? _shippingAddress;

  ShippingAddress? get shippingAddress => _shippingAddress;

  Future<void> fetchShippingAddress() async {
    // Logic to fetch shipping address from backend
    _shippingAddress = ShippingAddress(
      fullName: "John Doe",
      email: "john.doe@example.com",
      address1: "123 Main St",
      city: "New York",
      state: "NY",
      zipcode: "10001",
      country: "USA", 
    );
    notifyListeners();
  }
}
