import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _paymentMethodController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Shipping Address', style: TextStyle(fontSize: 18)),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  hintText: 'Enter your shipping address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text('Payment Method', style: TextStyle(fontSize: 18)),
              TextFormField(
                controller: _paymentMethodController,
                decoration: const InputDecoration(
                  hintText: 'Enter your payment method',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid payment method';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text('Order Summary', style: TextStyle(fontSize: 18)),
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (ctx, index) {
                    final cartItem = cartItems[index];
                    return ListTile(
                      title: Text(cartItem.product.name),
                      subtitle: Text('${cartItem.quantity} x \$${cartItem.product.price}'),
                      trailing: Text('\$${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total'),
                  Text('\$${cartProvider.totalAmount.toStringAsFixed(2)}'),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Place order logic
                    cartProvider.clearCart();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order placed successfully!')),
                    );
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
                child: const Text('Confirm Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _paymentMethodController.dispose();
    super.dispose();
  }
}
