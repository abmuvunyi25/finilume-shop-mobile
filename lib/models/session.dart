// lib/models/session.dart

import 'cart_item.dart';

class Session {
  final String id;
  final List<CartItem> items;

  Session({required this.id, required this.items});

  factory Session.fromJson(Map<String, dynamic> json) {
    // Accept multiple possible id field names
    final idValue = json['id'] ?? json['_id'] ?? json['sessionId'] ?? json['session_id'] ?? '';
    final idStr = idValue?.toString() ?? '';

    // items may be under 'items' or 'cartItems' or missing
    final itemsJson = (json['items'] as List?) ?? (json['cartItems'] as List?) ?? [];
    final items = itemsJson.map((e) {
      if (e is Map<String, dynamic>) return CartItem.fromJson(e);
      return CartItem.fromJson(Map<String, dynamic>.from(e));
    }).toList();

    return Session(id: idStr, items: items);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}
