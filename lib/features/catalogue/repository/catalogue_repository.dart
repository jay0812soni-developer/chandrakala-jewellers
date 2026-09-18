import '../../../core/network/api_client.dart';
import '../../../core/services/logger_service.dart';
import '../models/catalogue_item.dart';

class CatalogueRepository {
  final ApiClient _client = ApiClient();

  Future<List<CatalogueItem>> getCatalogueItems({
    String? category,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }

      final response = await _client.dio.get('/catalogue', queryParameters: queryParams);

      if (response.statusCode == 200 && response.data['ok'] == true) {
        final List list = response.data['data'] as List? ?? [];
        return list.map((json) => CatalogueItem.fromJson(json as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      AppLogger.warning('Catalogue API unavailable ($e). Live shop is still https://chandrakalajewellers.in');
    }
    return [];
  }
}
