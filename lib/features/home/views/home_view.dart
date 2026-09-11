import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../gallery/bloc/gallery_bloc.dart';
import '../../gallery/bloc/gallery_state.dart';
import '../../gallery/widgets/jewellery_card.dart';
import '../../rates/widgets/live_rates_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  void _callStore() async {
    final url = Uri.parse('tel:${AppConstants.shopPhoneDisplay}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _chatWhatsApp() async {
    final url = Uri.parse('https://wa.me/${AppConstants.shopWhatsAppNumber}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              'CHANDRAKALA',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              'JEWELLERS • KHEDBRAHMA',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () => context.push('/cart'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Greeting & Location Banner
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Namaste 🙏',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      Text(
                        'Explore timeless 916 gold & silver designs',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.phone_outlined, color: AppColors.darkGold),
                        onPressed: _callStore,
                      ),
                      IconButton(
                        icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF25D366)),
                        onPressed: _chatWhatsApp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Live Daily Rates Board
          const SliverToBoxAdapter(
            child: LiveRatesCard(),
          ),

          // Category Quick Shortcuts
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: _buildNavButton(
                      context: context,
                      label: 'Ready Stock',
                      icon: Icons.diamond_outlined,
                      color: AppColors.primaryGold,
                      onTap: () => context.push('/gallery'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildNavButton(
                      context: context,
                      label: 'Design Catalogue',
                      icon: Icons.auto_stories_outlined,
                      color: AppColors.darkGold,
                      onTap: () => context.push('/catalogue'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Section Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'FEATURED PIECES',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1.0),
                  ),
                  TextButton(
                    onPressed: () => context.push('/gallery'),
                    child: const Text('View All', style: TextStyle(color: AppColors.darkGold, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),

          // Featured Items Grid
          BlocBuilder<GalleryBloc, GalleryState>(
            builder: (context, state) {
              if (state is GalleryLoading) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(color: AppColors.primaryGold),
                    ),
                  ),
                );
              }

              if (state is GalleryLoaded) {
                final items = state.items.take(4).toList();

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.68,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = items[index];
                        return JewelleryCard(
                          item: item,
                          onTap: () => context.push('/product/${item.id}', extra: item),
                        );
                      },
                      childCount: items.length,
                    ),
                  ),
                );
              }

              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
