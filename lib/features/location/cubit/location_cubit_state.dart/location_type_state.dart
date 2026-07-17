import 'package:afforestation_app/features/location/data/model/location_type_model.dart';

abstract class LocationTypeState {}

class LocationTypeInitial extends LocationTypeState {}

class AddLocationTypeLoading extends LocationTypeState {}

class AddLocationTypeSuccess extends LocationTypeState {
  final LocationTypeModel addedType;
  AddLocationTypeSuccess(this.addedType);
}

class AddLocationTypeFailure extends LocationTypeState {
  final String errorMessage;
  AddLocationTypeFailure(this.errorMessage);
}

class GetLocationTypesLoading extends LocationTypeState {}

class GetLocationTypesSuccess extends LocationTypeState {
  final List<LocationTypeModel> locationTypes;
  GetLocationTypesSuccess(this.locationTypes);
}

class GetLocationTypesFailure extends LocationTypeState {
  final String errorMessage;
  GetLocationTypesFailure(this.errorMessage);
}

class DeleteLocationTypeLoading extends LocationTypeState {}

class DeleteLocationTypeSuccess extends LocationTypeState {
  final int id;
  DeleteLocationTypeSuccess(this.id);
}

class DeleteLocationTypeFailure extends LocationTypeState {
  final String errorMessage;
  DeleteLocationTypeFailure(this.errorMessage);
}

class EditLocationTypeLoading extends LocationTypeState {}

class EditLocationTypeSuccess extends LocationTypeState {
  final LocationTypeModel updatedType;
  EditLocationTypeSuccess(this.updatedType);
}

class EditLocationTypeFailure extends LocationTypeState {
  final String errorMessage;
  EditLocationTypeFailure(this.errorMessage);
}
