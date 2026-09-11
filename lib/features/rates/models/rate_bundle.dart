import 'package:equatable/equatable.dart';

class MetalRate extends Equatable {
  final double goldRate;
  final double silverRate;
  final double silver925Rate;
  final double copperRate;
  final double makingChargesPercent;
  final bool applyMakingToSilver;
  final DateTime updatedAt;

  const MetalRate({
    required this.goldRate,
    required this.silverRate,
    required this.silver925Rate,
    required this.copperRate,
    required this.makingChargesPercent,
    required this.applyMakingToSilver,
    required this.updatedAt,
  });

  factory MetalRate.fromJson(Map<String, dynamic> json) {
    return MetalRate(
      goldRate: (json['gold_rate'] as num?)?.toDouble() ?? 0.0,
      silverRate: (json['silver_rate'] as num?)?.toDouble() ?? 0.0,
      silver925Rate: (json['silver_925_rate'] as num?)?.toDouble() ?? 0.0,
      copperRate: (json['copper_rate'] as num?)?.toDouble() ?? 0.0,
      makingChargesPercent: (json['making_charges_percent'] as num?)?.toDouble() ?? 0.0,
      applyMakingToSilver: json['apply_making_to_silver'] == true || json['apply_making_to_silver'] == 1,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now() : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        goldRate,
        silverRate,
        silver925Rate,
        copperRate,
        makingChargesPercent,
        applyMakingToSilver,
        updatedAt,
      ];
}

class RateBundle extends Equatable {
  final MetalRate standard;
  final MetalRate manual;
  final Map<String, dynamic> formula;

  const RateBundle({
    required this.standard,
    required this.manual,
    required this.formula,
  });

  factory RateBundle.fromJson(Map<String, dynamic> json) {
    return RateBundle(
      standard: MetalRate.fromJson(json['standard'] as Map<String, dynamic>? ?? {}),
      manual: MetalRate.fromJson(json['manual'] as Map<String, dynamic>? ?? {}),
      formula: json['formula'] as Map<String, dynamic>? ?? {},
    );
  }

  @override
  List<Object?> get props => [standard, manual, formula];
}
