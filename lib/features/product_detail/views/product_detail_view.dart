import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/logger_service.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../cart/bloc/cart_state.dart';
import '../../gallery/bloc/gallery_bloc.dart';
import '../../gallery/bloc/gallery_state.dart';
import '../../gallery/models/jewellery_item.dart';
import '../../rates/bloc/rates_bloc.dart';
import '../../rates/bloc/rates_state.dart';
import '../../wishlist/bloc/wishlist_bloc.dart';
import '../../wishlist/bloc/wishlist_event.dart';
import '../../wishlist/bloc/wishlist_state.dart';

class ProductDetailView extends StatefulWidget {
  final JewelleryItem? item;
  final int? itemId;

  const ProductDetailView({
    super.key,
    this.item,
    this.itemId,
  });

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  final List<Map<String, dynamic>> _localReviews = [
    {
      'name': 'Pooja Patel',
      'rating': 5,
      'comment': 'Exquisite 22K craftsmanship! The hallmark purity gives complete peace of mind. Exactly as pictured.',
      'date': 'March 2026',
    },
    {
      'name': 'Haresh Soni',
      'rating': 5,
      'comment': 'Our family has been buying from ChandraKala for years. Transparent rates and brilliant finishing.',
      'date': 'February 2026',
    },
  ];

