import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/cj_image.dart';
import '../../blog/models/blog_post.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../gallery/bloc/gallery_bloc.dart';
import '../../gallery/bloc/gallery_state.dart';
import '../../gallery/models/jewellery_item.dart';
import '../../rates/bloc/rates_bloc.dart';
import '../../rates/bloc/rates_state.dart';
import '../../rates/widgets/live_rates_card.dart';
import '../../wishlist/bloc/wishlist_bloc.dart';
import '../../wishlist/bloc/wishlist_event.dart';
import '../../wishlist/bloc/wishlist_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const List<Map<String, String>> _faqs = [
    {
      'q': 'Where is ChandraKala Jewellers located in Khedbrahma?',
      'a': 'ChandraKala Jewellers is at Opp. Bhoomi Complex, Civil Road, 22JW+HG9, Khedbrahma-383255, Sabarkantha, Gujarat. Coordinates: 24.0314016, 73.0463503. Call +91 9427080359 for directions.',
    },
    {
      'q': 'Who is the best jeweller in Khedbrahma?',
      'a': 'ChandraKala Jewellers is a trusted family-owned jewellery store in Khedbrahma offering 916 gold, silver, and 925 silver jewellery with transparent live rates, custom designs, and WhatsApp ordering.',
    },
    {
      'q': 'Do you sell gold and silver jewellery in Khedbrahma?',
      'a': 'Yes. We sell 916 (22K) gold jewellery, silver jewellery, and 925 sterling silver designs with clear pricing based on today\'s metal rates at our Civil Road showroom.',
    },
    {
      'q': 'What is today\'s gold rate at ChandraKala Jewellers?',
      'a': 'We publish our latest 916 gold rate per gram on our live rates board. Rates are updated regularly so shoppers across Khedbrahma, Idar, and Himmatnagar can buy with confidence.',
    },
    {
      'q': 'Can I order jewellery on WhatsApp from ChandraKala Jewellers?',
      'a': 'Yes. Browse our shop or catalogue online, then use Cart Checkout or WhatsApp button to send an order request to +91 9427080359 for confirmation and guidance.',
    },
    {
      'q': 'Do you offer custom jewellery designs in Sabarkantha?',
      'a': 'Yes. Browse our Design Catalogue for reference photos and visit the store or message WhatsApp for custom bridal and heirloom gold jewellery crafted in Khedbrahma.',
    },
    {
      'q': 'What are ChandraKala Jewellers opening hours?',
      'a': 'We are open Monday to Saturday, 10:00 AM to 8:00 PM. Call +91 9427080359 before visiting on holidays.',
    },
    {
      'q': 'Is Chandrakala Jewellers the same as ChandraKala Jewellers?',
      'a': 'Yes. ChandraKala Jewellers and Chandrakala Jewellers refer to the same jewellery store on Civil Road, Khedbrahma.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return AppScaffold(
      currentRoute: '/',
      body: CustomScrollView(
        slivers: [
          // Namaste Greeting Banner matching index1.php
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.lightGold, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'WELCOME',
                              style: TextStyle(
                                color: AppColors.darkGold,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text('✨', style: TextStyle(fontSize: 12, color: AppColors.primaryGold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Namaste 🙏',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Explore handcrafted 916 gold & silver jewellery crafted with passion on Civil Road, Khedbrahma.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.champagne,
                        child: IconButton(
                          icon: const Icon(Icons.phone_in_talk_rounded, color: AppColors.darkGold, size: 20),
                          tooltip: 'Call Store',
                          onPressed: () async {
                            final uri = Uri.parse('tel:${AppConstants.shopPhoneDisplay}');
                            if (await canLaunchUrl(uri)) launchUrl(uri);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: const Color(0xFF25D366).withAlpha(30),
                        child: IconButton(
                          icon: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF25D366), size: 20),
                          tooltip: 'WhatsApp Concierge',
                          onPressed: () async {
                            final uri = Uri.parse('https://wa.me/${AppConstants.shopWhatsAppNumber}');
                            if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
                          },
                        ),
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

          // Action Shortcuts: Ready Stock & Catalogue
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: _buildShortcutButton(
                      context,
                      label: 'Shop Gallery',
                      subtitle: 'Ready Stock',
                      icon: Icons.storefront_outlined,
                      onTap: () => context.go('/gallery'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildShortcutButton(
                      context,
                      label: 'Design Catalogue',
                      subtitle: 'Bespoke Orders',
                      icon: Icons.grid_view_rounded,
                      onTap: () => context.go('/catalogue'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Section Header: Hot Favourite Items
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hot Favourite Items',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Handpicked pieces loved by our customers',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () => context.go('/gallery'),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.darkGold),
                    label: const Text('All Pieces', style: TextStyle(color: AppColors.darkGold, fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),

          // Hot Favourites Product Grid
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
                final favourites = state.items.where((i) => i.isFavourite).take(6).toList();
                final itemsToShow = favourites.isNotEmpty ? favourites : state.items.take(4).toList();

                return BlocBuilder<RatesBloc, RatesState>(
                  builder: (context, ratesState) {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 280,
                          mainAxisExtent: 380,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = itemsToShow[index];
                            final price = ratesState is RatesLoaded
                                ? ratesState.calculatePrice(item.metalType, item.weight)
                                : item.cachedPrice;

                            return _buildProductCard(context, item, price, currencyFormatter);
                          },
                          childCount: itemsToShow.length,
                        ),
                      ),
                    );
                  },
                );
              }

              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),

          // View Full Collection CTA
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/gallery'),
                  icon: const Icon(Icons.storefront_outlined, size: 16, color: AppColors.darkGold),
                  label: const Text('View Full Collection', style: TextStyle(color: AppColors.darkGold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primaryGold),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ),
          ),

          // About Section & Stats
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About ChandraKala Jewellers',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'We are a family-owned gold and silver jewellery store on Civil Road, Khedbrahma (Sabarkantha, Gujarat), dedicated to high-quality, handcrafted 916 gold and silver jewellery. Our passion for craftsmanship and attention to detail sets us apart.',
                    style: TextStyle(fontSize: 14, height: 1.5, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  // Stats Grid
                  Row(
                    children: [
                      Expanded(child: _buildHomeStat('Family', 'Owned & Run')),
                      const SizedBox(width: 10),
                      Expanded(child: _buildHomeStat('916', 'Gold Hallmark')),
                      const SizedBox(width: 10),
                      Expanded(child: _buildHomeStat('Care', 'Custom Designs')),
                      const SizedBox(width: 10),
                      Expanded(child: _buildHomeStat('Local', 'Khedbrahma')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/about'),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    label: const Text('Our Heritage Story'),
                  ),
                ],
              ),
            ),
          ),

          // Contact Cards Preview
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.champagne,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryGold.withAlpha(80)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Visit Our Showroom',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Opp. Bhoomi Complex, Civil Road, Khedbrahma-383255',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => context.go('/contact'),
                        icon: const Icon(Icons.directions_rounded, size: 16),
                        label: const Text('Store Info & Directions'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final uri = Uri.parse('https://wa.me/919427080359');
                          if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
                        },
                        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: Color(0xFF25D366)),
                        label: const Text('WhatsApp Us', style: TextStyle(color: AppColors.textPrimary)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF25D366)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Blog Previews Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From Our Blog',
                        style: TextStyle(
                          fontFamily: 'serif',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Care tips and jewellery advice from Khedbrahma',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => context.go('/blog'),
                    child: const Text('View All Posts', style: TextStyle(color: AppColors.darkGold, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),

          // Blog Posts Horizontal / Compact list
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final post = defaultBlogPosts.take(3).toList()[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      title: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.champagne,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              post.tag,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.darkGold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              post.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          post.excerpt,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.darkGold),
                      onTap: () => context.push('/blog/${post.slug}'),
                    ),
                  );
                },
                childCount: 3,
              ),
            ),
          ),

          // FAQ Section matching index1.php
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Quick answers about our jewellery store in Khedbrahma',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 14),
                  ..._faqs.map((faq) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ExpansionTile(
                      shape: const Border(),
                      collapsedShape: const Border(),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                      title: Text(
                        faq['q']!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      children: [
                        Text(
                          faq['a']!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),

          // Rich Luxury Footer matching includes/footer.php
          SliverToBoxAdapter(
            child: _buildFooter(context),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutButton(
    BuildContext context, {
    required String label,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppColors.champagne,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.darkGold, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textPrimary),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    JewelleryItem item,
    double price,
    NumberFormat currencyFormatter,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isDark ? const Color(0xFF2E3544) : AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                InkWell(
                  onTap: () => context.push('/product/${item.id}', extra: item),
                  child: CJImage(
                    imagePath: item.image,
                    fit: BoxFit.cover,
                  ),
                ),
                if (item.isSoldOut)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('Sold Out', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  )
                else
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.metalType == 'gold'
                            ? AppColors.primaryGold
                            : (item.metalType == 'silver_925' ? const Color(0xFF4A5568) : const Color(0xFF718096)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.metalType == 'gold' ? '916 GOLD' : (item.metalType == 'silver_925' ? '925 SILVER' : 'SILVER'),
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                // Wishlist Toggle Button
                Positioned(
                  top: 6,
                  right: 6,
                  child: BlocBuilder<WishlistBloc, WishlistState>(
                    builder: (context, wishState) {
                      final isSaved = wishState.isInWishlist(item.id);
                      return CircleAvatar(
                        backgroundColor: (isDark ? const Color(0xFF1F2430) : Colors.white).withAlpha(230),
                        radius: 16,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isSaved ? Colors.redAccent : (isDark ? Colors.white : Colors.black87),
                          ),
                          tooltip: isSaved ? 'Remove from wishlist' : 'Add to wishlist',
                          onPressed: () {
                            context.read<WishlistBloc>().add(ToggleWishlistEvent(item));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isSaved ? 'Removed from wishlist' : 'Saved to wishlist!'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.metalType.toUpperCase()} • ${item.weight.toStringAsFixed(2)} g',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 6),
                Text(
                  currencyFormatter.format(price),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? const Color(0xFFF0D78C) : AppColors.darkGold,
                  ),
                ),
                const SizedBox(height: 8),
                if (item.isSoldOut)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.push('/product/${item.id}', extra: item),
                      child: const Text('View Details', style: TextStyle(fontSize: 12)),
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<CartBloc>().add(AddToCartEvent(item));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added "${item.name}" to cart!'),
                                action: SnackBarAction(
                                  label: 'CART',
                                  textColor: AppColors.primaryGold,
                                  onPressed: () => context.go('/cart'),
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primaryGold),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                          ),
                          child: Text(
                            'Add Cart',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? const Color(0xFFF0D78C) : AppColors.darkGold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.push('/buynow', extra: item);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGold,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                          ),
                          child: const Text('Buy Now', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeStat(String val, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.champagne,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(val, style: const TextStyle(fontFamily: 'serif', fontWeight: FontWeight.w900, color: AppColors.darkGold, fontSize: 16)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 48),
      decoration: const BoxDecoration(
        color: Color(0xFF161822),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryGold, width: 1.5),
                  color: const Color(0xFF222634),
                ),
                child: const Center(
                  child: Text('CJ', style: TextStyle(color: AppColors.primaryGold, fontWeight: FontWeight.w900, fontSize: 14)),
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ChandraKala Jewellers',
                    style: TextStyle(fontFamily: 'serif', color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  Text('Elegance & Sparkle in Khedbrahma', style: TextStyle(color: AppColors.darkGold, fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Family-owned gold & silver jewellers in Khedbrahma, Sabarkantha. 916 gold, silver, custom designs & WhatsApp orders.',
            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFF2A2E3D), height: 1),
          const SizedBox(height: 20),

          // Quick Links
          Wrap(
            spacing: 16,
            runSpacing: 10,
            children: [
              _buildFooterLink(context, 'Home', '/'),
              _buildFooterLink(context, 'Shop Gallery', '/gallery'),
              _buildFooterLink(context, 'Design Catalogue', '/catalogue'),
              _buildFooterLink(context, 'Wishlist', '/wishlist'),
              _buildFooterLink(context, 'About Us', '/about'),
              _buildFooterLink(context, 'Contact & Maps', '/contact'),
              _buildFooterLink(context, 'Follow & Reviews', '/follow-us'),
              _buildFooterLink(context, 'Jewellery Care Blog', '/blog'),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFF2A2E3D), height: 1),
          const SizedBox(height: 20),

          // Visit Us & Socials
          const Text('Visit Us:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 6),
          const Text('Opp. Bhoomi Complex, Civil Road, 22JW+HG9, Khedbrahma-383255', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12)),
          const SizedBox(height: 10),
          Row(
            children: [
              InkWell(
                onTap: () async {
                  final uri = Uri.parse('https://www.instagram.com/chandra.kalajewellers');
                  if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                child: const Text('Instagram: @chandra.kalajewellers', style: TextStyle(color: AppColors.primaryGold, fontSize: 12)),
              ),
              const Text('  •  ', style: TextStyle(color: Colors.white24)),
              InkWell(
                onTap: () async {
                  final uri = Uri.parse('https://g.page/r/CWqeb0I3tG0hEAI/review');
                  if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
                },
                child: const Text('Google Reviews', style: TextStyle(color: AppColors.primaryGold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              '© ChandraKala Jewellers · chandrakalajewellers.in\nDesigned with elegance & passion.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF6B7280), fontSize: 11, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(BuildContext context, String label, String route) {
    return InkWell(
      onTap: () => context.go(route),
      child: Text(
        label,
        style: const TextStyle(color: Color(0xFFD1D5DB), fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }
}
