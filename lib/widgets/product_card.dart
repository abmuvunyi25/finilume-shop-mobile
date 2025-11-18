import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/currency.dart';
import 'product_detail_modal.dart'; 

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final bestPrice = product.listings.isEmpty
        ? null
        : product.listings.reduce((a, b) => a.price < b.price ? a : b);

    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            product.imageUrl,
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 100,
              color: Colors.grey[300],
              child: const Icon(Icons.image, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (bestPrice != null)
                  Text(
                    '${formatRWF(bestPrice.price)} • ${bestPrice.merchant?.name ?? 'Unknown Merchant'}',
                    style: const TextStyle(color: Colors.green, fontSize: 12),
                  ),
                if (bestPrice?.shipping.contains('Same-day') == true)
                  const Chip(
                    label: Text('Same-day', style: TextStyle(fontSize: 10)),
                    backgroundColor: Colors.orange,
                  ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(  // FIXED: no "vanadium"
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => ProductDetailModal(product: product),
                    );
                  },
                  child: const Text('View Offers'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}