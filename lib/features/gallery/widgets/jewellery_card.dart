import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/cj_image.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../rates/bloc/rates_bloc.dart';
import '../../rates/bloc/rates_state.dart';
import '../../wishlist/bloc/wishlist_bloc.dart';
import '../../wishlist/bloc/wishlist_event.dart';
import '../../wishlist/bloc/wishlist_state.dart';
import '../models/jewellery_item.dart';

class JewelleryCard extends StatelessWidget {
  final JewelleryItem item;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const JewelleryCard({
    super.key,
    required this.item,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF161A22) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF2E3544) : AppColors.cardBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 60 : 10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image Container
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: CJImage(
                          imagePath: item.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Sold Out Badge
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
                          child: const Text('Sold Out', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                      )
                    else
                      // Metal Badge
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
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
                            radius: 15,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                isSaved ? Icons.favorite : Icons.favorite_border,
                                size: 16,
                                color: isSaved ? Colors.redAccent : (isDark ? Colors.white : Colors.black87),
                              ),
                              tooltip: isSaved ? 'Remove from wishlist' : 'Save to wishlist',
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
                // Details
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${item.metalType.toUpperCase()} • ${CurrencyFormatter.formatWeight(item.weight)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Live Dynamic Price
                      BlocBuilder<RatesBloc, RatesState>(
                        builder: (context, ratesState) {
                          final price = ratesState is RatesLoaded
                              ? ratesState.calculatePrice(item.metalType, item.weight)
                              : item.cachedPrice;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                CurrencyFormatter.formatINR(price),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? const Color(0xFFF0D78C) : AppColors.darkGold,
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.add_shopping_cart_rounded, size: 18, color: AppColors.primaryGold),
                                tooltip: 'Add to Cart',
                                onPressed: item.isSoldOut
                                    ? null
                                    : () {
                                        context.read<CartBloc>().add(AddToCartEvent(item));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Added "${item.name}" to cart!')),
                                        );
                                      },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
