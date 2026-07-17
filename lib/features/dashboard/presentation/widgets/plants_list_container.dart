import 'package:afforestation_app/features/dashboard/data/models/plant_names_response.dart';
import 'package:afforestation_app/features/dashboard/presentation/dumy_data/plant_model.dart';

import 'package:flutter/material.dart';
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';

class PlantsListContainer extends StatelessWidget {
  final String categoryTitle;
  final List<PlantNamesResponse> plants;
  final Function(PlantNamesResponse) onEdit;
  final Function(PlantNamesResponse) onDelete;
  final VoidCallback onAddPlant;

  const PlantsListContainer({
    super.key,
    required this.categoryTitle,
    required this.plants,
    required this.onEdit,
    required this.onDelete,
    required this.onAddPlant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: AppColors.secondary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  categoryTitle,
                  style: TextStyles.buttonTextStyle.copyWith(fontSize: 16),
                ),
                ElevatedButton.icon(
                  onPressed: onAddPlant,
                  icon: const Icon(
                    Icons.add,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    'إضافة نبات',
                    style: TextStyles.textButtonTextStyle.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: AppColors.secondary.withOpacity(0.15),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'اسم النبات',
                    style: TextStyles.listRowSubtitleStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    'الاسم العلمي',
                    style: TextStyles.listRowSubtitleStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'إدارة',
                    style: TextStyles.listRowSubtitleStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          plants.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    "لا توجد نباتات في هذا القسم",
                    style: TextStyles.listRowSubtitleStyle,
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: plants.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1, color: Colors.black12),
                  itemBuilder: (context, index) {
                    final plant = plants[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              plant.scientificName ?? "",
                              style: TextStyles.listRowTitleStyle,
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              plant.name ?? "",
                              style: TextStyles.listRowSubtitleStyle.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () => onEdit(plant),
                                  child: const Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () => onDelete(plant),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
