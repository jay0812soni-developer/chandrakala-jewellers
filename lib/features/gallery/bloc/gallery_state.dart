import 'package:equatable/equatable.dart';
import '../models/jewellery_item.dart';

abstract class GalleryState extends Equatable {
  const GalleryState();
  @override
  List<Object?> get props => [];
}

class GalleryInitial extends GalleryState {
  const GalleryInitial();
}

class GalleryLoading extends GalleryState {
  const GalleryLoading();
}

class GalleryLoaded extends GalleryState {
  final List<JewelleryItem> items;
  final String activeMetal;
  final String? activeCategory;
  final String searchQuery;

  const GalleryLoaded({
    required this.items,
    this.activeMetal = 'all',
    this.activeCategory,
    this.searchQuery = '',
  });

  GalleryLoaded copyWith({
    List<JewelleryItem>? items,
    String? activeMetal,
    String? activeCategory,
    String? searchQuery,
  }) {
    return GalleryLoaded(
      items: items ?? this.items,
      activeMetal: activeMetal ?? this.activeMetal,
      activeCategory: activeCategory ?? this.activeCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [items, activeMetal, activeCategory, searchQuery];
}

class GalleryError extends GalleryState {
  final String message;
  const GalleryError(this.message);

  @override
  List<Object?> get props => [message];
}
