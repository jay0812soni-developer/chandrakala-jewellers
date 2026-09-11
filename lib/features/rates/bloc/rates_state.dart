import 'package:equatable/equatable.dart';
import '../models/rate_bundle.dart';

abstract class RatesState extends Equatable {
  const RatesState();
  @override
  List<Object?> get props => [];
}

class RatesInitial extends RatesState {
  const RatesInitial();
}

class RatesLoading extends RatesState {
  const RatesLoading();
}

class RatesLoaded extends RatesState {
  final RateBundle bundle;
  const RatesLoaded(this.bundle);

  @override
  List<Object?> get props => [bundle];
}

class RatesError extends RatesState {
  final String message;
  const RatesError(this.message);

  @override
  List<Object?> get props => [message];
}
