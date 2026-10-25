import 'package:afforestation_app/core/functions/extenstion.dart';
import 'package:afforestation_app/features/dashboard/data/models/plant_names_response.dart';
import 'package:afforestation_app/features/dashboard/presentation/cubit/plant_manage_cubit/plant_manage_cubit.dart';
import 'package:afforestation_app/features/dashboard/presentation/cubit/plant_manage_cubit/plant_manage_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';
import 'package:afforestation_app/features/dashboard/presentation/widgets/category_selection_card.dart';
import 'package:afforestation_app/features/dashboard/presentation/widgets/plant_app_bar.dart';
import 'package:afforestation_app/features/dashboard/presentation/widgets/plants_list_container.dart';
import 'package:afforestation_app/features/dashboard/presentation/widgets/screen_header.dart';

class PlantManagementScreen extends StatelessWidget {
  const PlantManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlantManageCubit()..loadDashboard(),
      child: const PlantManagementView(),
    );
  }
}

class PlantManagementView extends StatelessWidget {
  const PlantManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF121212) : AppColors.background;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: const PlantAppBar(),
      body: BlocConsumer<PlantManageCubit, PlantManagementState>(
        listener: (context, state) {
          if (state is PlantManagementFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        buildWhen: (previous, current) {
          if (current is PlantManagementFailure &&
              previous is PlantManagementSuccess) {
            return false;
          }
          return current is PlantManagementInitial ||
              current is PlantManagementLoading ||
              current is PlantManagementSuccess ||
              current is PlantManagementFailure;
        },
        builder: (context, state) {
          if (state is PlantManagementLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is PlantManagementFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'error_occurred'.tr(),
                    style: TextStyles.buttonTextStyle.copyWith(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PlantManageCubit>().loadDashboard();
                    },
                    child: Text('retry'.tr()),
                  ),
                ],
              ),
            );
          }

          if (state is PlantManagementSuccess) {
            final selectedIndex = state.categories.indexWhere(
              (cat) => cat.id == state.selectedCategory.id,
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ScreenHeader(),
                  const SizedBox(height: 20),

                  // Category Selection
                  CategorySelectionCard(
                    types: state.categories,
                    selectedIndex: selectedIndex == -1 ? 0 : selectedIndex,
                    onCategorySelected: (index) {
                      final chosenCategory = state.categories[index];
                      context.read<PlantManageCubit>().selectCategory(
                        chosenCategory,
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Plants List
                  PlantsListContainer(
                    categoryTitle: state.selectedCategory.type ?? '',
                    plants: state.plants,
                    onEdit: (plant) => _showEditPlantSheet(context, plant),
                    onDelete: (plant) => _confirmDelete(context, plant),
                    onAddPlant: () => _showAddPlantSheet(context, state),
                  ),
                  const SizedBox(height: 20),

                  // Detailed Reports Action Card
                  _buildReportActionCard(context, isDark),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildReportActionCard(BuildContext context, bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E1E1E) : AppColors.surface;

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.black.withOpacity(0.04),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2E7D32).withValues(alpha: 0.25)
                        : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.assessment_outlined,
                    color: Color(0xFF2E7D32),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'detailed_reports'.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            Icon(
              context.isArabic ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
              size: 14,
              color: isDark ? Colors.white38 : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showAddPlantSheet(
  BuildContext context,
  PlantManagementSuccess state,
) async {
  final cubit = context.read<PlantManageCubit>();
  final nameController = TextEditingController();
  final sciNameController = TextEditingController();
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final result = await showModalBottomSheet<Map<String, String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'add_new_plant_with_type'.tr(args: [state.selectedCategory.type ?? '']),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              autofocus: true,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                labelText: 'plant_name_required'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: sciNameController,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                labelText: 'scientific_name'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(sheetContext).pop({
                'name': nameController.text.trim(),
                'scientificName': sciNameController.text.trim(),
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'add'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );

  if (result != null && (result['name']?.isNotEmpty ?? false)) {
    cubit.addPlant(
      name: result['name']!,
      scientificName: result['scientificName'],
    );
  }
}

Future<void> _showEditPlantSheet(
  BuildContext context,
  PlantNamesResponse plant,
) async {
  final cubit = context.read<PlantManageCubit>();
  final nameController = TextEditingController(text: plant.name);
  final sciNameController = TextEditingController(text: plant.scientificName);
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final result = await showModalBottomSheet<Map<String, String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'edit_plant_data'.tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              autofocus: true,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                labelText: 'plant_name'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: sciNameController,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                labelText: 'scientific_name'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(sheetContext).pop({
                'name': nameController.text.trim(),
                'scientificName': sciNameController.text.trim(),
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'save_changes'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );

  if (result != null && (result['name']?.isNotEmpty ?? false)) {
    cubit.editPlant(
      id: plant.id ?? 0,
      newName: result['name']!,
      scientificName: result['scientificName'],
    );
  }
}

Future<void> _confirmDelete(
  BuildContext context,
  PlantNamesResponse plant,
) async {
  final cubit = context.read<PlantManageCubit>();

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('delete_plant_title'.tr()),
      content: Text('delete_plant_confirm'.tr(args: [plant.name ?? ''])),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text('cancel'.tr()),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text('delete'.tr(), style: const TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    cubit.deletePlant(plant.id ?? 0);
  }
}
