import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF7C3AED);
  static const Color secondary = Color(0xFF3B82F6);
  static const Color cta = Color(0xFFF97316);
  static const Color lavender = Color(0xFFD2BBFF);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color white = Colors.white;

  static const LinearGradient auroraGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF4F46E5), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient ctaGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFEF4444)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const Color cardFill = Color(0x1FFFFFFF);
  static const Color cardBorder = Color(0x33FFFFFF);
  static const Color shimmer = Color(0x40FFFFFF);

  // Avatar gradients — cycled by index
  static const List<List<Color>> avatarGradients = [
    [Color(0xFF7C3AED), Color(0xFF3B82F6)],
    [Color(0xFF3B82F6), Color(0xFF06B6D4)],
    [Color(0xFFF97316), Color(0xFFEF4444)],
    [Color(0xFF8B5CF6), Color(0xFFF97316)],
  ];

  static List<Color> avatarGradientFor(int index) =>
      avatarGradients[index % avatarGradients.length];
}
