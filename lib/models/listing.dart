import 'merchant.dart';
import 'product_basic.dart'; // used to avoid circular dependency with full Product

class Listing {
  final String id;
  final double price;
  final int stock;
  final String shipping;
  final Merchant? merchant;
  final ProductBasic? product;

  const Listing({
    required this.id,
    required this.price,
    required this.stock,
    required this.shipping,
    this.merchant,
    this.product,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    // Accept both "id" and "listingId"
    final idValue = json['id'] ?? json['listingId'] ?? '';
    return Listing(
      id: idValue.toString(),
      price: _parseDouble(json['price']),
      stock: _parseInt(json['stock']),
      shipping: json['shipping']?.toString() ?? 'Standard delivery',
      merchant: json['merchant'] != null
          ? Merchant.fromJson(Map<String, dynamic>.from(json['merchant']))
          : null,
      product: json['product'] != null
          ? ProductBasic.fromJson(Map<String, dynamic>.from(json['product']))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'price': price,
        'stock': stock,
        'shipping': shipping,
        'merchant': merchant?.toJson(),
        'product': product?.toJson(),
      };
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? 0;
}
