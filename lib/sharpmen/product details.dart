import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'add to cart.dart';
import 'cart provider.dart';
import 'cart ui.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productId; // The document ID of the clicked product

  const ProductDetailsPage({required this.productId, required name, required image, required price, required description, required String productData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        actions: [
          CartIconWithBadge()
        ],
     ),


      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('products').doc(productId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Product not found.'));
          }

          // Retrieve product details from Firebase
          var product = snapshot.data!;
          String imageUrl = product['imageUrl'];
          String description = product['description'];
          double price = product['price'];
          double rating = product['rating'];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image with Aspect Ratio
                  Center(
                    child: AspectRatio(
                      aspectRatio: 16 / 9, // Adjust aspect ratio as needed
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          imageUrl,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Description
                  Text(
                    'Description:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),

                  // Price
                  Text(
                    'Price:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                  SizedBox(height: 20),

                  // Rating
                  Text(
                    'Rating:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '$rating / 5.0',
                    style: TextStyle(fontSize: 16, color: Colors.orange),
                  ),
                  SizedBox(height: 20),

                  // Add to Cart Button
                  ElevatedButton(
                    onPressed: () {
                      // Add product to cart using CartProvider
                      final cartProvider = Provider.of<CartProvider>(context, listen: false);
                      cartProvider.addToCart(
                        productId,
                        description,
                        price,
                        imageUrl,
                      );

                      // Show feedback and navigate to CartScreen
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Product added to cart!')),
                      );

                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
