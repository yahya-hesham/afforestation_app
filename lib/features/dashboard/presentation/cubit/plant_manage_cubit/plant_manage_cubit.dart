import 'package:afforestation_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:afforestation_app/features/dashboard/data/models/plant_types_response.dart';
import 'package:afforestation_app/features/dashboard/data/repository/plant_mange_repo.dart';
import 'package:afforestation_app/features/dashboard/presentation/cubit/plant_manage_cubit/plant_manage_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlantManageCubit extends Cubit<PlantManagementState> {
  PlantManageCubit() : super(PlantManagementInitial());
  Future<void> loadDashboard() async {
    emit(PlantManagementLoading());
    try {
      final types = await MangeRepo.fetchPlantTypes();

      if (types.isNotEmpty) {
        final defaultCategory = types.first;
        // Fetch and filter plants for the default category
        final plants = await MangeRepo.fetchTreeNamesByType(
          defaultCategory.id ?? 0,
        );

        emit(
          PlantManagementSuccess(
            categories: types,
            selectedCategory: defaultCategory,
            plants: plants,
          ),
        );
      } else {
        emit(
          PlantManagementSuccess(
            categories: [],
            selectedCategory: PlantTypesResponse(id: 0, type: ''),
            plants: [],
          ),
        );
      }
    } catch (e) {
      emit(PlantManagementFailure(e.toString()));
    }
  }

  Future<void> selectCategory(PlantTypesResponse category) async {
    if (state is PlantManagementSuccess) {
      final currentState = state as PlantManagementSuccess;

      // Instantly change selection UI state while fetching the filtered data
      emit(
        PlantManagementSuccess(
          categories: currentState.categories,
          selectedCategory: category,
          plants: currentState.plants,
        ),
      );

      try {
        final filteredPlants = await MangeRepo.fetchTreeNamesByType(
          category.id ?? 0,
        );

        emit(
          PlantManagementSuccess(
            categories: currentState.categories,
            selectedCategory: category,
            plants: filteredPlants,
          ),
        );
      } catch (e) {
        emit(PlantManagementFailure("Failed to load plants: ${e.toString()}"));
      }
    }
  }

  Future<void> editPlant({
    required int id,
    required String newName,
    String? scientificName,
  }) async {
    if (state is! PlantManagementSuccess) return;
    final currentState = state as PlantManagementSuccess;

    try {
      await MangeRepo.updateTree(
        id: id,
        name: newName,
        scientificName: scientificName,
      );
      final updatedList = await MangeRepo.fetchTreeNamesByType(
        currentState.selectedCategory.id ?? 0,
      );
      emit(
        PlantManagementSuccess(
          categories: currentState.categories,
          selectedCategory: currentState.selectedCategory,
          plants: updatedList,
        ),
      );
    } catch (e) {
      emit(PlantManagementFailure("فشل في تعديل النبات: ${e.toString()}"));
    }
  }

  Future<void> deletePlant(int id) async {
    if (state is! PlantManagementSuccess) return;
    final currentState = state as PlantManagementSuccess;

    try {
      await MangeRepo.deleteTree(id);
      final updatedList = await MangeRepo.fetchTreeNamesByType(
        currentState.selectedCategory.id ?? 0,
      );
      emit(
        PlantManagementSuccess(
          categories: currentState.categories,
          selectedCategory: currentState.selectedCategory,
          plants: updatedList,
        ),
      );
    } catch (e) {
      final msg = e.toString().replaceFirst("Exception: ", "");
      emit(PlantManagementFailure(msg));
    }
  }

  Future<void> addPlant({
    required String name,
    String? scientificName,
  }) async {
    if (state is! PlantManagementSuccess) return;
    final currentState = state as PlantManagementSuccess;

    try {
      await MangeRepo.addTree(
        name: name,
        typeName: currentState.selectedCategory.type ?? '',
        scientificName: scientificName,
      );
      final updatedList = await MangeRepo.fetchTreeNamesByType(
        currentState.selectedCategory.id ?? 0,
      );
      emit(
        PlantManagementSuccess(
          categories: currentState.categories,
          selectedCategory: currentState.selectedCategory,
          plants: updatedList,
        ),
      );
    } catch (e) {
      final msg = e.toString().replaceFirst("Exception: ", "");
      emit(PlantManagementFailure(msg));
    }
  }
}
