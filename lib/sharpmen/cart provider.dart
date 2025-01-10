import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  // Variables to manage cart state
  int _counter = 0;
  double _totalPrice = 0.0;
  Map<String, dynamic> _cartItems = {}; // Stores cart items by product ID

  // Getters for cart state
  int get counter => _counter;
  double get totalPrice => _totalPrice;
  Map<String, dynamic> get cartItems => _cartItems;

  // Persist cart state using SharedPreferences
  Future<void> _setPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cartCount', _counter);
    prefs.setDouble('totalPrice', _totalPrice);

    // Save cart items as a JSON-like string
    prefs.setString('cartItems', _cartItems.toString());
  }

  Future<void> _getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cartCount') ?? 0;
    _totalPrice = prefs.getDouble('totalPrice') ?? 0.0;

    // Restore cart items from saved string
    final savedCartItems = prefs.getString('cartItems');
    if (savedCartItems != null) {
      _cartItems = Map<String, dynamic>.from(
          savedCartItems.split(',').fold({}, (map, pair) {
            var keyValue = pair.split(':');
            map[keyValue[0]] = keyValue[1];
            return map;
          }));
    }
    notifyListeners();
  }

  // Add an item to the cart
  void addToCart(String productId, String productName, double price, String image) {
    if (_cartItems.containsKey(productId)) {
      // Update quantity and total price if the item already exists
      _cartItems[productId]['quantity']++;
      _cartItems[productId]['totalPrice'] += price;
    } else {
      // Add a new item to the cart
      _cartItems[productId] = {
        'productName': productName,
        'price': price,
        'quantity': 1,
        'totalPrice': price,
        'image': image,
      };
    }
    _counter++;
    _totalPrice += price;
    _setPrefs();
    notifyListeners();
  }

  // Remove an item from the cart
  void removeFromCart(String productId) {
    if (_cartItems.containsKey(productId)) {
      _totalPrice -= _cartItems[productId]['totalPrice'];

      _cartItems.remove(productId); // Remove the item
      _setPrefs();
      notifyListeners();
    }
  }

  // Update the quantity of an item
  void updateItemQuantity(String productId, int quantity) {
    if (_cartItems.containsKey(productId)) {
      double pricePerItem = _cartItems[productId]['price'];
      double previousTotalPrice = _cartItems[productId]['totalPrice'];

      if (quantity > 0) {
        // Update quantity and total price for the item
        _cartItems[productId]['quantity'] = quantity;
        _cartItems[productId]['totalPrice'] = pricePerItem * quantity;

        // Update global counter and total price

        _totalPrice += _cartItems[productId]['totalPrice'] - previousTotalPrice;
      } else {
        // Remove the item if quantity is set to 0
        removeFromCart(productId);
      }

      _setPrefs();
      notifyListeners();
    }
  }

  // Clear all items from the cart
  void clearCart() {
    _cartItems.clear();
    _counter = 0;
    _totalPrice = 0.0;
    _setPrefs();
    notifyListeners();
  }
}
