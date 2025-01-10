import 'package:flutter/material.dart';
import 'package:sharpens/sharpmen/payment%20page%20normal.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> cartItems;
  final double totalPrice;

  CheckoutPage({required this.cartItems, required this.totalPrice});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _addressController = TextEditingController();
  String address = '';
  String size = ''; // Size selection field

  // Function to navigate to the payment page
  void navigateToPaymentPage() {
    address = _addressController.text.trim();

    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your address')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          cartItems: widget.cartItems,
          totalPrice: widget.totalPrice,
          address: address,
          size: size,  // Pass the selected size
        ),
      ),
    );
  }

  // Add functionality to handle size selection
  void _onSizeChanged(String? value) {
    setState(() {
      size = value ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Address Input Field
            Text(
              'Enter your address:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Size Selection Dropdown
            Text(
              'Select Size:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: size.isEmpty ? null : size,
              hint: Text('Select Size'),
              onChanged: _onSizeChanged,
              items: <String>['Small', 'Medium', 'Large'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: navigateToPaymentPage,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.green,
              ),
              child: Text(
                'Proceed to Payment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
