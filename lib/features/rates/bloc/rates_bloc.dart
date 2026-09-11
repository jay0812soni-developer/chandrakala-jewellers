import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/rates_repository.dart';
import 'rates_event.dart';
import 'rates_state.dart';

class RatesBloc extends Bloc<RatesEvent, RatesState> {
  final RatesRepository repository;

  RatesBloc({required this.repository}) : super(const RatesInitial()) {
    on<FetchRatesEvent>(_onFetchRates);
    on<RefreshRatesEvent>(_onRefreshRates);
  }

  Future<void> _onFetchRates(FetchRatesEvent event, Emitter<RatesState> emit) async {
    emit(const RatesLoading());
    try {
      final bundle = await repository.getLatestRates();
      emit(RatesLoaded(bundle));
    } catch (e) {
      emit(RatesError(e.toString()));
    }
  }

  Future<void> _onRefreshRates(RefreshRatesEvent event, Emitter<RatesState> emit) async {
    try {
      final bundle = await repository.getLatestRates();
      emit(RatesLoaded(bundle));
    } catch (e) {
      emit(RatesError(e.toString()));
    }
  }
}
