import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserOrdersPage extends StatelessWidget {
  final CollectionReference orders =
  FirebaseFirestore.instance.collection('orders');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: orders.snapshots(),
        builder: (context, snapshot) {
          // Handle errors
          if (snapshot.hasError) {
            return Center(child: Text('Error loading orders'));
          }

          // Show loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Extract order documents
          final orderDocs = snapshot.data?.docs;

          // Handle no orders
          if (orderDocs == null || orderDocs.isEmpty) {
            return Center(child: Text('No orders placed'));
          }

          return ListView.builder(
            itemCount: orderDocs.length,
            itemBuilder: (context, index) {
              final order = orderDocs[index];
              final orderData = order.data() as Map<String, dynamic>?;

              // Handle null or invalid order data
              if (orderData == null) {
                return ListTile(
                  title: Text('Invalid order data'),
                  subtitle: Text('Order ID: ${order.id}'),
                );
              }

              // Extract and validate order details
              final totalPrice = orderData['totalPrice'] ?? 0.0;
              final size = orderData['size'] ?? 'No size selected';
              final items = orderData['items'] as List<dynamic>? ?? [];

              return Card(
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Total: \$${totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Size: $size'),
                      SizedBox(height: 10),
                      if (items.isEmpty)
                        Text(
                          'No items in this order',
                          style: TextStyle(color: Colors.red),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (context, itemIndex) {
                            final item = items[itemIndex] as Map<String, dynamic>?;

                            if (item == null) {
                              return ListTile(
                                title: Text('Invalid item'),
                              );
                            }

                            final imageUrl = item['imageUrl'] ?? '';
                            final productName = item['productName'] ?? 'Unknown';
                            final quantity = item['quantity'] ?? 0;
                            final price = item['price'] ?? 0.0;

                            return ListTile(
                              leading: imageUrl.isNotEmpty
                                  ? Image.network(
                                imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                                  : Icon(Icons.image_not_supported),
                              title: Text(productName),
                              subtitle: Text(
                                  'Quantity: $quantity - Price: \$${price.toStringAsFixed(2)}'),
                            );
                          },
                        ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            onPressed: () {
                              _showCancelDialog(context, order.id);
                            },
                            child: Text(
                              'Cancel Order',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrackOrderPage(orderId: order.id),
                                ),
                              );
                            },
                            child: Text(
                              'Track Order',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showCancelDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cancel Order'),
          content: Text('Are you sure you want to cancel this order?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                orders.doc(orderId).delete().then((_) {
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Order cancelled')),
                  );
                }).catchError((error) {
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to cancel order')),
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class TrackOrderPage extends StatelessWidget {
  final String orderId;

  TrackOrderPage({required this.orderId});

  @override
  Widget build(BuildContext context) {
    final CollectionReference orders =
    FirebaseFirestore.instance.collection('orders');

    return Scaffold(
      appBar: AppBar(
        title: Text('Track Order'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: orders.doc(orderId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading order details'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Order not found'));
          }

          final orderData = snapshot.data!.data() as Map<String, dynamic>;
          final status = orderData['status'] ?? 'Ordered';

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order ID: $orderId',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Status: $status',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text('Back to Orders'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
