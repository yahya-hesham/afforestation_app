import 'package:afforestation_app/features/dashboard/data/models/plant_types_response.dart';

abstract class AddPlantState {}

class AddPlantInitialState extends AddPlantState {}

class AddPlantLoadingTypesState extends AddPlantState {}

class AddPlantTypesSuccessState extends AddPlantState {
  final List<PlantTypesResponse> plantTypes;

  AddPlantTypesSuccessState(this.plantTypes);
}

class AddPlantSubmittingState extends AddPlantState {}

class AddPlantSuccessState extends AddPlantState {
  final String message;

  AddPlantSuccessState(this.message);
}

class AddPlantErrorState extends AddPlantState {
  final String message;

  AddPlantErrorState(this.message);
}
