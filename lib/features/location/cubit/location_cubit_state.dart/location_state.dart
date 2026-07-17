abstract class LocationState {}

class LocationInitial extends LocationState {}

class AddLocationLoading extends LocationState {}

class AddLocationSuccess extends LocationState {}

class AddLocationFailure extends LocationState {
  final String errorMessage;
  AddLocationFailure(this.errorMessage);
}
