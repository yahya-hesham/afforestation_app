import 'package:afforestation_app/features/dashboard/data/models/loc_types_response.dart';
import 'package:afforestation_app/features/dashboard/data/repository/plant_mange_repo.dart';
import 'package:afforestation_app/features/dashboard/presentation/cubit/location_mange_cubit/loc_manage_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationManageCubit extends Cubit<LocationManagementState> {
  LocationManageCubit() : super(LocationManagementInitial());

  Future<void> loadDashboard() async {
    emit(LocationManagementLoading());
    try {
      // BUG FIX: was calling the misspelled `fetchLocaTypes()`, which
      // doesn't exist on MangeRepo.
      final types = await MangeRepo.fetchLocTypes();
      final allLocations = await MangeRepo.fetchAllLocations();

      if (types.isNotEmpty) {
        final defaultCategory = types.first;
        final filtered = allLocations
            .where((loc) => loc.locationTypeId == defaultCategory.id)
            .toList();

        emit(
          LocationManagementSuccess(
            categories: types,
            selectedCategory: defaultCategory,
            locations: filtered,
            totalLocationsCount: allLocations.length,
          ),
        );
      } else {
        emit(
          LocationManagementSuccess(
            categories: [],
            selectedCategory: LocTypesResponse(id: 0, locationType: ''),
            locations: [],
            totalLocationsCount: allLocations.length,
          ),
        );
      }
    } catch (e) {
      emit(LocationManagementFailure(e.toString()));
    }
  }

  Future<void> selectCategory(LocTypesResponse category) async {
    if (state is! LocationManagementSuccess) return;
    final currentState = state as LocationManagementSuccess;

    // Switch the highlighted chip immediately; keep showing the previous
    // list underneath while the new one loads.
    emit(currentState.copyWith(selectedCategory: category, isMutating: true));

    try {
      final allLocations = await MangeRepo.fetchAllLocations();
      final filtered = allLocations
          .where((loc) => loc.locationTypeId == category.id)
          .toList();

      emit(
        LocationManagementSuccess(
          categories: currentState.categories,
          selectedCategory: category,
          locations: filtered,
          totalLocationsCount: allLocations.length,
        ),
      );
    } catch (e) {
      emit(LocationManagementFailure("فشل تحميل المواقع: ${e.toString()}"));
    }
  }

  Future<void> addLocation(String name) async {
    if (state is! LocationManagementSuccess) return;
    final currentState = state as LocationManagementSuccess;
    emit(currentState.copyWith(isMutating: true));

    try {
      await MangeRepo.addLocation(
        name: name,
        typeId: currentState.selectedCategory.id ?? 0,
      );
      await _refresh();
    } catch (e) {
      emit(LocationManagementFailure("فشل في إضافة الموقع: ${e.toString()}"));
    }
  }

  Future<void> editLocation({
    required int id,
    required String newName,
  }) async {
    if (state is! LocationManagementSuccess) return;
    final currentState = state as LocationManagementSuccess;
    emit(currentState.copyWith(isMutating: true));

    try {
      await MangeRepo.updateLocation(id: id, name: newName);
      await _refresh();
    } catch (e) {
      emit(LocationManagementFailure("فشل في تعديل الموقع: ${e.toString()}"));
    }
  }

  Future<void> deleteLocation(int id) async {
    if (state is! LocationManagementSuccess) return;
    final currentState = state as LocationManagementSuccess;
    emit(currentState.copyWith(isMutating: true));

    try {
      await MangeRepo.deleteLocation(id);
      await _refresh();
    } catch (e) {
      emit(LocationManagementFailure("فشل في حذف الموقع: ${e.toString()}"));
    }
  }

  Future<void> _refresh() async {
    if (state is! LocationManagementSuccess) return;
    final currentState = state as LocationManagementSuccess;

    final allLocations = await MangeRepo.fetchAllLocations();
    final filtered = allLocations
        .where((loc) => loc.locationTypeId == currentState.selectedCategory.id)
        .toList();

    emit(
      LocationManagementSuccess(
        categories: currentState.categories,
        selectedCategory: currentState.selectedCategory,
        locations: filtered,
        totalLocationsCount: allLocations.length,
      ),
    );
  }
}