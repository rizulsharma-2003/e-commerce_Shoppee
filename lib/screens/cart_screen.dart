import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Shopping Cart',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
      if (state is CartUpdated) {
        final cartItems = state.items;
        return Column(
            children: [
        Expanded(
        child: ListView.builder(
        padding: const EdgeInsets.all(10),
    itemCount: cartItems.length,
    itemBuilder: (context, index) {
    final item = cartItems[index];
    return Card(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
    ),
    color: Colors.white,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
    elevation: 5,
    child: Container(
    height: 150,
    padding: const EdgeInsets.all(10),
    child: Row(
    children: [

    Container(
    width: 100,
    height: 100,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    ),
    child: ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Image.network(
    item.product.image,
    fit: BoxFit.contain,
    ),
    ),
    ),
      const SizedBox(width: 10),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text(
    item.product.title,
    style: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black),
    overflow: TextOverflow.ellipsis,
    maxLines: 2,
    ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '\$${item.product.price} x ${item.quantity}',
            style: const TextStyle(fontSize: 14, color: Colors.black45),
          ),

          SizedBox(
            height: 22,
            child: Row(
              children: [

                Container(
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.remove, color: Colors.white, size: 16),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      int newQuantity = item.quantity - 1;
                      if (newQuantity <= 0) {
                        context.read<CartBloc>().add(RemoveFromCart(item.product));
                      } else {
                        context.read<CartBloc>().add(UpdateQuantity(item.product, newQuantity));
                      }
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(fontSize: 16, color: Colors.black45),
                  ),
                ),

                Container(
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white, size: 16),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      int newQuantity = item.quantity + 1;
                      context.read<CartBloc>().add(UpdateQuantity(item.product, newQuantity));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),    const SizedBox(height: 5),

    Text(
    'Total: \$${(item.product.price * item.quantity).toStringAsFixed(2)}',
    style: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.blueGrey),
    ),
    ],
    ),
    ),
    ],
    ),
    ),
    );
    },
    ),
    ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total: \$${cartItems.fold(0.0, (total, item) => total + (item.product.price * item.quantity)).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {

                        },
                        child: const Text(
                          'Checkout',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
        );
      } else {
        return const Center(
          child: Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black45),
          ),
        );
      }
        },
        ),
    );
  }
}