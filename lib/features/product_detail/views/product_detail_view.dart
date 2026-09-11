import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/logger_service.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../cart/bloc/cart_state.dart';
import '../../gallery/models/jewellery_item.dart';

class ProductDetailView extends StatelessWidget {
  final JewelleryItem item;

  const ProductDetailView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name.toUpperCase()),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () => context.push('/cart'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with pinch-to-zoom capability
            AspectRatio(
              aspectRatio: 1.1,
              child: Container(
                color: Colors.white,
                child: CachedNetworkImage(
                  imageUrl: item.fullImageUrl,
                  fit: BoxFit.contain,
                  memCacheWidth: 800,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryGold),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.diamond_outlined, size: 64, color: AppColors.primaryGold),
                  ),
                ),
              ),
            ),

            // Product Details Card
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
                          color: AppColors.lightGold,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.5)),
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
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'SOLD OUT',
                            style: TextStyle(color: AppColors.error, fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Text(
                    item.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    CurrencyFormatter.format(item.cachedPrice),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primaryGold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '*Price calculated live based on today’s metal rate + making charges',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),

                  const SizedBox(height: 24),
                  const Text('Specifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),

                  _buildSpecRow('Gross Weight', CurrencyFormatter.formatWeight(item.weight)),
                  _buildSpecRow('Metal Type', item.metalType.toUpperCase()),
                  if (item.purity.isNotEmpty) _buildSpecRow('Purity', item.purity),
                  if (item.stone.isNotEmpty) _buildSpecRow('Stone', item.stone),
                  if (item.dimensions.isNotEmpty) _buildSpecRow('Dimensions', item.dimensions),
                  if (item.sku.isNotEmpty) _buildSpecRow('SKU Code', item.sku),

                  if (item.description.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, -3)),
          ],
        ),
        child: SafeArea(
          // BlocConsumer listens for Cart updates and triggers unified logging & snackbars
          child: BlocConsumer<CartBloc, CartState>(
            listenWhen: (previous, current) => previous.itemCount != current.itemCount,
            listener: (context, state) {
              if (state.isInCart(item.id)) {
                AppLogger.info('Item added to cart: ${item.id}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added "${item.name}" to cart!'),
                    action: SnackBarAction(
                      label: 'View Cart',
                      textColor: AppColors.primaryGold,
                      onPressed: () => context.push('/cart'),
                    ),
                  ),
                );
              }
            },
            builder: (context, cartState) {
              final inCart = cartState.isInCart(item.id);

              return SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  icon: Icon(inCart ? Icons.check : Icons.shopping_bag_outlined, color: Colors.white),
                  label: Text(inCart ? 'IN CART • VIEW CART' : 'ADD TO CART'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: inCart ? AppColors.darkGold : AppColors.primaryGold,
                  ),
                  onPressed: item.isSoldOut
                      ? null
                      : () {
                          if (inCart) {
                            context.push('/cart');
                          } else {
                            context.read<CartBloc>().add(AddToCartEvent(item));
                          }
                        },
                ),
              );
            },
          ),
        ),
      ),
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
