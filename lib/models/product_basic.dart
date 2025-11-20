// lib/models/product_basic.dart

class ProductBasic {
  final String id;
  final String name;
  final String imageUrl;

  const ProductBasic({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory ProductBasic.fromJson(Map<String, dynamic> json) {
    return ProductBasic(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown product',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
      };
}
