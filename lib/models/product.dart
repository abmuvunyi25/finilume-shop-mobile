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
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      listings: (json['listings'] as List<dynamic>?)
          ?.map((x) => Listing.fromJson(x as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}