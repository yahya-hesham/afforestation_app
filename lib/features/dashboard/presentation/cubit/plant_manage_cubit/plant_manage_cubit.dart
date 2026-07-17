import 'package:afforestation_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:afforestation_app/features/dashboard/data/models/plant_types_response.dart';
import 'package:afforestation_app/features/dashboard/data/repository/plant_mange_repo.dart';
import 'package:afforestation_app/features/dashboard/presentation/cubit/plant_manage_cubit/plant_manage_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlantManageCubit extends Cubit<PlantManagementState> {
  PlantManageCubit() : super(PlantManagementInitial());

  String currentRole = 'مستخدم عادي (User)';
  List<String> roles = ['مستخدم عادي (User)', 'مستخدم مسؤول (Admin)'];

  // void changeRole(String newRole) {
  //   currentRole = newRole;
  //   emit(RoleChangedState());
  // }

  // Future<void> loadDashboard() async {
  //   emit(PlantManagementLoading());
  //   try {
  //     final plant_types = await MangeRepo.fetchPlantTypes();
  //     await Future.delayed(const Duration(seconds: 2));
  //     //api call

  //     emit(PlantManagementSuccess());
  //   } catch (error) {
  //     emit(PlantManagementFailure());
  //   }
  // }
  Future<void> loadDashboard() async {
    emit(PlantManagementLoading());
    try {
      final categories = await MangeRepo.fetchPlantTypes();

      if (categories.isNotEmpty) {
        final defaultCategory = categories.first;
        // Fetch and filter plants for the default category
        final plants = await MangeRepo.fetchTreeNamesByType(
          defaultCategory.id ?? 0,
        );

        emit(
          PlantManagementSuccess(
            categories: categories,
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
}
