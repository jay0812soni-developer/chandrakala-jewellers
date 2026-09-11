import 'package:flutter_test/flutter_test.dart';
import 'package:cj_jewellers/features/cart/bloc/cart_bloc.dart';
import 'package:cj_jewellers/features/cart/bloc/cart_event.dart';
import 'package:cj_jewellers/features/gallery/models/jewellery_item.dart';

void main() {
  group('CartBloc Tests', () {
    late CartBloc cartBloc;

    final testItem1 = JewelleryItem(
      id: 110,
      name: 'Pendent Butti Set',
      image: 'test.jpg',
      description: 'Gold set',
      purity: '22K 916',
      stone: 'CZ',
      category: 'Necklace',
      sku: 'CJ-110',
      dimensions: 'Medium',
      weight: 10.0,
      cachedPrice: 150000.0,
      metalType: 'gold',
      isFavourite: false,
      isSoldOut: false,
      useManualRates: false,
      createdAt: DateTime.now(),
    );

    setUp(() {
      cartBloc = CartBloc();
    });

    tearDown(() {
      cartBloc.close();
    });

    test('Initial state has 0 items', () {
      expect(cartBloc.state.items, isEmpty);
      expect(cartBloc.state.subtotal, equals(0.0));
    });

    test('Adding unique piece adds to cart', () {
      cartBloc.add(AddToCartEvent(testItem1));

      expectLater(
        cartBloc.stream,
        emits(predicate<dynamic>((state) {
          return state.items.length == 1 &&
              state.subtotal == 150000.0 &&
              state.gst == (150000.0 * 0.03) &&
              state.grandTotal == (150000.0 * 1.03);
        })),
      );
    });

    test('Duplicate add of same unique piece is ignored', () async {
      cartBloc.add(AddToCartEvent(testItem1));
      await Future.delayed(const Duration(milliseconds: 20));

      // Attempt second add of same piece
      cartBloc.add(AddToCartEvent(testItem1));
      await Future.delayed(const Duration(milliseconds: 20));

      expect(cartBloc.state.items.length, equals(1));
    });

    test('Removing item updates subtotal and grand total', () async {
      cartBloc.add(AddToCartEvent(testItem1));
      await Future.delayed(const Duration(milliseconds: 20));

      cartBloc.add(RemoveFromCartEvent(testItem1.id));
      await Future.delayed(const Duration(milliseconds: 20));

      expect(cartBloc.state.items, isEmpty);
      expect(cartBloc.state.grandTotal, equals(0.0));
    });
  });
}
