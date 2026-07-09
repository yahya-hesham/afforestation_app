import 'package:afforestation_app/features/dashboard/presentation/models/plant_model.dart';
import 'package:afforestation_app/features/dashboard/presentation/widgets/category_selection_card.dart';
import 'package:afforestation_app/features/dashboard/presentation/widgets/plant_app_bar.dart';
import 'package:afforestation_app/features/dashboard/presentation/widgets/plant_bottom_nav_bar.dart';
import 'package:afforestation_app/features/dashboard/presentation/widgets/plants_list_container.dart';
import 'package:afforestation_app/features/dashboard/presentation/widgets/screen_header.dart';
import 'package:flutter/material.dart';
import 'package:afforestation_app/core/styles/colors.dart';
import 'package:afforestation_app/core/styles/text_styles.dart';

class PlantManagementScreen extends StatefulWidget {
  const PlantManagementScreen({Key? key}) : super(key: key);

  @override
  State<PlantManagementScreen> createState() => _PlantManagementScreenState();
}

class _PlantManagementScreenState extends State<PlantManagementScreen> {
  int _selectedCategoryIndex = 0;

  
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const PlantAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ScreenHeader(),
              const SizedBox(height: 20),
              CategorySelectionCard(
                categories: PlantCategory.categories,
                selectedIndex: _selectedCategoryIndex,
                onCategorySelected: (index) {
                  setState(() => _selectedCategoryIndex = index);
                },
              ),
              const SizedBox(height: 20),
              PlantsListContainer(
                categoryTitle:
                    "${PlantCategory.categories[_selectedCategoryIndex].titleAr} (${PlantCategory.categories[_selectedCategoryIndex].titleEn})",
                plants: PlantItem.plants,
                onEdit: (plant) {
                  debugPrint("Editing: ${plant.nameAr}");
                },
                onDelete: (plant) {
                  setState(
                    () => PlantItem.plants.removeWhere((item) => item.id == plant.id),
                  );
                },
                onAddPlant: () {
                  debugPrint("Add Plant Clicked");
                },
              ),
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
        ),
        bottomNavigationBar: const PlantBottomNavigationBar(),
      ),
    );
  }
}
