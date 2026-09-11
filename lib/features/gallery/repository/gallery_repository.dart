import '../../../core/network/api_client.dart';
import '../../../core/services/logger_service.dart';
import '../models/jewellery_item.dart';

class GalleryRepository {
  final ApiClient _client = ApiClient();

  // In-stock items fallback from ChandraKala Jewellers store
  static final List<JewelleryItem> _fallbackItems = [
    JewelleryItem(
      id: 110,
      name: 'Pendent Butti Set',
      image: 'item_6a72eda95a8789.42699417.jpg',
      description: 'New design handcrafted to order in 22K, 20K, and 18K hallmark gold.',
      purity: '22K 916',
      stone: 'Cubic Zirconia',
      category: 'Necklace Sets',
      sku: 'CJ-G-110',
      dimensions: 'Medium',
      weight: 11.640,
      cachedPrice: 224977.92,
      metalType: 'gold',
      isFavourite: true,
      isSoldOut: false,
      useManualRates: false,
      createdAt: DateTime.now(),
    ),
    JewelleryItem(
      id: 109,
      name: 'Gold Set with Earrings',
      image: 'item_6a72ed6a62cde2.58667970.jpg',
      description: 'Exquisite bridal necklace set with matching butti in 916 gold.',
      purity: '22K 916',
      stone: 'Kundan',
      category: 'Bridal Sets',
      sku: 'CJ-G-109',
      dimensions: 'Large',
      weight: 22.210,
      cachedPrice: 349390.17,
      metalType: 'gold',
      isFavourite: true,
      isSoldOut: false,
      useManualRates: false,
      createdAt: DateTime.now(),
    ),
    JewelleryItem(
      id: 108,
      name: 'Chain with Pearl',
      image: 'item_6a72ecafaab347.25954770.jpg',
      description: 'Elegant 916 yellow gold chain adorned with natural cultured pearls.',
      purity: '22K 916',
      stone: 'Pearl',
      category: 'Chains',
      sku: 'CJ-G-108',
      dimensions: '18 inches',
      weight: 7.000,
      cachedPrice: 135296.00,
      metalType: 'gold',
      isFavourite: true,
      isSoldOut: false,
      useManualRates: false,
      createdAt: DateTime.now(),
    ),
    JewelleryItem(
      id: 85,
      name: '925 Silver Folding Ring',
      image: 'item_68c250db9ca9d1.78704969.jpg',
      description: 'Dual-style folding ring crafted in fine 925 sterling silver.',
      purity: '925 Silver',
      stone: 'American Diamond',
      category: 'Rings',
      sku: 'CJ-S-085',
      dimensions: 'Adjustable',
      weight: 5.400,
      cachedPrice: 3920.40,
      metalType: 'silver_925',
      isFavourite: true,
      isSoldOut: false,
      useManualRates: false,
      createdAt: DateTime.now(),
    ),
    JewelleryItem(
      id: 64,
      name: 'Silver Fancy Kada',
      image: 'IMG_1395.jpeg',
      description: 'Heavy traditional solid gents silver kada with delicate carvings.',
      purity: '99.9% Silver',
      stone: 'None',
      category: 'Kada',
      sku: 'CJ-S-064',
      dimensions: 'Size 2.8',
      weight: 31.800,
      cachedPrice: 9811.89,
      metalType: 'silver',
      isFavourite: false,
      isSoldOut: false,
      useManualRates: false,
      createdAt: DateTime.now(),
    ),
  ];

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
        return list.map((json) => JewelleryItem.fromJson(json)).toList();
      }
    } catch (e) {
      AppLogger.warning(
        'Backend inventory API unreachable ($e). Serving local cached CJ pieces.',
      );
    }

    // Filter fallback items client-side
    var filtered = _fallbackItems;
    if (metalType != 'all') {
      filtered = filtered.where((item) => item.metalType == metalType).toList();
    }
    if (search != null && search.trim().isNotEmpty) {
      final query = search.trim().toLowerCase();
      filtered = filtered
          .where((item) =>
              item.name.toLowerCase().contains(query) ||
              item.description.toLowerCase().contains(query))
          .toList();
    }
    return filtered;
  }

  Future<Map<String, dynamic>> getItemDetails(int id) async {
    try {
      final response = await _client.dio.get('/inventory/$id');
      if (response.statusCode == 200 && response.data['ok'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      }
    } catch (e) {
      AppLogger.warning('Item details API unreachable ($e). Serving cached item.');
    }
    final match = _fallbackItems.firstWhere(
      (item) => item.id == id,
      orElse: () => _fallbackItems.first,
    );
    return {
      'id': match.id,
      'name': match.name,
      'image': match.image,
      'description': match.description,
      'purity': match.purity,
      'stone': match.stone,
      'category': match.category,
      'sku': match.sku,
      'dimensions': match.dimensions,
      'weight': match.weight,
      'cached_price': match.cachedPrice,
      'metal_type': match.metalType,
      'is_favourite': match.isFavourite,
      'is_sold_out': match.isSoldOut,
      'extra_images': [],
      'reviews': [],
    };
  }
}
