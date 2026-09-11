import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/catalogue_repository.dart';
import 'catalogue_event.dart';
import 'catalogue_state.dart';

class CatalogueBloc extends Bloc<CatalogueEvent, CatalogueState> {
  final CatalogueRepository repository;

  CatalogueBloc({required this.repository}) : super(const CatalogueInitial()) {
    on<LoadCatalogueEvent>(_onLoadCatalogue);
  }

  Future<void> _onLoadCatalogue(
    LoadCatalogueEvent event,
    Emitter<CatalogueState> emit,
  ) async {
    emit(const CatalogueLoading());
    try {
      final items = await repository.getCatalogueItems(category: event.category);
      emit(CatalogueLoaded(items));
    } catch (e) {
      emit(CatalogueError(e.toString()));
    }
  }
}
