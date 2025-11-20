import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/cart_provider.dart';
import '../services/api_service.dart';
import '../models/order.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final api = context.read<ApiService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: cartProvider.items.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer Info Form
                    const Text(
                      "Customer Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Enter your name" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Enter your phone" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Enter your email" : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: "Shipping Address",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Enter your address" : null,
                    ),

                    const SizedBox(height: 24),

                    // Order Summary
                    const Text(
                      "Order Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...cartProvider.items.map((item) => ListTile(
                          title: Text(item.listingName ?? "Unknown Product"),
                          subtitle: Text("Qty: ${item.quantity}"),
                          trailing: Text(
                            "RWF ${item.subtotal}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        )),
                    const Divider(),
                    Row(
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
                          "RWF ${cartProvider.totalAmount}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Checkout Button
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please fill all fields")),
                                );
                                return;
                              }

                              if (cartProvider.sessionId.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Cart session not ready. Please add items again."),
                                  ),
                                );
                                return;
                              }

                              setState(() => _isLoading = true);

                              try {
                                final order = await api.checkout(
                                  sessionId: cartProvider.sessionId,
                                  customerName: _nameController.text.trim(),
                                  customerPhone: _phoneController.text.trim(),
                                  customerEmail: _emailController.text.trim(),
                                  shippingAddress: _addressController.text.trim(),
                                );

                                cartProvider.clearCart();

                               showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Order Confirmed"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Order ID: ${order.id}"),
                                      Text("Status: ${order.status}"),
                                      Text("Customer: ${order.customerName}"),
                                      Text("Phone: ${order.customerPhone}"),
                                      Text("Email: ${order.customerEmail}"),
                                      Text("Shipping: ${order.shippingAddress}"),
                                      const SizedBox(height: 12),
                                      const Text("Items:", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ...order.items.map((item) => Text(
                                        "- ${item.listingName ?? item.listingId} x${item.quantity} = RWF ${item.subtotal}",
                                      )),
                                      const Divider(),
                                      Text("Total: RWF ${order.totalAmount}"),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // close dialog
                                        Navigator.pop(context); // back to cart
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                ),
                              );

                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Checkout failed: $e")),
                                );
                              } finally {
                                setState(() => _isLoading = false);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Place Order"),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
