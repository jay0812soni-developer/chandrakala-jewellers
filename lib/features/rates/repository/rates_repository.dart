import '../../../core/network/api_client.dart';
import '../../../core/services/logger_service.dart';
import '../models/rate_bundle.dart';

class RatesRepository {
  final ApiClient _client = ApiClient();

  Future<RateBundle> getLatestRates() async {
    try {
      final response = await _client.dio.get('/rates/latest');
      if (response.statusCode == 200 &&
          response.data is Map &&
          response.data['ok'] == true &&
          response.data['data'] is Map) {
        return RateBundle.fromJson(response.data['data'] as Map<String, dynamic>);
      }
      AppLogger.warning(
        'Rates API did not return live board rates (${response.statusCode}).',
      );
    } catch (e) {
      AppLogger.warning('Rates API unavailable ($e).');
    }
    throw Exception('Live rates are waiting for the database.');
  }
}
