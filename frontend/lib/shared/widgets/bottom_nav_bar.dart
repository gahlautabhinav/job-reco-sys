import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    (icon: Icons.search_rounded, label: 'Search'),
    (icon: Icons.bookmark_rounded, label: 'Saved'),
    (icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.07),
            border: Border(
              top: BorderSide(color: AppColors.cardBorder),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_items.length, (i) {
                  final item = _items[i];
                  final isActive = i == currentIndex;
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTap(i),
                    child: SizedBox(
                      width: 88,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: isActive
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFFF97316),
                                        Color(0xFFEF4444),
                                      ],
                                    )
                                  : null,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: AppColors.cta
                                            .withValues(alpha: 0.35),
                                        blurRadius: 12,
                                        spreadRadius: 0,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              item.icon,
                              size: 26,
                              color: isActive
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.45),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.label,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: isActive
                                  ? AppColors.cta
                                  : Colors.white.withValues(alpha: 0.45),
                              fontSize: 11,
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
