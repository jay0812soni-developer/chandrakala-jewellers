import 'package:equatable/equatable.dart';
import '../../gallery/models/jewellery_item.dart';

class CartItem extends Equatable {
  final JewelleryItem item;
  final int quantity;

  const CartItem({
    required this.item,
    this.quantity = 1,
  });

  double get totalPrice => item.cachedPrice * quantity;

  CartItem copyWith({
    JewelleryItem? item,
    int? quantity,
  }) {
    return CartItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [item, quantity];
}
