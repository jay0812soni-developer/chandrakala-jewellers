import '../../../core/network/api_client.dart';
import '../../../core/services/logger_service.dart';
import '../models/jewellery_item.dart';

class GalleryRepository {
  final ApiClient _client = ApiClient();

  Future<List<JewelleryItem>> getItems({
    String metalType = 'all',
    String? category,
    String? search,
    String sort = 'newest',
    double? minPrice,
    double? maxPrice,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'metal_type': metalType,
        'sort': sort,
        'page': page,
        'limit': limit,
      };
      if (category != null && category.isNotEmpty && category != 'All') {
        queryParams['category'] = category;
      }
      if (search != null && search.trim().isNotEmpty) {
        queryParams['q'] = search.trim();
      }
      if (minPrice != null) queryParams['min_price'] = minPrice;
      if (maxPrice != null) queryParams['max_price'] = maxPrice;

      final response = await _client.dio.get('/inventory', queryParameters: queryParams);

      if (response.statusCode == 200 && response.data['ok'] == true) {
        final List list = response.data['data'] as List? ?? [];
        return list.map((json) => JewelleryItem.fromJson(json as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      AppLogger.warning('Inventory API unavailable ($e). Live shop is still https://chandrakalajewellers.in');
    }
    return [];
  }

  Future<Map<String, dynamic>> getItemDetails(int id) async {
    try {
      final response = await _client.dio.get('/inventory/$id');
      if (response.statusCode == 200 && response.data['ok'] == true) {
        return Map<String, dynamic>.from(response.data['data'] as Map);
      }
    } catch (e) {
      AppLogger.warning('Product API unavailable ($e).');
    }
    return {};
  }
}
