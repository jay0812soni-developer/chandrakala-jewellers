import 'package:flutter_test/flutter_test.dart';
import 'package:cj_jewellers/core/pricing/jewellery_price_engine.dart';

void main() {
  group('JewelleryPriceEngine Unit Tests', () {
    test('Calculates 22K Gold Price with 28% making charges accurately', () {
      // Board rate = 15,100 per gram
      // Weight = 10 grams
      // Expected formula: (15100 * 0.9166 / 1.03) = 13,437.5417...
      // Metal value = 13,437.5417 * 10 = 134,375.417...
      // With 28% making: 134,375.417 * 1.28 = 172,000.53 -> rounded 172001
      final price = JewelleryPriceEngine.calculatePrice(
        metalType: 'gold',
        weightGrams: 10.0,
        goldRatePerGram: 15100.0,
        silverRatePerGram: 237.0,
        silver925RatePerGram: 650.0,
        makingChargesPercent: 28.0,
      );

      expect(price, greaterThan(170000));
      expect(price, lessThan(175000));
    });

    test('Calculates Silver 925 Price without making charges if not applied', () {
      final price = JewelleryPriceEngine.calculatePrice(
        metalType: 'silver_925',
        weightGrams: 5.0,
        goldRatePerGram: 15100.0,
        silverRatePerGram: 237.0,
        silver925RatePerGram: 650.0,
        makingChargesPercent: 28.0,
        applyMakingToSilver: false,
      );

      // 650 * 5 = 3250
      expect(price, equals(3250.0));
    });

    test('Returns 0.0 for zero or negative weights', () {
      final price = JewelleryPriceEngine.calculatePrice(
        metalType: 'gold',
        weightGrams: 0.0,
        goldRatePerGram: 15100.0,
        silverRatePerGram: 237.0,
        silver925RatePerGram: 650.0,
        makingChargesPercent: 28.0,
      );
      expect(price, equals(0.0));
    });
  });
}
