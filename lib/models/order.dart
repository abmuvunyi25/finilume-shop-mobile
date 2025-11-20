import 'cart_item.dart';

class Order {
  final String id;
  final String sessionId;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String shippingAddress;
  final double totalAmount;
  final String currency;
  final String status; // e.g. PENDING, CONFIRMED, SHIPPED
  final List<CartItem> items;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.sessionId,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.shippingAddress,
    required this.totalAmount,
    required this.currency,
    required this.status,
    required this.items,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id']?.toString() ?? json['orderId']?.toString() ?? '',
      sessionId: json['sessionId']?.toString() ?? '',
      customerName: json['customerName']?.toString() ?? '',
      customerPhone: json['customerPhone']?.toString() ?? '',
      customerEmail: json['customerEmail']?.toString() ?? '',
      shippingAddress: json['shippingAddress']?.toString() ?? '',
      totalAmount: _parseDouble(json['totalAmount'] ?? json['total'] ?? 0),
      currency: json['currency']?.toString() ?? 'RWF',
      status: json['status']?.toString() ?? 'PENDING',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((x) => CartItem.fromJson(Map<String, dynamic>.from(x)))
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sessionId': sessionId,
        'customerName': customerName,
        'customerPhone': customerPhone,
        'customerEmail': customerEmail,
        'shippingAddress': shippingAddress,
        'totalAmount': totalAmount,
        'currency': currency,
        'status': status,
        'items': items.map((x) => x.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}
