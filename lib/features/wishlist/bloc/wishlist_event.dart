import 'package:equatable/equatable.dart';
import '../../gallery/models/jewellery_item.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWishlistEvent extends WishlistEvent {
  const LoadWishlistEvent();
}

class ToggleWishlistEvent extends WishlistEvent {
  final JewelleryItem item;

  const ToggleWishlistEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveFromWishlistEvent extends WishlistEvent {
  final int itemId;

  const RemoveFromWishlistEvent(this.itemId);

  @override
  List<Object?> get props => [itemId];
}
