import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cj_jewellers/features/gallery/models/jewellery_item.dart';
import 'package:cj_jewellers/features/gallery/widgets/jewellery_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cj_jewellers/features/wishlist/bloc/wishlist_bloc.dart';
import 'package:cj_jewellers/features/cart/bloc/cart_bloc.dart';
import 'package:cj_jewellers/features/rates/bloc/rates_bloc.dart';
import 'package:cj_jewellers/features/rates/repository/rates_repository.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('JewelleryCard renders name, weight, and price properly', (WidgetTester tester) async {
    final item = JewelleryItem(
      id: 1,
      name: '22K Gold Ring',
      image: 'jewelry1.jpg',
      description: 'Gold ring',
      purity: '22K 916',
      stone: '',
      category: 'Rings',
      sku: 'CJ-001',
      dimensions: 'Size 14',
      weight: 5.5,
      cachedPrice: 85000.0,
      metalType: 'gold',
      isFavourite: false,
      isSoldOut: false,
      useManualRates: false,
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<WishlistBloc>(create: (_) => WishlistBloc()),
          BlocProvider<CartBloc>(create: (_) => CartBloc()),
          BlocProvider<RatesBloc>(create: (_) => RatesBloc(repository: RatesRepository())),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 250,
                height: 380,
                child: JewelleryCard(item: item),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('22K Gold Ring'), findsOneWidget);
    expect(find.text('GOLD • 5.500 g'), findsOneWidget);
    expect(find.text('916 GOLD'), findsOneWidget);
    expect(find.text('₹85,000'), findsOneWidget);
  });
}
