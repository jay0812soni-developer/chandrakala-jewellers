import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _cardAnimController;
  late Animation<double> _cardScaleAnim;
  late Animation<double> _cardFadeAnim;

  late AnimationController _progressController;
  late AnimationController _sparkleController;
  late AnimationController _bgPanController;

  final List<_SparkleParticle> _sparkles = [];
  Timer? _autoTransitionTimer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _cardAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _cardScaleAnim = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardAnimController,
        curve: const Cubic(0.16, 1.0, 0.3, 1.0),
      ),
    );

    _cardFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardAnimController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _bgPanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat(reverse: true);

    final random = math.Random();
    for (int i = 0; i < 20; i++) {
      _sparkles.add(_SparkleParticle(
        leftFraction: random.nextDouble(),
        size: random.nextDouble() * 8 + 4,
        speed: random.nextDouble() * 0.5 + 0.5,
        delay: random.nextDouble(),
        opacity: random.nextDouble() * 0.6 + 0.2,
      ));
    }

    _cardAnimController.forward();
    _progressController.forward();

    _autoTransitionTimer = Timer(const Duration(milliseconds: 2900), () {
      _enterShowroom();
    });
  }

  void _enterShowroom() {
    if (_navigated || !mounted) return;
    _navigated = true;
    _autoTransitionTimer?.cancel();
    context.go('/home');
  }

  void _openCatalogue() {
    if (_navigated || !mounted) return;
    _navigated = true;
    _autoTransitionTimer?.cancel();
    context.go('/catalogue');
  }

  @override
  void dispose() {
    _autoTransitionTimer?.cancel();
    _cardAnimController.dispose();
    _progressController.dispose();
    _sparkleController.dispose();
    _bgPanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _bgPanController,
            builder: (context, child) {
              final scale = 1.05 + (_bgPanController.value * 0.08);
              final offsetX = math.sin(_bgPanController.value * math.pi) * 15;
              final offsetY = math.cos(_bgPanController.value * math.pi) * 10;

              return Transform.translate(
                offset: Offset(offsetX, offsetY),
                child: Transform.scale(
                  scale: scale,
                  child: Image.asset(
                    'assets/images/jewelry4.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      color: isDark ? const Color(0xFF0C0E12) : const Color(0xFFFAF9F6),
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        const Color(0xEC0C0E12),
                        const Color(0xF4161A22),
                      ]
                    : [
                        const Color(0xD8FAF9F6),
                        const Color(0xEEFAF9F6),
                      ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _sparkleController,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: _SparklesPainter(
                  sparkles: _sparkles,
                  progress: _sparkleController.value,
                  particleColor: isDark ? const Color(0xFFF0D78C) : AppColors.primaryGold,
                ),
              );
            },
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: AnimatedBuilder(
                animation: _cardAnimController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _cardFadeAnim.value,
                    child: Transform.scale(
                      scale: _cardScaleAnim.value,
                      child: child,
                    ),
                  );
                },
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 540),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 42),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xE0161A22)
                          : Colors.white.withAlpha(225),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF5A4820)
                            : AppColors.primaryGold.withAlpha(80),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withAlpha(150)
                              : AppColors.darkGold.withAlpha(35),
                          blurRadius: 40,
                          offset: const Offset(0, 18),
                        ),
                        BoxShadow(
                          color: AppColors.primaryGold.withAlpha(isDark ? 30 : 25),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: AppColors.primaryGold,
                              width: 2.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryGold.withAlpha(60),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.contain,
                                errorBuilder: (ctx, err, stack) => const Center(
                                  child: Text(
                                    'CJ',
                                    style: TextStyle(
                                      color: AppColors.darkGold,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.primaryGold.withAlpha(100),
                                width: 1.2,
                              ),
                            ),
                          ),
                          child: Text(
                            'EST. 2014 · KHEDBRAHMA',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 3.5,
                              color: isDark ? const Color(0xFFF0D78C) : AppColors.darkGold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'ChandraKala Jewellers',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            color: isDark ? const Color(0xFFF3F4F6) : const Color(0xFF1A1A1A),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Discover a timeless realm of elegance, beauty, and premium quality gold and silver jewellery designs handcrafted to reflect your radiance.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: isDark ? const Color(0xFFB5BAC6) : const Color(0xFF5A5A5A),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 280),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _enterShowroom,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: AppColors.primaryGold,
                                foregroundColor: Colors.white,
                                elevation: 6,
                                shadowColor: AppColors.darkGold.withAlpha(100),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  constraints: const BoxConstraints(minHeight: 48),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Enter Showroom',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        InkWell(
                          onTap: _openCatalogue,
                          borderRadius: BorderRadius.circular(4),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            child: Text(
                              'DESIGN CATALOGUE',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                                color: isDark ? const Color(0xFFD0D6E2) : const Color(0xFF7A7A7A),
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.dashed,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: 140,
                          height: 3.5,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGold.withAlpha(40),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: AnimatedBuilder(
                            animation: _progressController,
                            builder: (context, child) {
                              return FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: _progressController.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
                                    ),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SparkleParticle {
  final double leftFraction;
  final double size;
  final double speed;
  final double delay;
  final double opacity;

  _SparkleParticle({
    required this.leftFraction,
    required this.size,
    required this.speed,
    required this.delay,
    required this.opacity,
  });
}

class _SparklesPainter extends CustomPainter {
  final List<_SparkleParticle> sparkles;
  final double progress;
  final Color particleColor;

  _SparklesPainter({
    required this.sparkles,
    required this.progress,
    required this.particleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in sparkles) {
      final t = (progress * s.speed + s.delay) % 1.0;
      final y = size.height * (1.0 - t);
      final x = size.width * s.leftFraction + math.sin(t * math.pi * 4) * 12;
      final particleOpacity = math.sin(t * math.pi) * s.opacity;

      final paint = Paint()
        ..color = particleColor.withAlpha((particleOpacity * 255).clamp(0, 255).toInt())
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, s.size * 0.4);

      canvas.drawCircle(Offset(x, y), s.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparklesPainter oldDelegate) => true;
}
