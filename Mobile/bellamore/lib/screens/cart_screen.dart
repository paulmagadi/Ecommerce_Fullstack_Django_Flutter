// screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text('Your cart is empty.'),
            )
          : Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(15),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Total',
                          style: TextStyle(fontSize: 20),
                        ),
                        const Spacer(),
                        Chip(
                          label: Text(
                            '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .headline6
                                  ?.color,
                            ),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      CartItem cartItem = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: ListTile(
                          leading: Image.network(
                            cartItem.product.profileImage,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(cartItem.product.name),
                          subtitle: Text(
                            '${cartItem.product.isSale ? cartItem.product.salePrice : cartItem.product.price} \$ x ${cartItem.quantity}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              cartProvider.removeFromCart(cartItem.product.id);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            // Proceed to checkout action
          },
          child: const Text('Proceed to Checkout'),
        ),
      ),
    );
  }
}
