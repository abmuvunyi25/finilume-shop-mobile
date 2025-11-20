import 'listing.dart';

String _resolveUrl(String? path) {
  if (path == null || path.isEmpty) return '';
  if (path.startsWith('http')) return path;
  // ensure leading slash for relative paths
  final normalized = path.startsWith('/') ? path : '/$path';
  return 'https://finilume-shop-backend.onrender.com$normalized';
}

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
    required this.listings,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: _resolveUrl(json['imageUrl']),
      listings: (json['listings'] as List? ?? [])
          .map((x) => Listing.fromJson(x))
          .toList(),
    );
  }
}
