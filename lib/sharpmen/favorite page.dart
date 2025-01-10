import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharpens/sharpmen/product%20details.dart';

import 'category helper.dart';
 // Assuming this file contains FirebaseService

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final FirebaseService _firebaseService = FirebaseService();
  Set<String> favorites = {}; // Track favorite product IDs

  @override
  void initState() {
    super.initState();
    // Listen to real-time updates from the wishlist stream
    _firebaseService.fetchWishlistStream().listen((data) {
      setState(() {
        // Update the wishlist data
        favorites = data.map((item) => item['id'] as String).toSet();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wishlist"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firebaseService.fetchWishlistStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products added to wishlist.'));
          }

          List<Map<String, dynamic>> wishlist = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.75,
            ),
            itemCount: wishlist.length,
            itemBuilder: (context, index) {
              var product = wishlist[index];
              var productId = product['id'];
              var imageUrl = product['imageUrl'] ?? '';
              var name = product['name'] ?? 'No Name';
              var price = product['price'] ?? 0;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsPage(
                        productId: productId,
                        name: name,
                        image: imageUrl,
                        price: price,
                        description: product['description'] ?? 'No description',
                        productData: '',
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              name,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '\₹$price',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: favorites.contains(productId)
                              ? Colors.red
                              : Colors.grey,
                        ),
                        onPressed: () {
                          // Optionally handle removal from wishlist
                          _firebaseService.removeFromWishlist(productId);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
