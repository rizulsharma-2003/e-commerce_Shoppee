import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  CartItemTile({required this.item, required this.onIncrease, required this.onDecrease});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(item.product.image, width: 50, height: 50, fit: BoxFit.cover),
      title: Text(item.product.title),
      subtitle: Text('\$${item.product.price}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: onDecrease,
          ),
          Text(item.quantity.toString()),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: onIncrease,
          ),
        ],
      ),
    );
  }
}