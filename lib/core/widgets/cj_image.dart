import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_colors.dart';

class CJImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CJImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    final trimmed = imagePath.trim();
    final isNetwork = trimmed.startsWith('http://') || trimmed.startsWith('https://');

    if (!isNetwork && trimmed.isNotEmpty) {
      String assetPath = trimmed;
      if (!assetPath.startsWith('assets/')) {
        if (assetPath.startsWith('images/')) {
          assetPath = 'assets/$assetPath';
        } else {
          assetPath = 'assets/images/$assetPath';
        }
      }

      imageWidget = Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallback();
        },
      );
    } else if (isNetwork) {
      imageWidget = CachedNetworkImage(
        imageUrl: trimmed,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: AppColors.champagne,
          highlightColor: Colors.white,
          child: Container(
            width: width,
            height: height,
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, error) => _buildFallback(),
      );
    } else {
      imageWidget = _buildFallback();
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildFallback() {
    return Container(
      width: width,
      height: height,
      color: AppColors.champagne,
      alignment: Alignment.center,
      child: const Icon(
        Icons.diamond_outlined,
        color: AppColors.primaryGold,
        size: 28,
      ),
    );
  }
}
