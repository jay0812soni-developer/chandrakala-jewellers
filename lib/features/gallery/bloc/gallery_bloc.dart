import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/gallery_repository.dart';
import 'gallery_event.dart';
import 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GalleryRepository repository;

  GalleryBloc({required this.repository}) : super(const GalleryInitial()) {
    on<LoadGalleryEvent>(_onLoadGallery);
    on<ChangeMetalFilterEvent>(_onChangeMetalFilter);
    on<SearchGalleryEvent>(_onSearchGallery);
  }

  Future<void> _onLoadGallery(
    LoadGalleryEvent event,
    Emitter<GalleryState> emit,
  ) async {
    emit(const GalleryLoading());
    try {
      final items = await repository.getItems(
        metalType: event.metalType,
        category: event.category,
        search: event.search,
        sort: event.sort,
      );
      emit(GalleryLoaded(
        items: items,
        activeMetal: event.metalType,
        activeCategory: event.category,
        searchQuery: event.search ?? '',
      ));
    } catch (e) {
      emit(GalleryError(e.toString()));
    }
  }

  Future<void> _onChangeMetalFilter(
    ChangeMetalFilterEvent event,
    Emitter<GalleryState> emit,
  ) async {
    final currentQuery = state is GalleryLoaded ? (state as GalleryLoaded).searchQuery : '';
    final currentCat = state is GalleryLoaded ? (state as GalleryLoaded).activeCategory : null;

    emit(const GalleryLoading());
    try {
      final items = await repository.getItems(
        metalType: event.metalType,
        category: currentCat,
        search: currentQuery,
      );
      emit(GalleryLoaded(
        items: items,
        activeMetal: event.metalType,
        activeCategory: currentCat,
        searchQuery: currentQuery,
      ));
    } catch (e) {
      emit(GalleryError(e.toString()));
    }
  }

  Future<void> _onSearchGallery(
    SearchGalleryEvent event,
    Emitter<GalleryState> emit,
  ) async {
    final currentMetal = state is GalleryLoaded ? (state as GalleryLoaded).activeMetal : 'all';
    final currentCat = state is GalleryLoaded ? (state as GalleryLoaded).activeCategory : null;

    emit(const GalleryLoading());
    try {
      final items = await repository.getItems(
        metalType: currentMetal,
        category: currentCat,
        search: event.query,
      );
      emit(GalleryLoaded(
        items: items,
        activeMetal: currentMetal,
        activeCategory: currentCat,
        searchQuery: event.query,
      ));
    } catch (e) {
      emit(GalleryError(e.toString()));
    }
  }
}
