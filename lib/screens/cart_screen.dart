// lib/screens/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/cart_provider.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final items = cartProvider.items;
    final total = cartProvider.totalAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return CartItemTile(
                        cartItem: item,
                        onRemove: () => cartProvider.removeItem(item.id),
                        onUpdateQuantity: (newQty) =>
                            cartProvider.updateQuantity(item.id, newQty),
                      );
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "RWF $total",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/checkout');
                    },
                    child: const Text("Proceed to Checkout"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
