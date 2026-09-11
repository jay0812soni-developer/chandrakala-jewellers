import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _inrFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final NumberFormat _inrDecimalFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static String format(num? amount, {bool showDecimals = false}) {
    if (amount == null) return '₹0';
    return showDecimals
        ? _inrDecimalFormatter.format(amount)
        : _inrFormatter.format(amount);
  }

  static String formatWeight(num? weight) {
    if (weight == null) return '0.000 g';
    return '${weight.toStringAsFixed(3)} g';
  }
}
