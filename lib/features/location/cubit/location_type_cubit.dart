import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afforestation_app/features/location/data/service/location_service.dart';
import 'location_cubit_state.dart/location_type_state.dart';

class LocationTypeCubit extends Cubit<LocationTypeState> {
  final LocationService _locationService = LocationService();

  LocationTypeCubit() : super(LocationTypeInitial());

  Future<void> addNewType(String typeName) async {
    emit(AddLocationTypeLoading());
    try {
      final newType = await _locationService.addNewLocationType(typeName);
      emit(AddLocationTypeSuccess(newType));
      fetchAllTypes();
    } catch (e) {
      emit(AddLocationTypeFailure(e.toString()));
    }
  }

  Future<void> fetchAllTypes() async {
    emit(GetLocationTypesLoading());
    try {
      final list = await _locationService.getAllLocationTypes();
      emit(GetLocationTypesSuccess(list));
    } catch (e) {
      emit(GetLocationTypesFailure(e.toString()));
    }
  }

  Future<void> deleteType(int id) async {
    emit(DeleteLocationTypeLoading());
    try {
      await _locationService.deleteLocationType(id);
      emit(DeleteLocationTypeSuccess(id));
      fetchAllTypes();
    } catch (e) {
      emit(DeleteLocationTypeFailure(e.toString()));
    }
  }

  Future<void> editType(int id, String newName) async {
    emit(EditLocationTypeLoading());
    try {
      final updated = await _locationService.editLocationType(id, newName);
      emit(EditLocationTypeSuccess(updated));
      fetchAllTypes();
    } catch (e) {
      emit(EditLocationTypeFailure(e.toString()));
    }
  }
}
