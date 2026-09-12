import 'package:equatable/equatable.dart';
import '../../../core/pricing/jewellery_price_engine.dart';
import '../models/rate_bundle.dart';

abstract class RatesState extends Equatable {
  const RatesState();

  double calculatePrice(String metalType, double weightGrams) => 0.0;

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
  double calculatePrice(String metalType, double weightGrams) {
    return JewelleryPriceEngine.calculatePrice(
      metalType: metalType,
      weightGrams: weightGrams,
      goldRatePerGram: bundle.standard.goldRate,
      silverRatePerGram: bundle.standard.silverRate,
      silver925RatePerGram: bundle.standard.silver925Rate,
      makingChargesPercent: bundle.standard.makingChargesPercent,
      applyMakingToSilver: bundle.standard.applyMakingToSilver,
    );
  }

  @override
  List<Object?> get props => [bundle];
}

class RatesError extends RatesState {
  final String message;
  const RatesError(this.message);

  @override
  List<Object?> get props => [message];
}
