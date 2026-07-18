abstract class AddPlantState {}

class AddPlantInitial extends AddPlantState {}
class AddPlantLoading extends AddPlantState {}
class AddPlantSuccess extends AddPlantState {}
class AddPlantError extends AddPlantState {
  final String message;
  AddPlantError(this.message);
}