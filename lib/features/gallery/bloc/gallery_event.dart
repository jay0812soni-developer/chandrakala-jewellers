import 'package:equatable/equatable.dart';

abstract class GalleryEvent extends Equatable {
  const GalleryEvent();
  @override
  List<Object?> get props => [];
}

class LoadGalleryEvent extends GalleryEvent {
  final String metalType;
  final String? category;
  final String? search;
  final String sort;

  const LoadGalleryEvent({
    this.metalType = 'all',
    this.category,
    this.search,
    this.sort = 'newest',
  });

  @override
  List<Object?> get props => [metalType, category, search, sort];
}

class ChangeMetalFilterEvent extends GalleryEvent {
  final String metalType;
  const ChangeMetalFilterEvent(this.metalType);

  @override
  List<Object?> get props => [metalType];
}

class SearchGalleryEvent extends GalleryEvent {
  final String query;
  const SearchGalleryEvent(this.query);

  @override
  List<Object?> get props => [query];
}
