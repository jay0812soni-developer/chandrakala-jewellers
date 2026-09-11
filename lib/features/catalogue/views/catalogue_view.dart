import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/logger_service.dart';
import '../bloc/catalogue_bloc.dart';
import '../bloc/catalogue_state.dart';
import '../models/catalogue_item.dart';

class CatalogueView extends StatelessWidget {
  const CatalogueView({super.key});

  void _enquireOnWhatsApp(CatalogueItem item) async {
    AppLogger.info('WhatsApp enquiry clicked for design: ${item.name}');
    final text = Uri.encodeComponent(
      'Namaste ChandraKala Jewellers,\n'
      'I am interested in custom making this design:\n'
      'Design: ${item.name}\n'
      'Photo Link: ${item.fullImageUrl}\n\n'
      'Could you share the approximate weight and estimated making charge?',
    );
    final url = Uri.parse('https://wa.me/${AppConstants.shopWhatsAppNumber}?text=$text');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CUSTOM DESIGN CATALOGUE'),
      ),
      body: BlocConsumer<CatalogueBloc, CatalogueState>(
        listenWhen: (previous, current) => current is CatalogueError,
        listener: (context, state) {
          if (state is CatalogueError) {
            AppLogger.error('Catalogue error: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state is CatalogueLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryGold));
          }

          if (state is CatalogueLoaded) {
            if (state.items.isEmpty) {
              return const Center(child: Text('No catalogue designs available.'));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.72,
              ),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];

                return RepaintBoundary(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: CachedNetworkImage(
                              imageUrl: item.fullImageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              memCacheWidth: 400,
                              memCacheHeight: 400,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey.shade200,
                                highlightColor: Colors.grey.shade100,
                                child: Container(color: Colors.white),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.lightGold,
                                child: const Center(
                                  child: Icon(Icons.palette_outlined, color: AppColors.darkGold, size: 36),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: double.infinity,
                                height: 32,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.chat, size: 14, color: Colors.white),
                                  label: const Text('Enquire', style: TextStyle(fontSize: 11)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF25D366),
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: () => _enquireOnWhatsApp(item),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
