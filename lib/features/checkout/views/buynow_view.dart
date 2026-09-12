import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/cj_image.dart';
import '../../gallery/bloc/gallery_bloc.dart';
import '../../gallery/bloc/gallery_state.dart';
import '../../gallery/models/jewellery_item.dart';
import '../../rates/bloc/rates_bloc.dart';
import '../../rates/bloc/rates_state.dart';

class BuyNowView extends StatefulWidget {
  final JewelleryItem? item;
  final int? itemId;

  const BuyNowView({
    super.key,
    this.item,
    this.itemId,
  });

  @override
  State<BuyNowView> createState() => _BuyNowViewState();
}

class _BuyNowViewState extends State<BuyNowView> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController(text: 'Khedbrahma');
  final _pincodeController = TextEditingController(text: '383255');
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _sendWhatsAppOrder(JewelleryItem item, double price) async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();
    final city = _cityController.text.trim();

    final formattedPrice = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0).format(price);

    final msg = StringBuffer();
    msg.writeln('Hello ChandraKala Jewellers,');
    msg.writeln('I would like to place an order for the following jewellery piece:');
    msg.writeln('');
    msg.writeln('*Product:* ${item.name}');
    msg.writeln('*Metal:* ${item.metalType.toUpperCase()} (${item.purity})');
    msg.writeln('*Weight:* ${item.weight} g');
    msg.writeln('*Price:* $formattedPrice');
    if (item.image.isNotEmpty) {
      msg.writeln('*Image:* ${item.fullImageUrl}');
    }
    msg.writeln('');
    if (name.isNotEmpty) msg.writeln('*Customer Name:* $name');
    if (phone.isNotEmpty) msg.writeln('*Customer Mobile:* $phone');
    if (address.isNotEmpty) msg.writeln('*Address:* $address, $city');
    msg.writeln('');
    msg.writeln('Please confirm availability and booking details. Thank you!');

    final encoded = Uri.encodeComponent(msg.toString());
    final url = Uri.parse('https://wa.me/${AppConstants.shopWhatsAppNumber}?text=$encoded');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _confirmOnlineReservation(JewelleryItem item, double price) async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name and mobile number')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _isSubmitting = false);

    if (!mounted) return;

    final orderNo = 'CJ-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 28),
            const SizedBox(width: 10),
            Text('Reservation Confirmed', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reservation No: $orderNo', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkGold)),
            const SizedBox(height: 8),
            Text('Thank you, $name! Your order reservation for "${item.name}" has been placed. Our showroom team will contact you at $phone for verification.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/home');
            },
            child: const Text('Back to Home'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              _sendWhatsAppOrder(item, price);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.chat, size: 16),
            label: const Text('Send to WhatsApp'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return AppScaffold(
      currentRoute: '/buynow',
      title: 'Express Buy Now',
      body: BlocBuilder<GalleryBloc, GalleryState>(
        builder: (context, galleryState) {
          JewelleryItem? targetItem = widget.item;

          if (targetItem == null && widget.itemId != null && galleryState is GalleryLoaded) {
            try {
              targetItem = galleryState.items.firstWhere((i) => i.id == widget.itemId);
            } catch (_) {}
          }

          if (targetItem == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 48, color: AppColors.primaryGold),
                    const SizedBox(height: 16),
                    Text('No item selected for Buy Now', style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.go('/gallery'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGold),
                      child: const Text('Browse Jewellery Collection'),
                    ),
                  ],
                ),
              ),
            );
          }

          final item = targetItem;

          return BlocBuilder<RatesBloc, RatesState>(
            builder: (context, ratesState) {
              final double finalPrice = ratesState is RatesLoaded
                  ? ratesState.calculatePrice(item.metalType, item.weight)
                  : item.cachedPrice;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Reservation Desk',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Direct showroom order with instant 1-tap WhatsApp concierge or online booking.',
                          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 24),

                        // Selected Item Card
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF161A22) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark ? const Color(0xFF2E3544) : AppColors.primaryGold.withAlpha(80),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(isDark ? 80 : 12),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CJImage(
                                imagePath: item.image,
                                width: 88,
                                height: 88,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: GoogleFonts.playfairDisplay(fontSize: 17, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${item.metalType.toUpperCase()} · ${item.weight} g',
                                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      currencyFormatter.format(finalPrice),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.darkGold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Delivery & Contact Form
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF161A22) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark ? const Color(0xFF2E3544) : AppColors.champagne,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Customer Details',
                                style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: 'Full Name *',
                                  prefixIcon: const Icon(Icons.person_outline, color: AppColors.darkGold),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: 'Mobile Number *',
                                  prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.darkGold),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextField(
                                controller: _addressController,
                                decoration: InputDecoration(
                                  labelText: 'Delivery Address / Landmark',
                                  prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.darkGold),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _cityController,
                                      decoration: InputDecoration(
                                        labelText: 'City / Town',
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      controller: _pincodeController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Pincode',
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // WhatsApp 1-Tap Order Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () => _sendWhatsAppOrder(item, finalPrice),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF25D366),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    elevation: 4,
                                  ),
                                  icon: const Icon(Icons.chat_bubble_outline_rounded),
                                  label: const Text(
                                    'Order via WhatsApp (Instant)',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Online Booking Button
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: _isSubmitting ? null : () => _confirmOnlineReservation(item, finalPrice),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    foregroundColor: isDark ? const Color(0xFFF0D78C) : AppColors.darkGold,
                                    side: BorderSide(color: AppColors.primaryGold.withAlpha(140)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                  child: _isSubmitting
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryGold),
                                        )
                                      : const Text(
                                          'Confirm Reservation Online',
                                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
