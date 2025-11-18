import 'merchant.dart';
import 'product.dart';

class Listing {
  final String id;
  final double price;
  final int stock;
  final String shipping;
  final Merchant? merchant;
  final Product? product;  // OK: optional

  Listing({
    required this.id,
    required this.price,
    required this.stock,
    required this.shipping,
    this.merchant,
    this.product,  // OK: optional
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] as String,
      price: double.parse(json['price'].toString()),
      stock: json['stock'] as int,
      shipping: (json['shipping'] as String?) ?? 'Standard delivery',
      merchant: json['merchant'] != null 
          ? Merchant.fromJson(json['merchant'] as Map<String, dynamic>) 
          : null,
      product: json['product'] != null 
          ? Product.fromJson(json['product'] as Map<String, dynamic>) 
          : null,  // OK: returns Product? → matches field
    );
  }
}