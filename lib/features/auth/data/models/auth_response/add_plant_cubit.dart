import 'package:afforestation_app/features/auth/data/models/auth_response/add_plant_state.dart';
import 'package:afforestation_app/features/auth/data/repository/add_plant_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AddPlantCubit extends Cubit<AddPlantState> {
  AddPlantCubit() : super(AddPlantInitial());

  Future<void> addNewRecord({
    required String dateOfPlanted,
    required int treeTypeId,
    required int treeNameId,
    required int locationTypeId,
    required int locationNameId,
    required int userId,
    required int number,
    required String token,
  }) async {
    emit(AddPlantLoading());
    try {
      await AddPlantRepo.addNewRecord(
        dateOfPlanted: dateOfPlanted,
        treeTypeId: treeTypeId,
        treeNameId: treeNameId,
        locationTypeId: locationTypeId,
        locationNameId: locationNameId,
        userId: userId,
        number: number,
        token: token,
      );
      emit(AddPlantSuccess());
    } catch (error) {
      emit(AddPlantError(error.toString()));
    }
  }

  void addNewTree({required String name, String? scientificName, required int typeId, required String token}) {}
}