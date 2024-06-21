import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/shipping_address_provider.dart';
import '../widgets/cart_item.dart';
import 'payment_screen.dart';
import 'shipping_address_form_screen.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    _loadShippingAddress();
  }

  Future<void> _loadShippingAddress() async {
    final shippingProvider =
        Provider.of<ShippingAddressProvider>(context, listen: false);
    await shippingProvider.fetchShippingAddress();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final shippingProvider = Provider.of<ShippingAddressProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final cartItems = cartProvider.cartItems.values.toList();
    final shippingAddress = shippingProvider.shippingAddress;

    double totalAmount = cartProvider.totalAmount;
    List<Map<String, dynamic>> convertedCartItems = convertCartItems(cartItems);

    // Ensure user is authenticated and has a userId
    final userId = authProvider.isAuthenticated ? authProvider.userId : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (shippingAddress != null)
              Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shippingAddress.fullName ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(shippingAddress.email ?? ''),
                            Text(shippingAddress.phone ?? ''),
                            Text(
                              '${shippingAddress.address1 ?? ''}, '
                              '${shippingAddress.address2 ?? ''}, '
                              '${shippingAddress.city ?? ''}, '
                              '${shippingAddress.state ?? ''}, '
                              '${shippingAddress.zipcode ?? ''}, '
                              '${shippingAddress.country ?? ''}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShippingAddressForm(),
                            ),
                          ).then((_) => _loadShippingAddress());
                        },
                      ),
                    ],
                  ),
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Shipping Address',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_location_alt,
                        color: Colors.orange),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShippingAddressForm(),
                        ),
                      ).then((_) => _loadShippingAddress());
                    },
                  ),
                ],
              ),
            const SizedBox(height: 20),
            const Text('Order Summary', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (ctx, index) {
                  final cartItem = cartItems[index];
                  return CartItemWidget(cartItem: cartItem);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.orange),
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total: \$${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18)),
            ElevatedButton(
              onPressed: () {
                if (shippingProvider.shippingAddress != null) {
                  if (cartItems.isNotEmpty && totalAmount > 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                          totalAmount: totalAmount,
                          cartItems: convertedCartItems,
                          // shippingAddress: shippingProvider.shippingAddress!.toMap(),
                          shippingAddress: shippingAddress?.toMap() ?? {},
                          userId: userId!, // Ensure userId is not null
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Your cart is empty or the total amount is zero.'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Shipping address required to proceed.'),
                    ),
                  );
                }
              },
              child: const Text('Continue to Payment'),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> convertCartItems(List<CartItem> cartItems) {
    return cartItems.map((item) => item.toMap()).toList();
  }
}
