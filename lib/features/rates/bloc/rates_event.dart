import 'package:equatable/equatable.dart';

abstract class RatesEvent extends Equatable {
  const RatesEvent();
  @override
  List<Object?> get props => [];
}

class FetchRatesEvent extends RatesEvent {
  const FetchRatesEvent();
}

class RefreshRatesEvent extends RatesEvent {
  const RefreshRatesEvent();
}
