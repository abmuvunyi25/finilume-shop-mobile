import 'merchant.dart';
import 'product_basic.dart'; // <== fix circular dependency

class Listing {
  final String id;
  final double price;
  final int stock;
  final String shipping;
  final Merchant? merchant;
  final ProductBasic? product;

  Listing({
    required this.id,
    required this.price,
    required this.stock,
    required this.shipping,
    this.merchant,
    this.product,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id']?.toString() ?? '',
      price: _parseDouble(json['price']),
      stock: json['stock'] ?? 0,
      shipping: json['shipping'] ?? 'Standard delivery',
      merchant: json['merchant'] != null
          ? Merchant.fromJson(json['merchant'])
          : null,
      product: json['product'] != null
          ? ProductBasic.fromJson(json['product'])
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

double _parseDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0.0;
}
