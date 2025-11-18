import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/currency.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';

class ProductDetailModal extends StatelessWidget {
  final Product product;
  const ProductDetailModal({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: ListView(
          controller: controller,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.imageUrl,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, size: 60, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(product.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(product.description, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            const Text('Choose Your Offer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            if (product.listings.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text('No offers available', textAlign: TextAlign.center),
              )
            else
              ...product.listings.map((listing) => Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green[50],
                        child: Text(
                          listing.merchant?.name[0] ?? '?',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(listing.merchant?.name ?? 'Unknown Merchant'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(formatRWF(listing.price)),
                          Text(listing.shipping, style: const TextStyle(color: Colors.orange, fontSize: 12)),
                        ],
                      ),
                      trailing: ElevatedButton(
                       onPressed: () async {
                          final cart = Provider.of<CartProvider>(context, listen: false);
                          await cart.addToCart(listing.id, 1);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added to cart! (${cart.itemCount} items)'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: const Text('Add'),
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}