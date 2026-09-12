import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cj_jewellers/features/gallery/models/jewellery_item.dart';
import 'package:cj_jewellers/features/wishlist/bloc/wishlist_bloc.dart';
import 'package:cj_jewellers/features/wishlist/bloc/wishlist_event.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  final testItem = JewelleryItem(
    id: 110,
    name: 'Pendent Butti Set',
    image: 'item_110.jpg',
    description: 'Gold set',
    purity: '22K 916',
    stone: 'CZ',
    category: 'Necklace Sets',
    sku: 'CJ-110',
    dimensions: 'Medium',
    weight: 11.64,
    cachedPrice: 224977.0,
    metalType: 'gold',
    isFavourite: true,
    isSoldOut: false,
    useManualRates: false,
    createdAt: DateTime.now(),
  );

  test('WishlistBloc initial state is empty', () {
    final bloc = WishlistBloc();
    expect(bloc.state.items, isEmpty);
    expect(bloc.state.count, 0);
  });

  test('WishlistBloc toggle event adds and removes item', () async {
    final bloc = WishlistBloc();
    bloc.add(ToggleWishlistEvent(testItem));
    await pumpEventQueue();

    expect(bloc.state.items.length, 1);
    expect(bloc.state.isInWishlist(110), isTrue);

    bloc.add(ToggleWishlistEvent(testItem));
    await pumpEventQueue();

    expect(bloc.state.items, isEmpty);
    expect(bloc.state.isInWishlist(110), isFalse);
  });

  test('WishlistBloc remove event removes item by id', () async {
    final bloc = WishlistBloc();
    bloc.add(ToggleWishlistEvent(testItem));
    await pumpEventQueue();
    expect(bloc.state.items.length, 1);

    bloc.add(const RemoveFromWishlistEvent(110));
    await pumpEventQueue();

    expect(bloc.state.items, isEmpty);
  });
}
