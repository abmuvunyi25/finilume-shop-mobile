import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../utils/currency.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final api = context.read<ApiService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: api.checkout(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            final total = data['total'] as num;
            final itemsByMerchant = data['itemsByMerchant'] as Map<String, dynamic>;

            return SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Order Confirmed!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  const Icon(Icons.check_circle, size: 80, color: Colors.green),
                  const SizedBox(height: 20),
                  Text('Total: ${formatRWF(total.toDouble())}', style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  const Text('Murakoze cyane!', style: TextStyle(fontSize: 18, color: Colors.green)),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: itemsByMerchant.length,
                      itemBuilder: (context, i) {
                        final entry = itemsByMerchant.entries.elementAt(i);
                        final merchant = entry.key;
                        final merchantData = entry.value as Map<String, dynamic>;
                        final merchantItems = merchantData['items'] as List<dynamic>;
                        final subtotal = merchantData['subtotal'] as num;

                        return ExpansionTile(
                          title: Text(merchant),
                          subtitle: Text(formatRWF(subtotal.toDouble())),
                          children: merchantItems.map((item) {
                            return ListTile(
                              title: Text(item['name'] as String),
                              subtitle: Text('${formatRWF(item['price'] as num)} × ${item['quantity']}'),
                              trailing: Text(formatRWF((item['price'] as num) * (item['quantity'] as int))),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                      child: const Text('Back to Shop'),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}