import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart provider.dart';
import 'checkout page.dart';


class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    void navigateToCheckoutPage() {
      if (cartProvider.cartItems.isEmpty) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutPage(
            cartItems: cartProvider.cartItems,
            totalPrice: cartProvider.totalPrice,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: cartProvider.cartItems.isEmpty
          ? Center(
        child: Text(
          'Your cart is empty!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.cartItems.length,
              itemBuilder: (context, index) {
                final productId =
                cartProvider.cartItems.keys.toList()[index];
                final cartItem = cartProvider.cartItems[productId];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              cartItem['image'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartItem['productName'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                    'Price: \$${cartItem['price'].toStringAsFixed(2)}'),
                                Text(
                                    'Total: \$${cartItem['totalPrice'].toStringAsFixed(2)}'),
                                Text(
                                    'Quantity: ${cartItem['quantity']}'),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.add,
                                    color: Colors.green),
                                onPressed: () {
                                  cartProvider.updateItemQuantity(
                                    productId,
                                    cartItem['quantity'] + 1,
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.remove,
                                    color: Colors.red),
                                onPressed: () {
                                  if (cartItem['quantity'] > 1) {
                                    cartProvider.updateItemQuantity(
                                      productId,
                                      cartItem['quantity'] - 1,
                                    );
                                  } else {
                                    cartProvider.removeFromCart(
                                        productId);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: navigateToCheckoutPage,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    'Proceed to Checkout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
