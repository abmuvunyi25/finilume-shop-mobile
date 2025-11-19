import 'listing.dart';

class CartItem {
  final String id;
  final int quantity;
  final Listing listing;

  CartItem({
    required this.id,
    required this.quantity,
    required this.listing,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id']?.toString() ?? '',
      quantity: json['quantity'] ?? 1,
      listing: Listing.fromJson(json['listing'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'quantity': quantity,
        'listing': listing.toJson(),
      };

  CartItem copyWith({String? id, int? quantity, Listing? listing}) {
    return CartItem(
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      listing: listing ?? this.listing,
    );
  }
}
