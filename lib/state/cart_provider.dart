import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  String sessionId = '';
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  /// Called when session is created
  void initializeSession(String id) {
    sessionId = id;
    notifyListeners();
  }

  /// Add a new item returned from backend
  void addItem(CartItem item) {
    // If item already exists, update quantity
    final index = _items.indexWhere((i) => i.listingId == item.listingId);
    if (index != -1) {
      final existing = _items[index];
      _items[index] = existing.copyWith(
        quantity: existing.quantity + item.quantity,
      );
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  /// Remove item by cart item id
  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  /// Update quantity of a cart item
  void updateQuantity(String id, int newQty) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(quantity: newQty);
      notifyListeners();
    }
  }

  /// Clear cart locally
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
