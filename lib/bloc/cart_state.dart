import 'package:e_commerce/models/cart_item.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final List<CartItem> items;

  CartUpdated(this.items);
}