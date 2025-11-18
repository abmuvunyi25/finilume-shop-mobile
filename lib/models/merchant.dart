class Merchant {
  final String id;
  final String name;
  final String? logoUrl;
  final double rating;

  Merchant({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.rating,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String?,
      rating: json['rating'] is String 
          ? double.tryParse(json['rating'] as String) ?? 0.0 
          : (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}