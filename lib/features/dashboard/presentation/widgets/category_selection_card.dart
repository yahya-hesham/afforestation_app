import 'package:afforestation_app/features/dashboard/data/repository/models/plant_model.dart';

import 'package:afforestation_app/features/dashboard/presentation/models/plant_model.dart';

import 'package:flutter/material.dart';
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';


class CategorySelectionCard extends StatelessWidget {
  final List<PlantCategory> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;

  const CategorySelectionCard({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.eco_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text('أنواع النباتات', style: TextStyles.cardSectionTitleStyle),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final isSelected = index == selectedIndex;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: InkWell(
                  onTap: () => onCategorySelected(index),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.secondary : AppColors.surface,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: isSelected ? Colors.transparent : Colors.black12),
                    ),
                    child: Center(
                      child: Text(
                        "${categories[index].titleAr} (${categories[index].titleEn})",
                        style: TextStyles.textButtonTextStyle.copyWith(
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                          color: isSelected ? AppColors.onSecondary : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}