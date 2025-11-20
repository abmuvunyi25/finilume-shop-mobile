import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartItemTile extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback? onRemove;
  final ValueChanged<int>? onUpdateQuantity;

  const CartItemTile({
    super.key,
    required this.cartItem,
    this.onRemove,
    this.onUpdateQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        cartItem.listing?.product?.imageUrl ?? '',
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) =>
            const Icon(Icons.image_not_supported),
      ),
      title: Text(cartItem.listing?.product?.name ?? 'Unknown Product'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Qty: ${cartItem.quantity} • RWF ${cartItem.listing?.price ?? 0}"),
          if (onUpdateQuantity != null)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    final newQty = cartItem.quantity - 1;
                    if (newQty > 0) onUpdateQuantity!(newQty);
                  },
                ),
                Text('${cartItem.quantity}'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final newQty = cartItem.quantity + 1;
                    onUpdateQuantity!(newQty);
                  },
                ),
              ],
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "RWF ${cartItem.subtotal}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          if (onRemove != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}
