import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/logger_service.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/cj_image.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppScaffold(
      currentRoute: '/catalogue',
      title: 'Design Catalogue',
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
                      color: isDark ? const Color(0xFF161A22) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? const Color(0xFF2E3544) : AppColors.cardBorder,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(isDark ? 60 : 10),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: CJImage(
                              imagePath: item.imageFilename,
                              fit: BoxFit.cover,
                              width: double.infinity,
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
                                style: GoogleFonts.playfairDisplay(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: isDark ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: double.infinity,
                                height: 32,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.chat, size: 14, color: Colors.white),
                                  label: const Text('Enquire on WhatsApp', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF25D366),
                                    foregroundColor: Colors.white,
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
