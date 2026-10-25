import 'package:afforestation_app/core/functions/extenstion.dart';
import 'package:flutter/material.dart';
import 'package:afforestation_app/core/styles/colors.dart';

class PlantBottomNavigationBar extends StatelessWidget {
  const PlantBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: navBg,
      selectedItemColor: isDark ? const Color(0xFF81C784) : AppColors.primary,
      unselectedItemColor: isDark
          ? Colors.white60
          : AppColors.onSurfaceVariant.withValues(alpha: 0.6),
      currentIndex: 2,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          label: 'nav_home'.tr(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.forest_outlined),
          label: 'nav_plants'.tr(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.bar_chart_outlined),
          label: 'nav_statistics'.tr(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_outline),
          label: 'nav_my_account'.tr(),
        ),
      ],
    );
  }
}
