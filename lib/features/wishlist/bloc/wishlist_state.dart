import 'package:equatable/equatable.dart';
import '../../gallery/models/jewellery_item.dart';

class WishlistState extends Equatable {
  final List<JewelleryItem> items;
  final bool isLoading;

  const WishlistState({
    this.items = const [],
    this.isLoading = false,
  });

  bool isInWishlist(int itemId) => items.any((i) => i.id == itemId);

  int get count => items.length;

  WishlistState copyWith({
    List<JewelleryItem>? items,
    bool? isLoading,
  }) {
    return WishlistState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [items, isLoading];
}
