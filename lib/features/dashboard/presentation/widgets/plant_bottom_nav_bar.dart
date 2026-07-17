import 'package:flutter/material.dart';
import 'package:afforestation_app/core/styles/colors.dart';

class PlantBottomNavigationBar extends StatelessWidget {
  const PlantBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.onSurfaceVariant.withOpacity(0.6),
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
          label: 'إحصائيات',
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
