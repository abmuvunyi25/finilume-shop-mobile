import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../services/api_service.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  final ApiService api;

  CartProvider(this.api) {
    loadCart();
  }

  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get total => _items.fold(0.0, (sum, item) => sum + item.listing.price * item.quantity);

  Future<void> loadCart() async {
    try {
      _items = await api.getCart();
      notifyListeners();
    } catch (e) {
      print('Load cart error: $e');
    }
  }

  Future<void> addToCart(String listingId, int quantity) async {
    try {
      await api.addToCart(listingId, quantity);
      await loadCart();  // FIXED: Refresh cart after add
      notifyListeners();
    } catch (e) {
      print('Add to cart error: $e');
    }
  }

  Future<void> checkout() async {
    try {
      await api.checkout();
      _items.clear();
      notifyListeners();
    } catch (e) {
      print('Checkout error: $e');
    }
  }
}