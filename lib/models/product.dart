import 'listing.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<Listing> listings;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.listings = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      listings: (json['listings'] as List<dynamic>?)
              ?.map((x) => Listing.fromJson(x))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'listings': listings.map((x) => x.toJson()).toList(),
      };
}
