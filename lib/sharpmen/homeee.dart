import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sharpens/sharpmen/product%20details.dart';

import 'add to cart.dart';
import 'category helper.dart';

class HomePageee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carousel Slider
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
              ),
              items: [
                'assets/images/OIP.jpeg',
                'assets/images/OIP (1).jpeg',
                'assets/images/th.jpeg',
                'assets/images/th (1).jpeg',
              ].map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),

            // Trending Now Page (GridView with Categories)
            TrendingNowPage(),
          ],
        ),
      ),
    );
  }
}

class TrendingNowPage extends StatelessWidget {
  final List<Map<String, String>> trendingItems = [
    {'image': 'assets/images/shirt2.jpeg', 'title': 'SHIRTS', 'category': 'Shirts'},
    {'image': 'assets/images/ts2.jpg', 'title': 'T-SHIRT', 'category': 'T-Shirts'},
    {'image': 'assets/images/ts1.jpeg', 'title': 'SHOES', 'category': 'Shoes'},
    {'image': 'assets/images/jeans2.jpeg', 'title': 'JEANS', 'category': 'Jeans'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trending Now',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.75,
            ),
            itemCount: trendingItems.length,
            itemBuilder: (context, index) {
              final item = trendingItems[index];
              return TrendingCard(
                imagePath: item['image']!,
                title: item['title']!,
                category: item['category']!,
              );
            },
          ),
        ],
      ),
    );
  }
}

class TrendingCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String category;

  const TrendingCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the respective category page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryPage(categoryName: category),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class CategoryPage extends StatefulWidget {
  final String categoryName;

  CategoryPage({required this.categoryName});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final FirebaseService _firebaseService = FirebaseService();
  Set<String> favorites = {};

  // Fetch products by category
  Future<List<Map<String, dynamic>>> _fetchProducts(String category) async {
    return await _firebaseService.fetchProductsByCategory(category);
  }

  // Toggle favorite status
  Future<void> _toggleFavorite(String productId, Map<String, dynamic> productData) async {
    if (favorites.contains(productId)) {
      await _firebaseService.removeFromWishlist(productId);
      setState(() {
        favorites.remove(productId);
      });
    } else {
      await _firebaseService.addToWishlist(productId, productData);
      setState(() {
        favorites.add(productId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchProducts(widget.categoryName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products available in this category.'));
          }

          List<Map<String, dynamic>> products = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              var productId = product['id'];
              var imageUrl = product['imageUrl'] ?? '';
              var name = product['name'] ?? 'No Name';
              var price = product['price'] ?? 0;

              bool isFavorite = favorites.contains(productId);

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
                              borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
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
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () => _toggleFavorite(productId, product),
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
