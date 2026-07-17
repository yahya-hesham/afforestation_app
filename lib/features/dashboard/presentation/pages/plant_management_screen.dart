import 'package:afforestation_app/features/dashboard/data/models/plant_names_response.dart';
import 'package:afforestation_app/features/dashboard/presentation/cubit/plant_manage_cubit/plant_manage_cubit.dart';
import 'package:afforestation_app/features/dashboard/presentation/cubit/plant_manage_cubit/plant_manage_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Your existing imports
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';
import 'package:afforestation_app/features/dashboard/presentation/widgets/category_selection_card.dart';
import 'package:afforestation_app/features/dashboard/presentation/widgets/plant_app_bar.dart';
import 'package:afforestation_app/features/dashboard/presentation/widgets/plants_list_container.dart';
import 'package:afforestation_app/features/dashboard/presentation/widgets/screen_header.dart';

// Import your Cubit, States, and Repository
// (Adjust these paths according to your actual folder structure)

class PlantManagementScreen extends StatelessWidget {
  const PlantManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // FIXED: Added the cascade operator (..loadDashboard()) to trigger the API fetch immediately
      create: (context) => PlantManageCubit()..loadDashboard(),
      child: const PlantManagementView(),
    );
  }
}

class PlantManagementView extends StatelessWidget {
  const PlantManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const PlantAppBar(),
        body: BlocConsumer<PlantManageCubit, PlantManagementState>(
          // Listen to state changes for one-off tasks (like snackbars or side-effects)
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
          // Restrict UI rebuilding to only structural dashboard states
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
            // State 1: Full-Screen Loading
            if (state is PlantManagementLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            // State 2: Full-Screen Error
            if (state is PlantManagementFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'حدث خطأ ما أثناء تحميل البيانات.',
                      style: TextStyles.buttonTextStyle.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        context.read<PlantManageCubit>().loadDashboard();
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            // State 3: Content Loaded Successfully
            if (state is PlantManagementSuccess) {
              // Find the index of the selected category to pass to the CategorySelectionCard
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

                    // --- Dynamic Category Selection ---
                    CategorySelectionCard(
                      types:
                          state.categories, // Passes List<PlantTypesResponse>
                      selectedIndex: selectedIndex == -1 ? 0 : selectedIndex,
                      onCategorySelected: (index) {
                        final chosenCategory = state.categories[index];
                        // Trigger Cubit filter action
                        context.read<PlantManageCubit>().selectCategory(
                          chosenCategory,
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // --- Dynamic Filtered Plants List ---
                    PlantsListContainer(
                      categoryTitle:
                          state.selectedCategory.type ??
                          '', // Displays the API category type text (e.g. SHRUBS)
                      plants: state
                          .plants, // Passes List<PlantNamesResponse> containing scientific names and IDs
                      onEdit: (plant) {
                        _showEditPlantSheet(context, plant);
                      },
                      onDelete: (plant) {
                        _confirmDeletePlant(context, plant);
                      },
                      onAddPlant: () {
                        _showAddPlantSheet(
                          context,
                          state.selectedCategory.type ?? '',
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // --- Bottom Button ---
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        foregroundColor: AppColors.primary,
                        elevation: 0,
                        side: const BorderSide(color: Colors.black12),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'عرض التقارير التفصيلية',
                        style: TextStyles.buttonTextStyle.copyWith(
                          color: AppColors.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            // Fallback placeholder
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

Future<void> _showAddPlantSheet(
  BuildContext context,
  String categoryTypeName,
) async {
  final cubit = context.read<PlantManageCubit>();
  final nameController = TextEditingController();
  final sciNameController = TextEditingController();

  final result = await showModalBottomSheet<Map<String, String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
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
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'إضافة نبات جديد ($categoryTypeName)',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'اسم النبات *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: sciNameController,
                decoration: InputDecoration(
                  labelText: 'الاسم العلمي',
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
                child: const Text('إضافة', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
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

  final result = await showModalBottomSheet<Map<String, String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
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
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'تعديل بيانات النبات',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'اسم النبات',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: sciNameController,
                decoration: InputDecoration(
                  labelText: 'الاسم العلمي',
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
                child: const Text('حفظ التعديلات', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
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

Future<void> _confirmDeletePlant(
  BuildContext context,
  PlantNamesResponse plant,
) async {
  final cubit = context.read<PlantManageCubit>();

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('حذف النبات'),
        content: Text('هل أنت متأكد أنك تريد حذف "${plant.name ?? ''}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ),
  );

  if (confirmed == true) {
    cubit.deletePlant(plant.id ?? 0);
  }
}
