import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../rates/widgets/live_rates_card.dart';

class GoldRateView extends StatelessWidget {
  const GoldRateView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      currentRoute: '/gold-rate-khedbrahma',
      title: 'Gold Rate Khedbrahma',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1E212B), const Color(0xFF14161D)]
                      : [AppColors.lightGold, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'LIVE PRECIOUS METALS',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.5,
                      color: isDark ? const Color(0xFFF0D78C) : AppColors.darkGold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gold Rate & 916 Gold Jewellery in Khedbrahma',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Shop 22K gold with clear pricing at ChandraKala Jewellers — Civil Road, Sabarkantha.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isDark ? const Color(0xFFB5BAC6) : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: LiveRatesCard(),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Looking for today’s gold rate in Khedbrahma or a reliable place to buy 916 hallmark gold jewellery? ChandraKala Jewellers updates store rates regularly and displays them live on our platform.',
                      style: GoogleFonts.poppins(fontSize: 15, height: 1.7),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Browse our wide catalogue of rings, necklaces, bangles, and bridal ornaments in stock, request a custom design from our catalogue, or visit our showroom opposite Bhoomi Complex on Civil Road, Khedbrahma.',
                      style: GoogleFonts.poppins(fontSize: 15, height: 1.7),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => context.go('/gallery'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGold,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          icon: const Icon(Icons.storefront_outlined, size: 18),
                          label: const Text('Shop Gold Jewellery'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => context.go('/catalogue'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isDark ? const Color(0xFFF0D78C) : AppColors.darkGold,
                            side: BorderSide(color: AppColors.primaryGold.withAlpha(120)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          icon: const Icon(Icons.grid_view_rounded, size: 18),
                          label: const Text('View Design Catalogue'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1F2430) : AppColors.champagne,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primaryGold.withAlpha(60)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.phone_in_talk_rounded, color: AppColors.darkGold),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Call ${AppConstants.shopPhoneDisplay} for today\'s rate confirmation before purchase.',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final uri = Uri.parse('tel:${AppConstants.shopPhoneDisplay}');
                              if (await canLaunchUrl(uri)) launchUrl(uri);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkGold,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            ),
                            child: const Text('Call Now'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
