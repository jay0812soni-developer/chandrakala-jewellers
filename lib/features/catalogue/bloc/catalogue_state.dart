import 'package:equatable/equatable.dart';
import '../models/catalogue_item.dart';

abstract class CatalogueState extends Equatable {
  const CatalogueState();
  @override
  List<Object?> get props => [];
}

class CatalogueInitial extends CatalogueState {
  const CatalogueInitial();
}

class CatalogueLoading extends CatalogueState {
  const CatalogueLoading();
}

class CatalogueLoaded extends CatalogueState {
  final List<CatalogueItem> items;
  const CatalogueLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class CatalogueError extends CatalogueState {
  final String message;
  const CatalogueError(this.message);

  @override
  List<Object?> get props => [message];
}
