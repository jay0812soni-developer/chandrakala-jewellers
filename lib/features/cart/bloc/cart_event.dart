import 'package:equatable/equatable.dart';
import '../../gallery/models/jewellery_item.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends CartEvent {
  final JewelleryItem item;
  const AddToCartEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveFromCartEvent extends CartEvent {
  final int itemId;
  const RemoveFromCartEvent(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
