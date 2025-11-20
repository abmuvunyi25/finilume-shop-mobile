// lib/widgets/merchant_card.dart

import 'package:flutter/material.dart';
import '../models/listing.dart';

class MerchantCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback onAddToCart;

  const MerchantCard({
    super.key,
    required this.listing,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final merchant = listing.merchant;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: merchant?.logoUrl != null
                  ? NetworkImage(merchant!.logoUrl!)
                  : null,
              radius: 24,
              child: merchant?.logoUrl == null
                  ? const Icon(Icons.store, size: 24)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    merchant?.name ?? "Unknown Merchant",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text("Rating: ⭐ ${merchant?.rating ?? 0}"),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "RWF ${listing.price}",
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("Stock: ${listing.stock}"),
                Text("Shipping: ${listing.shipping}"),
                const SizedBox(height: 6),
                ElevatedButton(
                  onPressed: onAddToCart,
                  child: const Text("Add to Cart"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
