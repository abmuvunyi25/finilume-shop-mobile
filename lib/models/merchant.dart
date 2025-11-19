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
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown merchant',
      logoUrl: json['logoUrl'],
      rating: _parseDouble(json['rating']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'logoUrl': logoUrl,
        'rating': rating,
      };
}

double _parseDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0.0;
}
