import 'package:equatable/equatable.dart';
import '../../../core/constants/app_constants.dart';

class JewelleryItem extends Equatable {
  final int id;
  final String name;
  final String image;
  final String description;
  final String purity;
  final String stone;
  final String category;
  final String sku;
  final String dimensions;
  final double weight;
  final double cachedPrice;
  final String metalType;
  final double? manualPrice;
  final bool isFavourite;
  final bool isSoldOut;
  final bool useManualRates;
  final DateTime createdAt;

  const JewelleryItem({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.purity,
    required this.stone,
    required this.category,
    required this.sku,
    required this.dimensions,
    required this.weight,
    required this.cachedPrice,
    required this.metalType,
    this.manualPrice,
    required this.isFavourite,
    required this.isSoldOut,
    required this.useManualRates,
    required this.createdAt,
  });

  String get fullImageUrl {
    if (image.isEmpty) return '';
    if (image.startsWith('http://') || image.startsWith('https://')) return image;
    return '${AppConstants.cdnBaseUrl}$image';
  }

  factory JewelleryItem.fromJson(Map<String, dynamic> json) {
    return JewelleryItem(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      purity: json['purity']?.toString() ?? '',
      stone: json['stone']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      dimensions: json['dimensions']?.toString() ?? '',
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      cachedPrice: (json['cached_price'] as num?)?.toDouble() ?? 0.0,
      metalType: json['metal_type']?.toString() ?? 'gold',
      manualPrice: (json['manual_price'] as num?)?.toDouble(),
      isFavourite: json['is_favourite'] == true || json['is_favourite'] == 1,
      isSoldOut: json['is_sold_out'] == true || json['is_sold_out'] == 1,
      useManualRates: json['use_manual_rates'] == true || json['use_manual_rates'] == 1,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now() : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        purity,
        category,
        weight,
        cachedPrice,
        metalType,
        isSoldOut,
      ];
}