  void _showWriteReviewDialog(BuildContext context, JewelleryItem product) {
    final nameCtrl = TextEditingController();
    final commentCtrl = TextEditingController();
    int selectedRating = 5;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                'Write a Review for ${product.name}',
                style: const TextStyle(fontFamily: 'serif', fontSize: 18, fontWeight: FontWeight.w700),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Rating', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 6),
                    Row(
                      children: List.generate(5, (index) {
                        final star = index + 1;
                        return IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            star <= selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: Colors.amber,
                            size: 32,
                          ),
                          onPressed: () => setDialogState(() => selectedRating = star),
                        );
                      }),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                        hintText: 'e.g. Priyal Dave',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: commentCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Your Review',
                        hintText: 'Share how this piece looks and feels...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    final comment = commentCtrl.text.trim();
                    if (name.isEmpty || comment.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter your name and a review comment')),
                      );
                      return;
                    }
                    setState(() {
                      _localReviews.insert(0, {
                        'name': name,
                        'rating': selectedRating,
                        'comment': comment,
                        'date': 'Just now',
                      });
                    });
                    Navigator.pop(dialogCtx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Thank you! Your review is live.')),
                    );
                  },
                  child: const Text('Submit Review'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showZoomDialog(BuildContext context, String imageUrl, String title) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(12),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.8,
              maxScale: 4.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(Icons.close, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return BlocBuilder<GalleryBloc, GalleryState>(
      builder: (context, galleryState) {
        JewelleryItem? product = widget.item;

        if (product == null && widget.itemId != null && galleryState is GalleryLoaded) {
          try {
            product = galleryState.items.firstWhere((i) => i.id == widget.itemId);
          } catch (_) {
            product = null;
          }
        }

        if (product == null) {
          if (galleryState is GalleryLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: AppColors.primaryGold)),
            );
          }
          return Scaffold(
            appBar: AppBar(title: const Text('Product Details')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off_rounded, size: 48, color: AppColors.textSecondary),
                  const SizedBox(height: 12),
                  const Text('Product piece not found or sold out', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/gallery'),
                    child: const Text('Browse Shop'),
                  ),
                ],
              ),
            ),
          );
        }

        final item = product;

        return BlocBuilder<RatesBloc, RatesState>(
          builder: (context, ratesState) {
            final livePrice = ratesState is RatesLoaded
                ? ratesState.calculatePrice(item.metalType, item.weight)
                : item.cachedPrice;

            return Scaffold(
              appBar: AppBar(
                title: Text(item.name.toUpperCase()),
                actions: [
                  // Wishlist Toggle
                  BlocBuilder<WishlistBloc, WishlistState>(
                    builder: (context, wishState) {
                      final isSaved = wishState.isInWishlist(item.id);
                      return IconButton(
                        icon: Icon(
                          isSaved ? Icons.favorite : Icons.favorite_border_rounded,
                          color: isSaved ? Colors.redAccent : AppColors.textPrimary,
                        ),
                        tooltip: isSaved ? 'Remove from Wishlist' : 'Add to Wishlist',
                        onPressed: () {
                          context.read<WishlistBloc>().add(ToggleWishlistEvent(item));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isSaved ? 'Removed from wishlist' : 'Added to wishlist!'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // Cart Action
                  BlocBuilder<CartBloc, CartState>(
                    builder: (context, cartState) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_bag_outlined),
                            onPressed: () => context.push('/cart'),
                          ),
                          if (cartState.itemCount > 0)
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
                                  '${cartState.itemCount}',
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Photo with Pinch to Zoom Tap
                    AspectRatio(
                      aspectRatio: 1.15,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: InkWell(
                              onTap: () => _showZoomDialog(context, item.fullImageUrl, item.name),
                              child: CachedNetworkImage(
                                imageUrl: item.fullImageUrl,
                                fit: BoxFit.contain,
                                placeholder: (context, url) => Container(color: AppColors.champagne),
                                errorWidget: (context, url, error) => Container(
                                  color: AppColors.champagne,
                                  child: const Center(
                                    child: Icon(Icons.diamond_outlined, size: 64, color: AppColors.primaryGold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.zoom_in_rounded, size: 14, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text('Tap to zoom', style: TextStyle(color: Colors.white, fontSize: 11)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Details Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.champagne,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.primaryGold.withAlpha(120)),
                                ),
                                child: Text(
                                  '${item.metalType.toUpperCase()} • ${item.purity.isNotEmpty ? item.purity : '22K 916'}',
                                  style: const TextStyle(
                                    color: AppColors.darkGold,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              if (item.isSoldOut)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withAlpha(25),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'SOLD OUT',
                                    style: TextStyle(color: AppColors.error, fontSize: 11, fontWeight: FontWeight.w700),
                                  ),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withAlpha(20),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.check_circle_outline, color: AppColors.success, size: 13),
                                      SizedBox(width: 4),
                                      Text(
                                        'In Stock Khedbrahma',
                                        style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Text(
                            item.name,
                            style: const TextStyle(
                              fontFamily: 'serif',
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            currencyFormatter.format(livePrice),
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.primaryGold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '*Price calculated live based on today’s metal bullion rate + making charges',
                            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),

                          const SizedBox(height: 16),

                          // 24h Stock Hold Note
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.lightGold,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.primaryGold.withAlpha(80)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.lock_clock_outlined, size: 18, color: AppColors.darkGold),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '24-Hour Stock Reservation: Order online or on WhatsApp to lock this piece for 24 hours while you complete payment.',
                                    style: TextStyle(fontSize: 11.5, color: AppColors.textPrimary, height: 1.4),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),
                          const Text('Specifications', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 12),

                          _buildSpecRow('Gross Weight', CurrencyFormatter.formatWeight(item.weight)),
                          _buildSpecRow('Metal Type', item.metalType.toUpperCase()),
                          if (item.purity.isNotEmpty) _buildSpecRow('Purity Hallmark', item.purity),
                          if (item.stone.isNotEmpty) _buildSpecRow('Stone / Setting', item.stone),
                          if (item.dimensions.isNotEmpty) _buildSpecRow('Dimensions', item.dimensions),
                          if (item.sku.isNotEmpty) _buildSpecRow('SKU Code', item.sku),

                          if (item.description.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            const Text('Description', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 8),
                            Text(
                              item.description,
                              style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.5),
                            ),
                          ],

                          const SizedBox(height: 32),
                          const Divider(),
                          const SizedBox(height: 20),

                          // Customer Reviews Section matching product.php
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Customer Reviews', style: TextStyle(fontFamily: 'serif', fontSize: 18, fontWeight: FontWeight.w800)),
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        '5.0 / 5 from ${_localReviews.length} reviews',
                                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              OutlinedButton.icon(
                                onPressed: () => _showWriteReviewDialog(context, item),
                                icon: const Icon(Icons.edit_outlined, size: 14, color: AppColors.darkGold),
                                label: const Text('Write Review', style: TextStyle(fontSize: 12, color: AppColors.darkGold)),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.primaryGold),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Reviews List
                          ..._localReviews.map((rev) => Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.cardBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      rev['name'] as String,
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                    ),
                                    Row(
                                      children: List.generate(
                                        (rev['rating'] as int),
                                        (_) => const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  rev['comment'] as String,
                                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  rev['date'] as String,
                                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          )),

                          const SizedBox(height: 28),

                          // Related Pieces Section matching product.php
                          if (galleryState is GalleryLoaded) ...[
                            const Text('Related Pieces You May Like', style: TextStyle(fontFamily: 'serif', fontSize: 18, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 14),
                            SizedBox(
                              height: 190,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: galleryState.items
                                    .where((i) => i.id != item.id)
                                    .take(4)
                                    .map((rel) => InkWell(
                                          onTap: () => context.push('/product/${rel.id}', extra: rel),
                                          child: Container(
                                            width: 140,
                                            margin: const EdgeInsets.only(right: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: AppColors.cardBorder),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: ClipRRect(
                                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                                    child: CachedNetworkImage(
                                                      imageUrl: rel.fullImageUrl,
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        rel.name,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                                                      ),
                                                      Text(
                                                        '${rel.weight} g • ₹${NumberFormat('#,##,###').format(rel.cachedPrice)}',
                                                        style: const TextStyle(fontSize: 11, color: AppColors.darkGold, fontWeight: FontWeight.w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10, offset: const Offset(0, -3)),
                  ],
                ),
                child: SafeArea(
                  child: item.isSoldOut
                      ? Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: null,
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text('SOLD OUT', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => context.go('/gallery'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text('Browse Shop'),
                              ),
                            ),
                          ],
                        )
                      : BlocBuilder<CartBloc, CartState>(
                          builder: (context, cartState) {
                            final inCart = cartState.isInCart(item.id);

                            return Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    icon: Icon(inCart ? Icons.check : Icons.shopping_bag_outlined, color: AppColors.darkGold, size: 18),
                                    label: Text(inCart ? 'IN CART' : 'ADD TO CART', style: const TextStyle(color: AppColors.darkGold, fontWeight: FontWeight.w700)),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: AppColors.primaryGold, width: 1.5),
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      if (inCart) {
                                        context.push('/cart');
                                      } else {
                                        context.read<CartBloc>().add(AddToCartEvent(item));
                                        AppLogger.info('Added ${item.name} to cart');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Added "${item.name}" to cart!'),
                                            action: SnackBarAction(
                                              label: 'VIEW CART',
                                              textColor: AppColors.primaryGold,
                                              onPressed: () => context.push('/cart'),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryGold,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      if (!inCart) {
                                        context.read<CartBloc>().add(AddToCartEvent(item));
                                      }
                                      context.push('/checkout');
                                    },
                                    child: const Text('BUY NOW!', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
