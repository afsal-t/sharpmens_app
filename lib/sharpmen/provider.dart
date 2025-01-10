import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  int _counter = 0;
  double _totalPrice = 0.0;

  int get counter => _counter;
  double get totalPrice => _totalPrice;

  // Set items in SharedPreferences
  Future<void> _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  // Get items from SharedPreferences
  Future<void> _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }

  // Increment counter and save in SharedPreferences
  void addCounter() {
    _counter++;
    _setPrefItems();
    notifyListeners();
  }

  // Decrement counter and save in SharedPreferences
  void removeCounter() {
    if (_counter > 0) {
      _counter--;
      _setPrefItems();
      notifyListeners();
    }
  }

  // Update total price and save in SharedPreferences
  void addTotalPrice(double productPrice) {
    _totalPrice += productPrice;
    _setPrefItems();
    notifyListeners();
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice -= productPrice;
    _setPrefItems();
    notifyListeners();
  }
}
