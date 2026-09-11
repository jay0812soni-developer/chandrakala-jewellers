import 'package:equatable/equatable.dart';
import '../../../core/constants/app_constants.dart';

class CatalogueItem extends Equatable {
  final int id;
  final String name;
  final String description;
  final String imageFilename;
  final String category;

  const CatalogueItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageFilename,
    required this.category,
  });

  String get fullImageUrl {
    if (imageFilename.isEmpty) return '';
    if (imageFilename.startsWith('http://') || imageFilename.startsWith('https://')) {
      return imageFilename;
    }
    return '${AppConstants.catalogueCdnUrl}$imageFilename';
  }

  factory CatalogueItem.fromJson(Map<String, dynamic> json) {
    return CatalogueItem(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageFilename: json['image_filename']?.toString() ?? '',
      category: json['category']?.toString() ?? 'custom',
    );
  }

  @override
  List<Object?> get props => [id, name, imageFilename, category];
}
