import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order placed.dart';
// Ensure the correct file name and import path


class PaymentPage extends StatelessWidget {
  final Map<String, dynamic> cartItems;
  final double totalPrice;
  final String address;

  // Constructor to receive the cart items, total price, and address
  PaymentPage({
    required this.cartItems,
    required this.totalPrice,
    required this.address,
    required String size,
  });

  // Function to place the order
  void placeOrder(BuildContext context) async {
    if (cartItems.isEmpty) return;

    final orderData = cartItems.values.map((item) {
      return {
        'productName': item['productName'],
        'price': item['price'],
        'quantity': item['quantity'],
        'totalPrice': item['totalPrice'],
        'imageUrl': item['image'],
      };
    }).toList();

    await FirebaseFirestore.instance.collection('orders').add({
      'items': orderData,
      'totalPrice': totalPrice,
      'timestamp': FieldValue.serverTimestamp(),
      'address': address,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Order placed successfully!',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
    );

    // Navigate to OrderPlacedScreen after placing the order
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderPlacedScreen(), // Ensure OrderPlacedScreen exists
      ),
    );
  }

  // Function to show the Cash on Delivery confirmation dialog
  void _showCODConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm Order',
          style: TextStyle(color: Colors.teal),
        ),
        content: Text('Do you want to place the order via Cash on Delivery?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.teal),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              placeOrder(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderPlacedScreen()));// Call placeOrder when confirmed
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Payment',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  // Add Razorpay integration here
                },
                child: Text(
                  'Pay Online',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () => _showCODConfirmation(context),
                child: Text(
                  'Cash on Delivery',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
