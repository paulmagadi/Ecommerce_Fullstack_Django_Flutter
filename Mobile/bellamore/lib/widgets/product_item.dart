import 'package:flutter/material.dart';

import '../models/product.dart';
// import 'package:provider/provider.dart';



class ProductItem extends StatelessWidget {

   final Product product;

  ProductItem(this.product);
//   final String id;
//   final String title;
//   final String imageUrl;
//   final double price;

//   ProductItem({
//     required this.id,
//     required this.title,
//     required this.imageUrl,
//     required this.price,
//   });

  // void selectProduct(BuildContext context) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (ctx) => ProductDetailsScreen(
  //         productId: id,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // final cart = Provider.of<Cart>(context, listen: false);

    return GestureDetector(
      // onTap: () => selectProduct(context),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                product.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const Spacer(), 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$$product.price',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart_outlined),
                          onPressed: () {
                            // cart.addItem(id, price, title, 1, imageUrl);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Item Added to Cart!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
