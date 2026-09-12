import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../theme/theme_cubit.dart';
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
    if (currentRoute == '/' || currentRoute == '/home' || currentRoute == '/index1') return 0;
    if (currentRoute.startsWith('/gallery') || currentRoute.startsWith('/shop')) return 1;
    if (currentRoute.startsWith('/catalogue') || currentRoute.startsWith('/Catalogue')) return 2;
    if (currentRoute.startsWith('/contact')) return 3;
    if (currentRoute.startsWith('/cart')) return 4;
    return -1;
  }

  void _onBottomNavTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        if (currentRoute != '/home' && currentRoute != '/' && currentRoute != '/index1') context.go('/home');
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

  void _showSettingsModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeCubit = context.read<ThemeCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF161A22) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Settings',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // Theme Selection matching PHP segment
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Theme', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                          Text('Light, dark, or system preference', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                      SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment(value: ThemeMode.light, label: Text('Light', style: TextStyle(fontSize: 12))),
                          ButtonSegment(value: ThemeMode.dark, label: Text('Dark', style: TextStyle(fontSize: 12))),
                          ButtonSegment(value: ThemeMode.system, label: Text('Auto', style: TextStyle(fontSize: 12))),
                        ],
                        selected: {themeMode},
                        onSelectionChanged: (Set<ThemeMode> newSelection) {
                          themeCubit.setTheme(newSelection.first);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Push Alerts toggle
                  _buildSettingSwitch(
                    title: 'Push Alerts',
                    subtitle: 'Offers & live rates updates',
                    value: true,
                    onChanged: (val) {},
                  ),
                  const SizedBox(height: 14),

                  // In-App Alerts toggle
                  _buildSettingSwitch(
                    title: 'In-App Alerts',
                    subtitle: 'Popups while browsing showroom',
                    value: true,
                    onChanged: (val) {},
                  ),
                  const SizedBox(height: 14),

                  // Store Location toggle
                  _buildSettingSwitch(
                    title: 'Location Services',
                    subtitle: 'For showroom directions & maps',
                    value: true,
                    onChanged: (val) {},
                  ),
                  const SizedBox(height: 20),

                  // Install Web App Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('App is installed / running in progressive web mode.')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark ? const Color(0xFFF0D78C) : AppColors.darkGold,
                        side: const BorderSide(color: AppColors.primaryGold),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: const Text('Add ChandraKala to Home Screen', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSettingSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
            Switch(
              value: value,
              activeColor: AppColors.primaryGold,
              onChanged: (newVal) {
                setState(() => value = newVal);
                onChanged(newVal);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
            tooltip: 'Showroom Navigation',
          ),
        ),
        title: InkWell(
          onTap: () => context.go('/home'),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Circular Golden Logo Badge
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryGold, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGold.withAlpha(40),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (ctx, err, stack) => const Center(
                          child: Text(
                            'CJ',
                            style: TextStyle(
                              color: AppColors.darkGold,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title ?? (screenWidth < 400 ? 'ChandraKala' : 'ChandraKala Jewellers'),
                      style: GoogleFonts.playfairDisplay(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      'Elegance & Sparkle',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isDark ? const Color(0xFFF0D78C) : AppColors.darkGold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          // Desktop Navigation Links
          if (isDesktop) ...[
            _buildNavButton(context, label: 'Home', route: '/home', isActive: currentRoute == '/' || currentRoute == '/home' || currentRoute == '/index1'),
            _buildNavButton(context, label: 'Shop', route: '/gallery', isActive: currentRoute.startsWith('/gallery')),
            _buildNavButton(context, label: 'Catalogue', route: '/catalogue', isActive: currentRoute.startsWith('/catalogue')),
            _buildNavButton(context, label: 'About', route: '/about', isActive: currentRoute == '/about'),
            _buildNavButton(context, label: 'Contact', route: '/contact', isActive: currentRoute == '/contact'),
            _buildNavButton(context, label: 'Blog', route: '/blog', isActive: currentRoute.startsWith('/blog')),
            const SizedBox(width: 8),
          ],

          // Wishlist Action with live badge
          BlocBuilder<WishlistBloc, WishlistState>(
            builder: (context, state) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      state.count > 0 ? Icons.favorite : Icons.favorite_border_rounded,
                      color: state.count > 0 ? Colors.redAccent : (isDark ? Colors.white : AppColors.textPrimary),
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

          // Customer Account Profile
          IconButton(
            icon: Icon(
              Icons.person_outline_rounded,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
            tooltip: 'Customer Account',
            onPressed: () => context.go('/account'),
          ),

          // Cart Action with live badge
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_bag_outlined,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
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

          // Settings Gear popup button matching header.php
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
            tooltip: 'Showroom Settings',
            onPressed: () => _showSettingsModal(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      drawer: Drawer(
        backgroundColor: isDark ? const Color(0xFF161A22) : Colors.white,
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
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryGold, width: 2),
                      color: Colors.white,
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (ctx, err, stack) => const Center(
                            child: Text(
                              'CJ',
                              style: TextStyle(
                                color: AppColors.darkGold,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'ChandraKala Jewellers',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Opp. Bhoomi Complex, Civil Road, Khedbrahma',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFD1D5DB),
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
                    label: 'Showroom Home',
                    route: '/home',
                    isActive: currentRoute == '/' || currentRoute == '/home' || currentRoute == '/index1',
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.storefront_outlined,
                    label: 'Shop Ready Stock',
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
                    icon: Icons.trending_up_rounded,
                    label: 'Gold Rate Khedbrahma',
                    route: '/gold-rate-khedbrahma',
                    isActive: currentRoute == '/gold-rate-khedbrahma',
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.store_mall_directory_outlined,
                    label: 'Jewellers in Khedbrahma',
                    route: '/jewellers-in-khedbrahma',
                    isActive: currentRoute == '/jewellers-in-khedbrahma',
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
                  _buildDrawerItem(
                    context,
                    icon: Icons.person_outline_rounded,
                    label: 'Customer Account',
                    route: '/account',
                    isActive: currentRoute == '/account',
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
                    leading: const Icon(Icons.palette_outlined, color: AppColors.primaryGold),
                    title: const Text('Theme Settings'),
                    subtitle: const Text('Light / Dark / Auto'),
                    onTap: () {
                      Navigator.pop(context);
                      _showSettingsModal(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: body,
      bottomNavigationBar: showBottomNav && selectedIndex != -1
          ? Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(isDark ? 80 : 12),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: NavigationBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: (index) => _onBottomNavTapped(context, index),
                backgroundColor: isDark ? const Color(0xFF161A22) : Colors.white,
                indicatorColor: AppColors.champagne,
                height: 65,
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
                    icon: Icon(Icons.location_on_outlined),
                    selectedIcon: Icon(Icons.location_on, color: AppColors.darkGold),
                    label: 'Contact',
                  ),
                  BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      return NavigationDestination(
                        icon: Badge(
                          label: Text('${state.itemCount}'),
                          isLabelVisible: state.itemCount > 0,
                          backgroundColor: AppColors.primaryGold,
                          child: const Icon(Icons.shopping_bag_outlined),
                        ),
                        selectedIcon: Badge(
                          label: Text('${state.itemCount}'),
                          isLabelVisible: state.itemCount > 0,
                          backgroundColor: AppColors.primaryGold,
                          child: const Icon(Icons.shopping_bag, color: AppColors.darkGold),
                        ),
                        label: 'Cart',
                      );
                    },
                  ),
                ],
              ),
            )
          : null,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final uri = Uri.parse('https://wa.me/${AppConstants.shopWhatsAppNumber}?text=${Uri.encodeComponent("Namaste ChandraKala Jewellers, I would like to inquire about gold & silver jewellery.")}');
          if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
        },
        backgroundColor: const Color(0xFF25D366),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
        label: const Text('WhatsApp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        elevation: 6,
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required String label,
    required String route,
    required bool isActive,
  }) {
    return TextButton(
      onPressed: () => context.go(route),
      style: TextButton.styleFrom(
        foregroundColor: isActive ? AppColors.darkGold : AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
          fontSize: 14,
          decoration: isActive ? TextDecoration.underline : TextDecoration.none,
          decorationColor: AppColors.primaryGold,
          decorationThickness: 2,
        ),
      ),
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
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isActive,
      selectedTileColor: AppColors.champagne.withAlpha(80),
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    );
  }
}
