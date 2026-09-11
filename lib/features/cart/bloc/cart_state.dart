import 'package:equatable/equatable.dart';
import '../models/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  double get subtotal => items.fold(0.0, (sum, cartItem) => sum + cartItem.totalPrice);
  double get gst => (subtotal * 0.03); // 3% GST standard on jewellery in India
  double get grandTotal => subtotal + gst;
  int get itemCount => items.fold(0, (count, cartItem) => count + cartItem.quantity);

  bool isInCart(int itemId) => items.any((cartItem) => cartItem.item.id == itemId);

  @override
  List<Object?> get props => [items];
}
