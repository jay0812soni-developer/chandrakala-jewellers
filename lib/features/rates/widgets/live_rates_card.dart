import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../bloc/rates_bloc.dart';
import '../bloc/rates_event.dart';
import '../bloc/rates_state.dart';

class LiveRatesCard extends StatelessWidget {
  const LiveRatesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RatesBloc, RatesState>(
      listenWhen: (previous, current) => current is RatesError,
      listener: (context, state) {
        if (state is RatesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load live rates: ${state.message}'),
              action: SnackBarAction(
                label: 'Retry',
                textColor: AppColors.primaryGold,
                onPressed: () => context.read<RatesBloc>().add(const FetchRatesEvent()),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is RatesLoading) {
          return Container(
            height: 140,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.lightGold,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGold),
            ),
          );
        }

        final standard = state is RatesLoaded ? state.bundle.standard : null;

        final goldRate = standard?.goldRate ?? 15100.0;
        final silverRate = standard?.silverRate ?? 237.0;
        final silver925Rate = standard?.silver925Rate ?? 650.0;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFFDF5), Color(0xFFFAF6E9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.35)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGold.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGold.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.trending_up,
                          color: AppColors.darkGold,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "TODAY'S LIVE RATES",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                          color: AppColors.darkGold,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => context.read<RatesBloc>().add(const RefreshRatesEvent()),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.refresh, size: 18, color: AppColors.darkGold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildRatePill(
                      title: 'GOLD (1g)',
                      rate: CurrencyFormatter.format(goldRate),
                      subtitle: '22K Hallmark',
                      accentColor: AppColors.primaryGold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildRatePill(
                      title: 'SILVER (1g)',
                      rate: CurrencyFormatter.format(silverRate),
                      subtitle: 'Pure 99.9%',
                      accentColor: AppColors.silver,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildRatePill(
                      title: '925 SILVER',
                      rate: CurrencyFormatter.format(silver925Rate),
                      subtitle: 'Fine Silver',
                      accentColor: AppColors.darkGold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRatePill({
    required String title,
    required String rate,
    required String subtitle,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            rate,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 9,
              color: accentColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
