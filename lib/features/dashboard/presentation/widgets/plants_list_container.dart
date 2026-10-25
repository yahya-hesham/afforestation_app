import 'package:afforestation_app/core/functions/extenstion.dart';
import 'package:afforestation_app/features/dashboard/data/models/plant_names_response.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : AppColors.surface;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black.withOpacity(0.04),
        ),
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
                    'add_plant'.tr(),
                    style: TextStyles.textButtonTextStyle.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
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
            color: isDark
                ? AppColors.secondary.withValues(alpha: 0.12)
                : AppColors.secondary.withOpacity(0.15),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'plant_name'.tr(),
                    style: TextStyles.listRowSubtitleStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFF81C784) : AppColors.primary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    'scientific_name'.tr(),
                    style: TextStyles.listRowSubtitleStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFF81C784) : AppColors.primary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'manage'.tr(),
                    style: TextStyles.listRowSubtitleStyle.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? const Color(0xFF81C784) : AppColors.primary,
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
                    "no_plants_in_section".tr(),
                    style: TextStyles.listRowSubtitleStyle.copyWith(
                      color: isDark ? Colors.white60 : null,
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: plants.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: isDark ? Colors.white12 : Colors.black12,
                  ),
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
                              plant.name ?? "",
                              style: TextStyles.listRowTitleStyle.copyWith(
                                color: isDark ? Colors.white : AppColors.onSurface,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              plant.scientificName ?? "",
                              style: TextStyles.listRowSubtitleStyle.copyWith(
                                fontStyle: FontStyle.italic,
                                color: isDark ? Colors.white70 : AppColors.onSurfaceVariant,
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
                                  child: Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                    color: isDark ? Colors.white70 : AppColors.onSurface,
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
