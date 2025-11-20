import 'listing.dart';

class CartItem {
  final String id;
  final String listingId;
  final int quantity;
  final String? sessionId;
  final DateTime? createdAt;
  final Listing? listing; // optional, if you hydrate with product details

  CartItem({
    required this.id,
    required this.listingId,
    required this.quantity,
    this.sessionId,
    this.createdAt,
    this.listing,
  });

  double get subtotal {
    // If we have listing details, use its price
    if (listing != null) {
      return listing!.price * quantity;
    }
    return 0.0;
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id']?.toString() ?? '',
      listingId: json['listingId']?.toString() ?? '',
      quantity: json['quantity'] ?? 1,
      sessionId: json['sessionId']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      // If backend sometimes embeds listing details
      listing: json['listing'] != null
          ? Listing.fromJson(Map<String, dynamic>.from(json['listing']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listingId': listingId,
      'quantity': quantity,
      'sessionId': sessionId,
      'createdAt': createdAt?.toIso8601String(),
      'listing': listing?.toJson(),
    };
  }

  CartItem copyWith({
    String? id,
    String? listingId,
    int? quantity,
    String? sessionId,
    DateTime? createdAt,
    Listing? listing,
  }) {
    return CartItem(
      id: id ?? this.id,
      listingId: listingId ?? this.listingId,
      quantity: quantity ?? this.quantity,
      sessionId: sessionId ?? this.sessionId,
      createdAt: createdAt ?? this.createdAt,
      listing: listing ?? this.listing,
    );
  }

  /// Convenience: product name if listing is hydrated
  String? get listingName => listing?.product?.name;
}
