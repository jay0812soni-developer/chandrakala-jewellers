import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../../features/cart/bloc/cart_bloc.dart';
import '../../features/cart/bloc/cart_state.dart';
import '../../features/wishlist/bloc/wishlist_bloc.dart';
import '../../features/wishlist/bloc/wishlist_state.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String currentRoute;
  final String? title;
  final bool showBottomNav;

  const AppScaffold({
    super.key,
    required this.body,
    required this.currentRoute,
    this.title,
    this.showBottomNav = true,
  });

  int _getSelectedIndex() {
    if (currentRoute == '/') return 0;
    if (currentRoute.startsWith('/gallery')) return 1;
    if (currentRoute.startsWith('/catalogue')) return 2;
    if (currentRoute.startsWith('/contact')) return 3;
    if (currentRoute.startsWith('/cart')) return 4;
    return -1;
  }

  void _onBottomNavTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        if (currentRoute != '/') context.go('/');
        break;
      case 1:
        if (!currentRoute.startsWith('/gallery')) context.go('/gallery');
        break;
      case 2:
        if (!currentRoute.startsWith('/catalogue')) context.go('/catalogue');
        break;
      case 3:
        if (!currentRoute.startsWith('/contact')) context.go('/contact');
        break;
      case 4:
        if (!currentRoute.startsWith('/cart')) context.go('/cart');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex();

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
            tooltip: 'Navigation Menu',
          ),
        ),
        title: InkWell(
          onTap: () => context.go('/'),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.champagne,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryGold, width: 1.2),
                  ),
                  child: const Center(
                    child: Text(
                      'CJ',
                      style: TextStyle(
                        color: AppColors.darkGold,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title ?? 'ChandraKala',
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Text(
                      'Elegance & Sparkle',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          // Wishlist Action with live badge
          BlocBuilder<WishlistBloc, WishlistState>(
            builder: (context, state) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      state.count > 0 ? Icons.favorite : Icons.favorite_border_rounded,
                      color: state.count > 0 ? Colors.redAccent : AppColors.textPrimary,
                    ),
                    tooltip: 'Saved Wishlist',
                    onPressed: () => context.go('/wishlist'),
                  ),
                  if (state.count > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGold,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '${state.count}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          // Cart Action with live badge
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary),
                    tooltip: 'Shopping Cart',
                    onPressed: () => context.go('/cart'),
                  ),
                  if (state.itemCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGold,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '${state.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E212B), Color(0xFF14161D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryGold, width: 2),
                      color: const Color(0xFF2A2E3D),
                    ),
                    child: const Center(
                      child: Text(
                        'CJ',
                        style: TextStyle(
                          color: AppColors.primaryGold,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'ChandraKala Jewellers',
                    style: TextStyle(
                      fontFamily: 'serif',
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Opp. Bhoomi Complex, Civil Road, Khedbrahma',
                    style: TextStyle(
                      color: Color(0xFFD1D5DB),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.home_outlined,
                    label: 'Home',
                    route: '/',
                    isActive: currentRoute == '/',
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.storefront_outlined,
                    label: 'Shop Jewellery',
                    route: '/gallery',
                    isActive: currentRoute.startsWith('/gallery'),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.grid_view_rounded,
                    label: 'Design Catalogue',
                    route: '/catalogue',
                    isActive: currentRoute.startsWith('/catalogue'),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.favorite_border_rounded,
                    label: 'Saved Wishlist',
                    route: '/wishlist',
                    isActive: currentRoute == '/wishlist',
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.shopping_bag_outlined,
                    label: 'Shopping Cart',
                    route: '/cart',
                    isActive: currentRoute == '/cart',
                  ),
                  const Divider(height: 20, thickness: 0.8),
                  _buildDrawerItem(
                    context,
                    icon: Icons.info_outline_rounded,
                    label: 'About Us',
                    route: '/about',
                    isActive: currentRoute == '/about',
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.location_on_outlined,
                    label: 'Contact & Directions',
                    route: '/contact',
                    isActive: currentRoute == '/contact',
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.star_outline_rounded,
                    label: 'Follow Us & Reviews',
                    route: '/follow-us',
                    isActive: currentRoute == '/follow-us',
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.article_outlined,
                    label: 'Jewellery Care & Blog',
                    route: '/blog',
                    isActive: currentRoute.startsWith('/blog'),
                  ),
                  const Divider(height: 20, thickness: 0.8),
                  ListTile(
                    leading: const Icon(Icons.phone_in_talk_rounded, color: AppColors.darkGold),
                    title: const Text('Call Showroom', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('+91 9427080359', style: TextStyle(fontSize: 12)),
                    onTap: () async {
                      final uri = Uri.parse('tel:+919427080359');
                      if (await canLaunchUrl(uri)) launchUrl(uri);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF25D366)),
                    title: const Text('WhatsApp Concierge', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Live order & inquiries', style: TextStyle(fontSize: 12)),
                    onTap: () async {
                      final uri = Uri.parse('https://wa.me/919427080359');
                      if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: body,
      bottomNavigationBar: showBottomNav
          ? NavigationBar(
              selectedIndex: selectedIndex >= 0 ? selectedIndex : 0,
              onDestinationSelected: (idx) => _onBottomNavTapped(context, idx),
              backgroundColor: Colors.white,
              indicatorColor: AppColors.champagne,
              surfaceTintColor: Colors.transparent,
              elevation: 4,
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home, color: AppColors.darkGold),
                  label: 'Home',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.storefront_outlined),
                  selectedIcon: Icon(Icons.storefront, color: AppColors.darkGold),
                  label: 'Shop',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.grid_view_rounded),
                  selectedIcon: Icon(Icons.grid_view, color: AppColors.darkGold),
                  label: 'Designs',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.pin_drop_outlined),
                  selectedIcon: Icon(Icons.pin_drop, color: AppColors.darkGold),
                  label: 'Contact',
                ),
                NavigationDestination(
                  icon: BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      if (state.itemCount == 0) {
                        return const Icon(Icons.shopping_bag_outlined);
                      }
                      return Badge(
                        label: Text('${state.itemCount}'),
                        backgroundColor: AppColors.primaryGold,
                        child: const Icon(Icons.shopping_bag_outlined),
                      );
                    },
                  ),
                  selectedIcon: BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      if (state.itemCount == 0) {
                        return const Icon(Icons.shopping_bag, color: AppColors.darkGold);
                      }
                      return Badge(
                        label: Text('${state.itemCount}'),
                        backgroundColor: AppColors.primaryGold,
                        child: const Icon(Icons.shopping_bag, color: AppColors.darkGold),
                      );
                    },
                  ),
                  label: 'Cart',
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? AppColors.darkGold : AppColors.textSecondary,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isActive ? AppColors.darkGold : AppColors.textPrimary,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          fontSize: 14,
        ),
      ),
      tileColor: isActive ? AppColors.lightGold : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () {
        Navigator.pop(context);
        if (currentRoute != route) {
          context.go(route);
        }
      },
    );
  }
}
