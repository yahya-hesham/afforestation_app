import 'package:equatable/equatable.dart';
import 'package:afforestation_app/core/models/afforestation_model.dart';
import 'package:afforestation_app/dashboard/data/repository/models/plant_model.dart';
// ملاحظة: لو الموديلات دي لسه مش موجودة في الـ Models عندك، الـ VS Code هيجيب خط أحمر بسيط، هنعدلها أو نكريتها سوا في ثانية.

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

// ---------------------- Add Plant Type ----------------------
class AddPlantTypeLoading extends AdminState {}
class AddPlantTypeSuccess extends AdminState {
  final dynamic plantType; // استخدمنا dynamic مؤقتاً لتفادي إيرور الموديل الناقص
  const AddPlantTypeSuccess(this.plantType);
  @override
  List<Object?> get props => [plantType];
}
class AddPlantTypeError extends AdminState {
  final String message;
  const AddPlantTypeError(this.message);
  @override
  List<Object?> get props => [message];
}

// ---------------------- Add Location Type ----------------------
class AddLocationTypeLoading extends AdminState {}
class AddLocationTypeSuccess extends AdminState {
  final dynamic locationType;
  const AddLocationTypeSuccess(this.locationType);
  @override
  List<Object?> get props => [locationType];
}
class AddLocationTypeError extends AdminState {
  final String message;
  const AddLocationTypeError(this.message);
  @override
  List<Object?> get props => [message];
}

// ---------------------- Add Afforestation Operation ----------------------
class AddAfforestationLoading extends AdminState {}
class AddAfforestationSuccess extends AdminState {
  final AfforestationModel afforestation;
  const AddAfforestationSuccess(this.afforestation);
  @override
  List<Object?> get props => [afforestation];
}
class AddAfforestationError extends AdminState {
  final String message;
  const AddAfforestationError(this.message);
  @override
  List<Object?> get props => [message];
}

// ---------------------- Add Plant ----------------------
class AddPlantLoading extends AdminState {}
class AddPlantSuccess extends AdminState {
  final PlantModel plant;
  const AddPlantSuccess(this.plant);
  @override
  List<Object?> get props => [plant];
}
class AddPlantError extends AdminState {
  final String message;
  const AddPlantError(this.message);
  @override
  List<Object?> get props => [message];
}

// ---------------------- Add Location ----------------------
class AddLocationLoading extends AdminState {}
class AddLocationSuccess extends AdminState {
  final dynamic location;
  const AddLocationSuccess(this.location);
  @override
  List<Object?> get props => [location];
}
class AddLocationError extends AdminState {
  final String message;
  const AddLocationError(this.message);
  @override
  List<Object?> get props => [message];
}

// ---------------------- Add User ----------------------
class AddUserLoading extends AdminState {}
class AddUserSuccess extends AdminState {
  final dynamic user;
  const AddUserSuccess(this.user);
  @override
  List<Object?> get props => [user];
}
class AddUserError extends AdminState {
  final String message;
  const AddUserError(this.message);
  @override
  List<Object?> get props => [message];
}

// ---------------------- Get Users ----------------------
class GetUsersLoading extends AdminState {}
class GetUsersSuccess extends AdminState {
  final List<dynamic> users;
  const GetUsersSuccess(this.users);
  @override
  List<Object?> get props => [users];
}
class GetUsersError extends AdminState {
  final String message;
  const GetUsersError(this.message);
  @override
  List<Object?> get props => [message];
}

// ---------------------- Get Plants ----------------------
class GetPlantsLoading extends AdminState {}
class GetPlantsSuccess extends AdminState {
  final List<PlantModel> plants;
  const GetPlantsSuccess(this.plants);
  @override
  List<Object?> get props => [plants];
}
class GetPlantsError extends AdminState {
  final String message;
  const GetPlantsError(this.message);
  @override
  List<Object?> get props => [message];
}

// ---------------------- Get Locations ----------------------
class GetLocationsLoading extends AdminState {}
class GetLocationsSuccess extends AdminState {
  final List<dynamic> locations;
  const GetLocationsSuccess(this.locations);
  @override
  List<Object?> get props => [locations];
}
class GetLocationsError extends AdminState {
  final String message;
  const GetLocationsError(this.message);
  @override
  List<Object?> get props => [message];
}