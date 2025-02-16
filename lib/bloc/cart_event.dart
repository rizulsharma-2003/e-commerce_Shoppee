import 'package:e_commerce/models/product.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final Product product;

  AddToCart(this.product);
}

class RemoveFromCart extends CartEvent {
  final Product product;

  RemoveFromCart(this.product);
}

class UpdateQuantity extends CartEvent {
  final Product product;
  final int quantity;

  UpdateQuantity(this.product, this.quantity);
}