import 'package:flutter/material.dart';
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';

class PlantAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PlantAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : AppColors.background,
      elevation: 0,
      title: Text(
        'إدارة النباتات',
        style: TextStyles.appBarTitleStyle.copyWith(
          color: isDark ? Colors.white : null,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: isDark ? Colors.white : AppColors.onSurface,
          ),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.eco,
              color: AppColors.onSecondary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
