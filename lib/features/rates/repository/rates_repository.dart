import '../../../core/network/api_client.dart';
import '../../../core/services/logger_service.dart';
import '../models/rate_bundle.dart';

class RatesRepository {
  final ApiClient _client = ApiClient();

  Future<RateBundle> getLatestRates() async {
    final response = await _client.dio.get('/rates/latest');
    if (response.statusCode == 200 && response.data['ok'] == true) {
      return RateBundle.fromJson(response.data['data'] as Map<String, dynamic>);
    }
    AppLogger.warning('Rates API did not return live board rates.');
    throw Exception('Metal rates are not available on the preview site yet.');
  }
}
