class PlantManagementState {}

class PlantManagementInitial extends PlantManagementState {}

class PlantManagementLoading extends PlantManagementState {}

class PlantManagementSuccess extends PlantManagementState {}

class PlantManagementFailure extends PlantManagementState {}

// for buttons
class SelectedPlantState extends PlantManagementState {}

class PlantActionSuccess extends PlantManagementState {}

class PlantActionFailure extends PlantManagementState {}
