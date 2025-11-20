// lib/models/merchant.dart
String _resolveUrl(String? path) {
  if (path == null || path.isEmpty) return '';
  if (path.startsWith('http')) return path;
  final normalized = path.startsWith('/') ? path : '/$path';
  return 'https://finilume-shop-backend.onrender.com$normalized';
}

class Merchant {
  final String id;
  final String name;
  final String logoUrl;
  final double rating;

  Merchant({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.rating,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logoUrl: _resolveUrl(json['logoUrl']),
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
    );
  }

  // ✅ Add this method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'rating': rating,
    };
  }
}

