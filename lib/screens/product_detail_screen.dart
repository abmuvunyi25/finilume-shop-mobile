import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import '../models/listing.dart';
import '../widgets/merchant_card.dart';
import '../state/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Product> _productFuture;

  @override
  void initState() {
    super.initState();
    final api = context.read<ApiService>();
    _productFuture = api.getProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final api = context.read<ApiService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
      ),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading product"));
          }
          final product = snapshot.data!;
          final listings = product.listings;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                Hero(
                  tag: product.id,
                  child: Image.network(
                    product.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) =>
                        const Icon(Icons.image_not_supported),
                  ),
                ),

                // Product name & description
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    product.description,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),

                const Divider(),

                // Merchant listings
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Available from merchants",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listings.length,
                  itemBuilder: (context, index) {
                    final listing = listings[index];
                    return MerchantCard(
                      listing: listing,
                      onAddToCart: () async {
                        try {
                          // Ensure session exists
                          if (cartProvider.sessionId.isEmpty) {
                            final newSessionId = await api.startSession();
                            cartProvider.initializeSession(newSessionId);
                          }

                          // Add to cart via backend
                          final cartItem = await api.addToCart(
                            cartProvider.sessionId,
                            listing.id,
                            1,
                          );
                          cartProvider.addItem(cartItem);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "${listing.merchant?.name ?? 'Merchant'} added to cart",
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Add to cart failed: $e")),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
