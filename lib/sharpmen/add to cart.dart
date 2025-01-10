import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart provider.dart';
import 'cart ui.dart';


class CartIconWithBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Stack(
          children: [
            IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.black54),
              onPressed: () {
                // Ensure navigation to CartScreen is working
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
                print('Cart clicked!');
              },
            ),
            if (cartProvider.counter > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    cartProvider.counter.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
