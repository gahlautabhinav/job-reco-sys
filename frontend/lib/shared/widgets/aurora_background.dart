import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AuroraBackground extends StatefulWidget {
  const AuroraBackground({super.key});

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final sin = math.sin(t * math.pi);
        final cos = math.cos(t * math.pi * 0.7);
        return Container(
          color: const Color(0xFF100B1F),
          child: Stack(
            children: [
              // Purple orb — top-left, large
              Positioned(
                top: -140 + sin * 60,
                left: -100 + sin * 50,
                child: _AuroraBlob(
                  size: 520,
                  color: AppColors.primary.withValues(alpha: 0.45),
                ),
              ),
              // Blue orb — center-right
              Positioned(
                top: 180 + cos * 70,
                right: -120 + sin * 40,
                child: _AuroraBlob(
                  size: 460,
                  color: AppColors.secondary.withValues(alpha: 0.38),
                ),
              ),
              // Orange orb — bottom-center, smaller accent
              Positioned(
                bottom: -80 + sin * 50,
                left: 40 - cos * 40,
                child: _AuroraBlob(
                  size: 280,
                  color: AppColors.cta.withValues(alpha: 0.25),
                ),
              ),
              // Extra indigo shimmer — mid screen
              Positioned(
                top: 320 + sin * 40,
                left: -60 + cos * 30,
                child: _AuroraBlob(
                  size: 300,
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.2),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AuroraBlob extends StatelessWidget {
  final double size;
  final Color color;

  const _AuroraBlob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}
