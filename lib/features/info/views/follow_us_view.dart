import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_scaffold.dart';

class FollowUsView extends StatelessWidget {
  const FollowUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: '/follow-us',
      title: 'Follow Us & Reviews',
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.lightGold, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    'Follow ChandraKala Jewellers',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Instagram updates, Google reviews, and direct QR links — from Civil Road, Khedbrahma.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Instagram Card
                    _buildInstagramSection(context),

                    const SizedBox(height: 24),

                    // Google Reviews Card
                    _buildGoogleReviewsSection(),

                    const SizedBox(height: 24),

                    // QR Codes & Shareables
                    _buildQrSection(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstagramSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(6), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFFCB045)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'INSTAGRAM',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.darkGold, letterSpacing: 1),
                  ),
                  Text(
                    '@chandra.kalajewellers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'See hallmark jewellery pieces, festive bridal looks, making videos, and behind-the-counter craft from ChandraKala Jewellers. Tap follow to stay updated with newest designs.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse('https://www.instagram.com/chandra.kalajewellers');
                  if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: const Text('Open Instagram'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE1306C),
                  foregroundColor: Colors.white,
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => context.go('/gallery'),
                icon: const Icon(Icons.storefront_outlined, size: 16, color: AppColors.darkGold),
                label: const Text('Visit Shop', style: TextStyle(color: AppColors.darkGold)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primaryGold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleReviewsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF4285F4).withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.star_rounded, color: Color(0xFF4285F4), size: 28),
              ),
              const SizedBox(width: 14),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GOOGLE BUSINESS',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF4285F4), letterSpacing: 1),
                  ),
                  Text(
                    'Rate ChandraKala Jewellers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Share your showroom experience on Google — your reviews help families across Khedbrahma and Sabarkantha find trusted 916 gold and silver jewellery.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse('https://g.page/r/CWqeb0I3tG0hEAI/review');
                  if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                icon: const Icon(Icons.rate_review_rounded, size: 16),
                label: const Text('Leave a Google Review'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4285F4),
                  foregroundColor: Colors.white,
                ),
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse('https://www.google.co.in/search?kgmid=/g/11q360mjpq&q=Chandrakala+jewellers');
                  if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                icon: const Icon(Icons.business_rounded, size: 16, color: Color(0xFF4285F4)),
                label: const Text('View Google Profile', style: TextStyle(color: Color(0xFF4285F4))),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFF4285F4))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQrSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.champagne,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGold.withAlpha(100)),
      ),
      child: Column(
        children: [
          const Icon(Icons.qr_code_scanner_rounded, color: AppColors.darkGold, size: 36),
          const SizedBox(height: 10),
          const Text(
            'Official QR Codes',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Scan with your phone camera to quickly open our official website, leave a Google review, or browse designs.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Column(
              children: [
                Icon(Icons.qr_code_2_rounded, size: 100, color: AppColors.textPrimary),
                SizedBox(height: 8),
                Text(
                  'chandrakalajewellers.in',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.darkGold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
