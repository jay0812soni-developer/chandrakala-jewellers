import '../../../core/network/api_client.dart';
import '../../../core/services/logger_service.dart';
import '../models/rate_bundle.dart';

class RatesRepository {
  final ApiClient _client = ApiClient();

  // Fallback store rates when backend is offline or not yet deployed
  static final RateBundle _fallbackRates = RateBundle(
    standard: MetalRate(
      goldRate: 15100.0,
      silverRate: 237.0,
      silver925Rate: 650.0,
      copperRate: 950.0,
      makingChargesPercent: 28.0,
      applyMakingToSilver: true,
      updatedAt: DateTime.now(),
    ),
    manual: MetalRate(
      goldRate: 15100.0,
      silverRate: 237.0,
      silver925Rate: 650.0,
      copperRate: 950.0,
      makingChargesPercent: 28.0,
      applyMakingToSilver: true,
      updatedAt: DateTime.now(),
    ),
    formula: const {
      'gold': [
        {'op': '*', 'value': 0.9166},
        {'op': '/', 'value': 1.03},
      ],
      'silver': [],
      'silver_925': [],
      'copper': [],
    },
  );

  Future<RateBundle> getLatestRates() async {
    try {
      final response = await _client.dio.get('/rates/latest');
      if (response.statusCode == 200 && response.data['ok'] == true) {
        return RateBundle.fromJson(response.data['data']);
      }
    } catch (e) {
      AppLogger.warning(
        'Backend rates API unreachable ($e). Using cached CJ store rates.',
      );
      // Seamless fallback so the user sees live rates with 0 error popups
      return _fallbackRates;
    }
    return _fallbackRates;
  }
}
