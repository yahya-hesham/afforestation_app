import 'package:afforestation_app/features/dashboard/data/models/loc_names_response.dart';
import 'package:afforestation_app/features/dashboard/data/models/loc_types_response.dart';
import 'package:afforestation_app/features/dashboard/data/models/plant_names_response.dart';
import 'package:afforestation_app/features/dashboard/data/models/plant_types_response.dart';

abstract class AddAfforestationState {}

class AddAfforestationInitialState extends AddAfforestationState {}

class AddAfforestationLoadingInitialState extends AddAfforestationState {}

class AddAfforestationInitialSuccessState extends AddAfforestationState {
  final List<PlantTypesResponse> plantTypes;
  final List<LocTypesResponse> locationTypes;

  AddAfforestationInitialSuccessState({
    required this.plantTypes,
    required this.locationTypes,
  });
}

class AddAfforestationLoadingPlantsState extends AddAfforestationState {}

class AddAfforestationPlantsLoadedState extends AddAfforestationState {
  final List<PlantNamesResponse> plantNames;

  AddAfforestationPlantsLoadedState(this.plantNames);
}

class AddAfforestationPlantNameSelectedState extends AddAfforestationState {
  final PlantNamesResponse? plantName;

  AddAfforestationPlantNameSelectedState(this.plantName);
}

class AddAfforestationLoadingLocationsState extends AddAfforestationState {}

class AddAfforestationLocationsLoadedState extends AddAfforestationState {
  final List<LocNamesResponse> locations;

  AddAfforestationLocationsLoadedState(this.locations);
}

class AddAfforestationLocationAddressSelectedState extends AddAfforestationState {
  final LocNamesResponse? locationAddress;

  AddAfforestationLocationAddressSelectedState(this.locationAddress);
}

class AddAfforestationSubmittingState extends AddAfforestationState {}

class AddAfforestationSubmitSuccessState extends AddAfforestationState {
  final String message;

  AddAfforestationSubmitSuccessState(this.message);
}

class AddAfforestationErrorState extends AddAfforestationState {
  final String message;

  AddAfforestationErrorState(this.message);
}