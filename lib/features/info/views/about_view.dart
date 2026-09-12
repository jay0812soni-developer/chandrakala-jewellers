import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_scaffold.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: '/about',
      title: 'About Us',
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
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryGold, width: 2),
                      color: AppColors.champagne,
                    ),
                    child: const Center(
                      child: Text(
                        'CJ',
                        style: TextStyle(
                          color: AppColors.darkGold,
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'About ChandraKala Jewellers',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Gold and silver, crafted with care in Khedbrahma — your neighbourhood jewellers on Civil Road.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 760),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Our Heritage & Craftsmanship',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'ChandraKala Jewellers (also known as Chandrakala Jewellers) is a family-owned jewellery store in Khedbrahma, Sabarkantha, Gujarat. Customers across Civil Road, nearby villages, Idar and Himmatnagar visit us for 916 gold, silver and 925 silver jewellery with clear pricing based on today\'s live rates.\n\nWe believe jewellery should feel personal — from everyday wear to wedding sets and custom designs from our catalogue. Order online and confirm on WhatsApp, or walk into our showroom opposite Bhoomi Complex.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.7,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 4 Stat Cards
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 2.2,
                      children: [
                        _buildStatCard('Family', 'Owned & Run'),
                        _buildStatCard('916', 'Gold Hallmark'),
                        _buildStatCard('Care', 'Custom Designs'),
                        _buildStatCard('Local', 'Khedbrahma Store'),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Why locals choose us
                    const Text(
                      'Why Locals Choose Us',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildFeatureItem(Icons.verified_outlined, 'Transparent 916 gold & silver rates updated regularly with bullion market.'),
                    _buildFeatureItem(Icons.diamond_outlined, 'Extensive selection of 916 gold, silver, and 925 sterling designs in stock.'),
                    _buildFeatureItem(Icons.design_services_outlined, 'Custom bridal and heirloom design references via our design catalogue.'),
                    _buildFeatureItem(Icons.chat_bubble_outline_rounded, 'Direct WhatsApp ordering and prompt assistance at +91 9427080359.'),
                    _buildFeatureItem(Icons.pin_drop_outlined, 'Convenient location opposite Bhoomi Complex on Civil Road, Khedbrahma.'),

                    const SizedBox(height: 32),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => context.go('/gallery'),
                            icon: const Icon(Icons.storefront_outlined, size: 18),
                            label: const Text('Shop Jewellery'),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => context.go('/contact'),
                            icon: const Icon(Icons.location_on_outlined, size: 18, color: AppColors.darkGold),
                            label: const Text('Visit & Contact', style: TextStyle(color: AppColors.darkGold)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primaryGold),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.champagne,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGold.withAlpha(90)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'serif',
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: AppColors.darkGold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.darkGold, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
