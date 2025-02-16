import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class CartPreferences {
  static const String cartKey = 'cart_items';

  static Future<void> addToCart(Product product) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList(cartKey) ?? [];

    String productJson = jsonEncode(product.toJson());

    if (!cartItems.contains(productJson)) {
      cartItems.add(productJson);
      await prefs.setStringList(cartKey, cartItems);
    }
  }

  static Future<void> removeFromCart(Product product) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList(cartKey) ?? [];

    cartItems.removeWhere((item) {
      Map<String, dynamic> decodedItem = jsonDecode(item);
      return decodedItem['id'] == product.id;
    });

    await prefs.setStringList(cartKey, cartItems);
  }

  static Future<List<Product>> getCartItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList(cartKey) ?? [];

    return cartItems.map((item) => Product.fromJson(jsonDecode(item))).toList();
  }

  static Future<bool> isProductInCart(Product product) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList(cartKey) ?? [];

    return cartItems.any((item) {
      Map<String, dynamic> decodedItem = jsonDecode(item);
      return decodedItem['id'] == product.id;
    });
  }
}
