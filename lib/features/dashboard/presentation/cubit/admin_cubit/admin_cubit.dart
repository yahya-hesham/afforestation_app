import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afforestation_app/dashboard/data/repository/admin_repo.dart';
import 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminRepo adminRepo;

  AdminCubit(this.adminRepo) : super(AdminInitial());

  static AdminCubit get(context) => BlocProvider.of(context);

  // ---------------------- إضافة نوع نبات ----------------------
  Future<void> addPlantType({required String name}) async {
    emit(AddPlantTypeLoading());
    final result = await adminRepo.addPlantType(name: name);
    result.fold(
      (failure) => emit(AddPlantTypeError(failure.errMessage)),
      (plantType) => emit(AddPlantTypeSuccess(plantType)),
    );
  }

  // ---------------------- إضافة نوع موقع ----------------------
  Future<void> addLocationType({required String name}) async {
    emit(AddLocationTypeLoading());
    final result = await adminRepo.addLocationType(name: name);
    result.fold(
      (failure) => emit(AddLocationTypeError(failure.errMessage)),
      (locationType) => emit(AddLocationTypeSuccess(locationType)),
    );
  }

  // ---------------------- إضافة عملية تشجير ----------------------
  Future<void> addAfforestationOperation({
    required Map<String, dynamic> data,
  }) async {
    emit(AddAfforestationLoading());
    final result = await adminRepo.addAfforestationOperation(data: data);
    result.fold(
      (failure) => emit(AddAfforestationError(failure.errMessage)),
      (afforestation) => emit(AddAfforestationSuccess(afforestation)),
    );
  }

  // ---------------------- إضافة نبات ----------------------
  Future<void> addPlant({required Map<String, dynamic> data}) async {
    emit(AddPlantLoading());
    final result = await adminRepo.addPlant(data: data);
    result.fold(
      (failure) => emit(AddPlantError(failure.errMessage)),
      (plant) => emit(AddPlantSuccess(plant)),
    );
  }

  // ---------------------- إضافة موقع ----------------------
  Future<void> addLocation({required Map<String, dynamic> data}) async {
    emit(AddLocationLoading());
    final result = await adminRepo.addLocation(data: data);
    result.fold(
      (failure) => emit(AddLocationError(failure.errMessage)),
      (location) => emit(AddLocationSuccess(location)),
    );
  }

  // ---------------------- إضافة مستخدم جديد ----------------------
  Future<void> addUser({required Map<String, dynamic> data}) async {
    emit(AddUserLoading());
    final result = await adminRepo.addUser(data: data);
    result.fold(
      (failure) => emit(AddUserError(failure.errMessage)),
      (user) => emit(AddUserSuccess(user)),
    );
  }

  // ---------------------- إظهار المستخدمين ----------------------
  Future<void> getUsers() async {
    emit(GetUsersLoading());
    final result = await adminRepo.getUsers();
    result.fold(
      (failure) => emit(GetUsersError(failure.errMessage)),
      (users) => emit(GetUsersSuccess(users)),
    );
  }

  // ---------------------- إظهار كل النباتات ----------------------
  Future<void> getPlants() async {
    emit(GetPlantsLoading());
    final result = await adminRepo.getPlants();
    result.fold(
      (failure) => emit(GetPlantsError(failure.errMessage)),
      (plants) => emit(GetPlantsSuccess(plants)),
    );
  }

  // ---------------------- إظهار كل المواقع ----------------------
  Future<void> getLocations() async {
    emit(GetLocationsLoading());
    final result = await adminRepo.getLocations();
    result.fold(
      (failure) => emit(GetLocationsError(failure.errMessage)),
      (locations) => emit(GetLocationsSuccess(locations)),
    );
  }
}