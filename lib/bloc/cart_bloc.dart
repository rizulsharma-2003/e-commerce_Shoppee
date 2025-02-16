import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final List<CartItem> _items = [];


  List<CartItem> get items => _items;

  CartBloc() : super(CartInitial()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
  }

  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.product.price * item.quantity);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final existingIndex = _items.indexWhere((item) => item.product.id == event.product.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: event.product));
    }
    emit(CartUpdated(_items));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    _items.removeWhere((item) => item.product.id == event.product.id);
    emit(CartUpdated(_items));
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    final existingIndex = _items.indexWhere((item) => item.product.id == event.product.id);
    if (existingIndex >= 0) {
      if (event.quantity > 0) {
        _items[existingIndex].quantity = event.quantity;
      } else {
        _items.removeAt(existingIndex);
      }
      emit(CartUpdated(_items));
    }
  }
}