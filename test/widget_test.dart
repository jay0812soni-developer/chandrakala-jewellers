import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cj_jewellers/features/gallery/models/jewellery_item.dart';
import 'package:cj_jewellers/features/gallery/widgets/jewellery_card.dart';

void main() {
  testWidgets('JewelleryCard renders name, weight, and price properly', (WidgetTester tester) async {
    final item = JewelleryItem(
      id: 1,
      name: '22K Gold Ring',
      image: 'ring.jpg',
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
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 180,
              height: 280,
              child: JewelleryCard(item: item),
            ),
          ),
        ),
      ),
    );

    expect(find.text('22K Gold Ring'), findsOneWidget);
    expect(find.text('5.500 g'), findsOneWidget);
    expect(find.text('GOLD'), findsOneWidget);
    expect(find.text('₹85,000'), findsOneWidget);
  });
}
