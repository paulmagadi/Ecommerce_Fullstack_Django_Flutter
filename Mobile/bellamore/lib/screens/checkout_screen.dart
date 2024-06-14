import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/shipping_address_provider.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipcodeController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadShippingAddress();
  }

  Future<void> _loadShippingAddress() async {
    final shippingProvider = Provider.of<ShippingAddressProvider>(context, listen: false);
    await shippingProvider.fetchShippingAddress();
    final shippingAddress = shippingProvider.shippingAddress;

    if (shippingAddress != null) {
      _phoneController.text = shippingAddress.phone ?? '';
      _fullNameController.text = shippingAddress.fullName ?? '';
      _emailController.text = shippingAddress.email ?? '';
      _address1Controller.text = shippingAddress.address1 ?? '';
      _address2Controller.text = shippingAddress.address2 ?? '';
      _cityController.text = shippingAddress.city ?? '';
      _stateController.text = shippingAddress.state ?? '';
      _zipcodeController.text = shippingAddress.zipcode ?? '';
      _countryController.text = shippingAddress.country ?? '';
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipcodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems.values.toList();
    final shippingProvider = Provider.of<ShippingAddressProvider>(context);

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
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _address1Controller,
                decoration: const InputDecoration(labelText: 'Address 1'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _address2Controller,
                decoration: const InputDecoration(labelText: 'Address 2'),
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(labelText: 'State'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your state';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _zipcodeController,
                decoration: const InputDecoration(labelText: 'Zip Code'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your zip code';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Country'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your country';
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
                      subtitle: Text('${cartItem.quantity} x \$${cartItem.product.isSale ? cartItem.product.salePrice : cartItem.product.price}'),
                      trailing: Text('\$${(cartItem.product.isSale ? cartItem.product.salePrice! * cartItem.quantity : cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}'),
                    );
                  },
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(fontSize: 18)),
                  Text('\$${cartProvider.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    shippingProvider.updateShippingAddress(
                      id: shippingProvider.shippingAddress?.id ?? 0,
                      phone: _phoneController.text,
                      fullName: _fullNameController.text,
                      email: _emailController.text,
                      address1: _address1Controller.text,
                      address2: _address2Controller.text,
                      city: _cityController.text,
                      state: _stateController.text,
                      zipcode: _zipcodeController.text,
                      country: _countryController.text,
                    );
                    // Place order logic
                    // cartProvider.clearCart();
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
}
