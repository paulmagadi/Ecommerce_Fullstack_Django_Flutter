import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../providers/cart_provider.dart';
import '../providers/shipping_address_provider.dart';
import '../widgets/cart_item.dart';
import 'payment_screen.dart';
import 'shipping_address_form_screen.dart';
// import '../models/cart.dart';

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
    final cartItems = cartProvider.cartItems.values.toList();
    final shippingAddress = shippingProvider.shippingAddress;

    // final totalAmount = cartProvider.totalAmount;
    // final cartProvider = Provider.of<CartProvider>(context);
    // final cartItems = cartProvider.cartItems.values.toList();
    List<Map<String, dynamic>> convertCartItems(List<CartItem> cartItems) {
      return cartItems.map((item) => item.toMap()).toList();
    }

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
              ),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: \$${cartProvider.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18)),
                ElevatedButton(
                  onPressed: () {
                    final totalAmount = cartProvider.totalAmount;
                    final cartItemsList =
                        cartProvider.cartItems.values.toList();

                    if (totalAmount > 0) {
                      final convertedCartItems =
                          convertCartItems(cartItemsList);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                            totalAmount: totalAmount,
                            cartItems: convertedCartItems,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Your cart is empty or the total amount is zero.')),
                      );
                    }
                  },
                  child: const Text('Continue to Payment'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
