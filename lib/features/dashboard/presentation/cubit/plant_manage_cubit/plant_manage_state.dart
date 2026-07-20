import 'package:afforestation_app/features/dashboard/data/models/plant_names_response.dart';
import 'package:afforestation_app/features/dashboard/data/models/plant_types_response.dart';

class PlantManagementState {}

class PlantManagementInitial extends PlantManagementState {}

class PlantManagementLoading extends PlantManagementState {}

class PlantManagementSuccess extends PlantManagementState {
  final List<PlantTypesResponse> categories;
  final PlantTypesResponse selectedCategory;
  final List<PlantNamesResponse> plants;

  PlantManagementSuccess({
    required this.categories,
    required this.selectedCategory,
    required this.plants,
  });
}

class PlantManagementFailure extends PlantManagementState {
  final String errorMessage;
  PlantManagementFailure(this.errorMessage);
}
