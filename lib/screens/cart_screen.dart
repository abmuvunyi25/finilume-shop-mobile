import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/cart_item.dart';
import '../utils/currency.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final api = context.read<ApiService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: FutureBuilder<List<CartItem>>(
        future: api.getCart(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final items = snapshot.data!;
            final grouped = <String, List<CartItem>>{};

            for (var item in items) {
              final name = item.listing.merchant?.name ?? 'Unknown';
              grouped.putIfAbsent(name, () => []).add(item);
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: grouped.entries.map((entry) {
                final merchant = entry.key;
                final items = entry.value;
                final subtotal = items.fold(0.0, (sum, i) => sum + i.listing.price * i.quantity);

                return Card(
                  child: ExpansionTile(
                    title: Text(merchant, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${items.length} item${items.length > 1 ? 's' : ''}'),
                    children: [
                      ...items.map((item) => ListTile(
                            title: Text(item.listing.product?.name ?? 'Unknown Product'),
                            subtitle: Text('${formatRWF(item.listing.price)} × ${item.quantity}'),
                            trailing: Text(formatRWF(item.listing.price * item.quantity)),
                          )),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(formatRWF(subtotal)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          } else if (snapshot.hasData) {
            return const Center(child: Text('Your cart is empty'));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.green,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen()));
          },
          child: const Text('Proceed to Checkout', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}