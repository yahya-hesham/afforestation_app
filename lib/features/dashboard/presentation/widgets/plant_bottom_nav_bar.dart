import 'package:flutter/material.dart';
import 'package:afforestation_app/core/styles/colors.dart';

class PlantBottomNavigationBar extends StatelessWidget {
  const PlantBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark ? const Color(0xFF1E1E1E) : AppColors.surface;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: navBg,
      selectedItemColor: isDark ? const Color(0xFF81C784) : AppColors.primary,
      unselectedItemColor: isDark
          ? Colors.white60
          : AppColors.onSurfaceVariant.withOpacity(0.6),
      currentIndex: 1,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'حسابي',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          label: 'الإحصائيات',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.forest_outlined),
          label: 'النباتات',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'الرئيسية',
        ),
      ],
    );
  }
}
