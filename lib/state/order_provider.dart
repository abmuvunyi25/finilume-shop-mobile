// lib/state/order_provider.dart

import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/api_service.dart';

class OrderProvider extends ChangeNotifier {
  final ApiService api;

  OrderProvider(this.api);

  final List<Order> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Place a new order via checkout
  Future<Order?> placeOrder({
    required String sessionId,
    required String customerName,
    required String customerPhone,
    required String customerEmail,
    required String shippingAddress,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final order = await api.checkout(
        sessionId: sessionId,
        customerName: customerName,
        customerPhone: customerPhone,
        customerEmail: customerEmail,
        shippingAddress: shippingAddress,
      );

      _orders.add(order);
      _isLoading = false;
      notifyListeners();
      return order;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Clear all stored orders (e.g. logout or reset)
  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }
}
