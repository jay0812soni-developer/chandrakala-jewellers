import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/logger_service.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../bloc/gallery_bloc.dart';
import '../bloc/gallery_event.dart';
import '../bloc/gallery_state.dart';
import '../widgets/jewellery_card.dart';

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: '/gallery',
      title: 'Shop Gallery',
      body: BlocConsumer<GalleryBloc, GalleryState>(
        listenWhen: (previous, current) => current is GalleryError,
        listener: (context, state) {
          if (state is GalleryError) {
            AppLogger.error('Gallery error encountered: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final activeMetal = state is GalleryLoaded ? state.activeMetal : 'all';

          return CustomScrollView(
            slivers: [
              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: TextField(
                    onChanged: (val) {
                      context.read<GalleryBloc>().add(SearchGalleryEvent(val));
                    },
                    decoration: InputDecoration(
                      hintText: 'Search rings, necklaces, 916 gold...',
                      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                      prefixIcon: const Icon(Icons.search, color: AppColors.darkGold, size: 20),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.cardBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.cardBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primaryGold),
                      ),
                    ),
                  ),
                ),
              ),

              // Metal Filter Chips
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      _buildMetalChip(context, 'All Pieces', 'all', activeMetal),
                      const SizedBox(width: 8),
                      _buildMetalChip(context, 'Gold (916)', 'gold', activeMetal),
                      const SizedBox(width: 8),
                      _buildMetalChip(context, 'Silver 925', 'silver_925', activeMetal),
                      const SizedBox(width: 8),
                      _buildMetalChip(context, 'Silver', 'silver', activeMetal),
                    ],
                  ),
                ),
              ),

              // Body content
              if (state is GalleryLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primaryGold),
                  ),
                )
              else if (state is GalleryLoaded && state.items.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No pieces found matching your filter.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                  ),
                )
              else if (state is GalleryLoaded)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.68,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = state.items[index];
                        return JewelleryCard(
                          item: item,
                          onTap: () {
                            AppLogger.info('Viewing product details: ${item.id} - ${item.name}');
                            context.push('/product/${item.id}', extra: item);
                          },
                        );
                      },
                      childCount: state.items.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMetalChip(
    BuildContext context,
    String label,
    String metalValue,
    String activeValue,
  ) {
    final isSelected = metalValue == activeValue;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        AppLogger.debug('Filter selected: $metalValue');
        context.read<GalleryBloc>().add(ChangeMetalFilterEvent(metalValue));
      },
      selectedColor: AppColors.primaryGold,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? Colors.white : AppColors.textPrimary,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primaryGold : AppColors.cardBorder,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
