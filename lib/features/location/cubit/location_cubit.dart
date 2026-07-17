import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afforestation_app/features/location/data/model/location_model.dart';
import 'package:afforestation_app/features/location/data/service/location_service.dart';
import 'location_cubit_state.dart/location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationService _locationService = LocationService();

  LocationCubit() : super(LocationInitial());

  Future<void> addNewLocation(LocationModel location) async {
    emit(AddLocationLoading());
    try {
      await _locationService.addNewLocation(location);
      emit(AddLocationSuccess());
    } catch (e) {
      emit(AddLocationFailure(e.toString()));
    }
  }
}
