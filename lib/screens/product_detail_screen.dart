import 'package:e_commerce/bloc/cart_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../bloc/cart_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isLiked = false;
  bool isInCart = false;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    _loadCartState();
  }

  Future<void> _loadCartState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isInCart = prefs.getBool('cart_${widget.product.id}') ?? false;
    });
  }

  Future<void> _toggleCartState() async {
    if (isInCart) {
      _showRemoveDialog();
    } else {
      _showQuantityDialog();
    }
  }

  void _showQuantityDialog() {
    showDialog(
      context: context,
      builder: (context) {
        int tempQuantity = quantity;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Select Quantity"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (tempQuantity > 1) {
                            setDialogState(() {
                              tempQuantity--;
                            });
                          }
                        },
                      ),
                      Text(tempQuantity.toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setDialogState(() {
                            tempQuantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      quantity = tempQuantity;
                    });
                    _confirmAddToCart();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Confirm"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmAddToCart() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isInCart = true;
      prefs.setBool('cart_${widget.product.id}', true);
    });
    context.read<CartBloc>().add(AddToCart(widget.product));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.title} ($quantity) added to cart!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _confirmRemoveFromCart() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isInCart = false;
      prefs.setBool('cart_${widget.product.id}', false);
    });
    context.read<CartBloc>().add(RemoveFromCart(widget.product));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.title} removed from cart!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  void _showRemoveDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Remove from Cart"),
          content: Text("Are you sure you want to remove this item from the cart?"),
          actions: [
            Center(
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("No"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        _confirmRemoveFromCart();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("Yes"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: screenHeight * 0.6,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: widget.product.id,
                      child: Image.network(
                        widget.product.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(1.0),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '\$${widget.product.price}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              widget.product.rating.rate.toString(),
                              style: const TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "(${widget.product.rating.count})",
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.product.description,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Positioned(
              top: 20,
              right: 20,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey<bool>(isLiked),
                        color: isLiked ? Colors.red : Colors.black,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.black, size: 28),
                    onPressed: () {
                      Share.share(
                        '🔹 Check out this product! 🔹\n\n'
                            '🛍️ *${widget.product.title}*\n'
                            '💰 Price: \$${widget.product.price}\n'
                            '⭐ Rating: ${widget.product.rating.rate} (${widget.product.rating.count} reviews)\n\n'
                            '🖼️ Product Image: ${widget.product.image}\n',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          width: screenWidth,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _toggleCartState,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              fixedSize: Size(screenWidth * 0.9, 50),
              backgroundColor: isInCart ? Colors.grey : Colors.amber.withOpacity(0.8),
              foregroundColor: isInCart ? Colors.white : Colors.black,
            ),
            child: Text(
              isInCart ? "REMOVE FROM CART" : "ADD TO CART",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}