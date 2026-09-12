import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_scaffold.dart';

class JewellersInKhedbrahmaView extends StatelessWidget {
  const JewellersInKhedbrahmaView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      currentRoute: '/jewellers-in-khedbrahma',
      title: 'Jewellers in Khedbrahma',
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
                    'LOCAL SHOWROOM DIRECTORY',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.5,
                      color: isDark ? const Color(0xFFF0D78C) : AppColors.darkGold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Jewellers in Khedbrahma — ChandraKala Jewellers',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your local gold & silver jewellery shop on Civil Road, Sabarkantha. Search “jewellers near me” in Khedbrahma and find Chandrakala Jewellers on Google Maps.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isDark ? const Color(0xFFB5BAC6) : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'If you searched for jewellers, jewellery, Chandrakala, ChandraKala Jewellers, or jewellers near me looking for a showroom in Khedbrahma, you are in the right place.',
                      style: GoogleFonts.poppins(fontSize: 15, height: 1.7),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Gold & Silver Jewellery Store in Khedbrahma',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFFF0D78C) : AppColors.darkGold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ChandraKala Jewellers stocks 916 gold jewellery, fine silver jewellery, and 925 sterling silver with prices linked directly to live metal rates. Browse our full online shop or our bespoke custom design catalogue.',
                      style: GoogleFonts.poppins(fontSize: 14, height: 1.6),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Store Location & Directions',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFFF0D78C) : AppColors.darkGold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF161A22) : const Color(0xFFFAF9F6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? const Color(0xFF2E3544) : AppColors.primaryGold.withAlpha(60),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ChandraKala Jewellers',
                            style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text('Opp. Bhoomi Complex, Civil Road'),
                          const Text('22JW+HG9, Khedbrahma-383255, Sabarkantha, Gujarat'),
                          const SizedBox(height: 8),
                          Text('Phone: ${AppConstants.shopPhoneDisplay}'),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final uri = Uri.parse(AppConstants.googleMapsUrl);
                                  if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryGold,
                                  foregroundColor: Colors.white,
                                ),
                                icon: const Icon(Icons.navigation_outlined, size: 16),
                                label: const Text('Get Google Maps Directions'),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => context.go('/contact'),
                                icon: const Icon(Icons.contact_mail_outlined, size: 16),
                                label: const Text('Contact Page'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Serving Sabarkantha & Nearby Areas',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFFF0D78C) : AppColors.darkGold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Customers visit us from Khedbrahma town, surrounding villages, and nearby centres including Idar and Himmatnagar for wedding jewellery, daily wear, gifts, and custom heirloom pieces.',
                      style: GoogleFonts.poppins(fontSize: 14, height: 1.6),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'How to Buy',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFFF0D78C) : AppColors.darkGold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildStep(number: '1', title: 'Shop Online', desc: 'Browse our real-time stock catalogue on this app/site.'),
                    _buildStep(number: '2', title: 'Add to Cart or Buy Now', desc: 'Select items or configure weights and quantities.'),
                    _buildStep(number: '3', title: 'Confirm via WhatsApp', desc: 'Send order directly to +91 9427080359 for instant reservation.'),
                    _buildStep(number: '4', title: 'Visit Showroom or Home Delivery', desc: 'Pickup opposite Bhoomi Complex or receive fast delivery.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({required String number, required String title, required String desc}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.primaryGold,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
