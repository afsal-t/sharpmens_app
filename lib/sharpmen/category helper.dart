import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch products by category
  Future<List<Map<String, dynamic>>> fetchProductsByCategory(String category) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Store the document ID
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  // Fetch favorite products (wishlist)
  Future<List<Map<String, dynamic>>> fetchFavorites() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Wishlist').get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Store the document ID
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching favorites: $e");
      return [];
    }
  }

  // Add product to wishlist
  Future<void> addToWishlist(String productId, Map<String, dynamic> productData) async {
    try {
      await _firestore.collection('Wishlist').doc(productId).set(productData);
    } catch (e) {
      print("Error adding to wishlist: $e");
    }
  }

  // Remove product from wishlist
  Future<void> removeFromWishlist(String productId) async {
    try {
      await _firestore.collection('Wishlist').doc(productId).delete();
    } catch (e) {
      print("Error removing from wishlist: $e");
    }
  }

  // Check if a product is in the wishlist
  Future<bool> isInWishlist(String productId) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection('Wishlist').doc(productId).get();
      return doc.exists;
    } catch (e) {
      print("Error checking wishlist status: $e");
      return false;
    }
  }

  // Real-time stream to fetch wishlist updates
  Stream<List<Map<String, dynamic>>> fetchWishlistStream() {
    return _firestore.collection('Wishlist').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Store the document ID
        return data;
      }).toList();
    });
  }
}
