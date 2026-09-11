class JewelleryPriceEngine {
  /// Calculate final customer price based on metal type, weight, rates and formula
  static double calculatePrice({
    required String metalType,
    required double weightGrams,
    required double goldRatePerGram,
    required double silverRatePerGram,
    required double silver925RatePerGram,
    required double makingChargesPercent,
    bool applyMakingToSilver = false,
    List<Map<String, dynamic>>? formulaSteps,
  }) {
    if (weightGrams <= 0) return 0.0;

    final metal = metalType.toLowerCase().trim();
    double baseRate = 0.0;
    bool applyMaking = false;

    switch (metal) {
      case 'gold':
        baseRate = goldRatePerGram;
        applyMaking = true;
        // Apply operator chain formula for 22K (default: * 0.9166 / 1.03)
        baseRate = _applyFormula(
          baseRate,
          formulaSteps ??
              [
                {'op': '*', 'value': 0.9166},
                {'op': '/', 'value': 1.03},
              ],
        );
        break;
      case 'silver':
        baseRate = silverRatePerGram;
        applyMaking = applyMakingToSilver;
        break;
      case 'silver_925':
        baseRate = silver925RatePerGram;
        applyMaking = applyMakingToSilver;
        break;
      default:
        return 0.0;
    }

    if (baseRate <= 0) return 0.0;

    double itemPrice = baseRate * weightGrams;

    if (applyMaking && makingChargesPercent > 0) {
      itemPrice += itemPrice * (makingChargesPercent / 100);
    }

    return itemPrice.roundToDouble();
  }

  static double _applyFormula(double base, List<Map<String, dynamic>> steps) {
    double result = base;
    for (final step in steps) {
      final op = step['op']?.toString() ?? '';
      final value = (step['value'] as num?)?.toDouble() ?? 0.0;

      if (op == '+') {
        result += value;
      } else if (op == '-') {
        result -= value;
      } else if (op == '*') {
        result *= value;
      } else if (op == '/' && value != 0) {
        result /= value;
      }
    }
    return result;
  }
}
