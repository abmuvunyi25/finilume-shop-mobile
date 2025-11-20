// lib/screens/orders_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/order_provider.dart';
import '../models/order.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final orders = orderProvider.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
      ),
      body: orderProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(
                  child: Text(
                    "No orders yet",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                )
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return OrderTile(order: order);
                  },
                ),
    );
  }
}

class OrderTile extends StatelessWidget {
  final Order order;

  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order #${order.id}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Chip(
                  label: Text(order.status),
                  backgroundColor: order.status == "CONFIRMED"
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                  labelStyle: TextStyle(
                    color: order.status == "CONFIRMED"
                        ? Colors.green.shade800
                        : Colors.orange.shade800,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Customer Info
            Text("Customer: ${order.customerName}"),
            Text("Phone: ${order.customerPhone}"),
            Text("Email: ${order.customerEmail}"),
            Text("Address: ${order.shippingAddress}"),

            const SizedBox(height: 8),

            // Order Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "RWF ${order.totalAmount}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Order Date
            Text(
              "Placed on: ${order.createdAt.toLocal().toString().split(' ')[0]}",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
