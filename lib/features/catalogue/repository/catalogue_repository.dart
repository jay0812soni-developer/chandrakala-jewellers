import '../../../core/network/api_client.dart';
import '../../../core/services/logger_service.dart';
import '../models/catalogue_item.dart';

class CatalogueRepository {
  final ApiClient _client = ApiClient();

  static final List<CatalogueItem> _fallbackCatalogue = [
    const CatalogueItem(
      id: 161,
      name: 'Royal Kundan Choker Design',
      description: 'Handcrafted traditional bridal choker concept with precious stones.',
      imageFilename: 'jewellery_6a72cfeba28383.08197860.jpg',
      category: 'Choker',
    ),
    const CatalogueItem(
      id: 162,
      name: 'Antique Temple Jhumka Design',
      description: 'South Indian antique temple design featuring Goddess Lakshmi motif.',
      imageFilename: 'jewellery_6a72cfeba37d68.10630799.jpg',
      category: 'Earrings',
    ),
    const CatalogueItem(
      id: 163,
      name: 'Floral Diamond Dokiya Concept',
      description: 'Lightweight gold and CZ studded tanmaniya dokiya for daily wear.',
      imageFilename: 'jewellery_6a72cfeba3c762.10799803.jpg',
      category: 'Pendant',
    ),
  ];

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
        return list.map((json) => CatalogueItem.fromJson(json)).toList();
      }
    } catch (e) {
      AppLogger.warning(
        'Backend catalogue API unreachable ($e). Serving local cached CJ designs.',
      );
    }
    return _fallbackCatalogue;
  }
}
