import 'package:equatable/equatable.dart';

abstract class CatalogueEvent extends Equatable {
  const CatalogueEvent();
  @override
  List<Object?> get props => [];
}

class LoadCatalogueEvent extends CatalogueEvent {
  final String? category;
  const LoadCatalogueEvent({this.category});

  @override
  List<Object?> get props => [category];
}
