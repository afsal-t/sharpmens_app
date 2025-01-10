import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  final CollectionReference products =
  FirebaseFirestore.instance.collection('products');

  void _addProduct() async {
    if (_nameController.text.isNotEmpty &&
        _categoryController.text.isNotEmpty &&
        _priceController.text.isNotEmpty) {
      await products.add({
        'name': _nameController.text,
        'category': _categoryController.text,
        'description': _descriptionController.text,
        'price': int.parse(_priceController.text),
        'imageUrl': _imageUrlController.text,
        'availableStock': int.parse(_stockController.text),
        'rating': double.parse(_ratingController.text),
        'favorite': false,
      });

      _nameController.clear();
      _categoryController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _imageUrlController.clear();
      _stockController.clear();
      _ratingController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product Added Successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all required fields')));
    }
  }

  void _setCategoryAndOpenForm(String category) {
    _categoryController.text = category;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                'Add Product to $category',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade700),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              _buildTextField(_nameController, 'Product Name'),
              _buildTextField(_descriptionController, 'Description'),
              _buildTextField(_priceController, 'Price',
                  keyboardType: TextInputType.number),
              _buildTextField(_imageUrlController, 'Image URL'),
              _buildTextField(_stockController, 'Available Stock',
                  keyboardType: TextInputType.number),
              _buildTextField(_ratingController, 'Rating',
                  keyboardType: TextInputType.number),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _addProduct();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Add Product'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.indigo.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo.shade700),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin Panel",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade700,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade700, Colors.purple.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCategoryButton('Shirts'),
              _buildCategoryButton('T-Shirts'),
              _buildCategoryButton('Jeans'),
              _buildCategoryButton('Shoes'),
              SizedBox(height: 20),
              _buildNavigationButton('View Listed Products', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListedProductsPage()),
                );
              }),
              _buildNavigationButton('View Orders', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersPage()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () => _setCategoryAndOpenForm(category),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple.shade400,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Add $category',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(String title, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo.shade700,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class OrdersPage extends StatelessWidget {
  final CollectionReference orders =
  FirebaseFirestore.instance.collection('orders');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
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
              final address = orderData['address'] ?? 'No address provided';
              final size = orderData['size'] ?? 'No size selected'; // Get the size
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
                      Text('Address: $address'),
                      SizedBox(height: 10),
                      Text('Size: $size'),  // Display the selected size
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

                            // Handle invalid item data
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
}


class ListedProductsPage extends StatelessWidget {
  final CollectionReference products =
  FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listed Products"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: products.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error loading products'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final productDocs = snapshot.data?.docs;

          if (productDocs == null || productDocs.isEmpty) {
            return Center(child: Text('No products listed'));
          }

          return ListView.builder(
            itemCount: productDocs.length,
            itemBuilder: (context, index) {
              final product = productDocs[index];
              final productData = product.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: Image.network(
                    productData['imageUrl'] ?? '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(productData['name'] ?? 'No Name'),
                  subtitle: Text('₹${productData['price']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      // Delete the product from Firestore
                      await products.doc(product.id).delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Product deleted successfully')),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}