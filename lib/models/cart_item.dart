import 'listing.dart';

class CartItem {
  final String id;
  final int quantity;
  final Listing listing;

  CartItem({required this.id, required this.quantity, required this.listing});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      quantity: json['quantity'],
      listing: Listing.fromJson(json['listing']),
    );
  }
}