import 'package:afforestation_app/features/add_affrostation/data/models/add_afforestation_request_model.dart';
import 'package:afforestation_app/features/add_affrostation/data/repo/add_afforestation_repo.dart';
import 'package:afforestation_app/features/add_affrostation/presentation/cubit/add_afforestation_state.dart';
import 'package:afforestation_app/features/dashboard/data/models/loc_names_response.dart';
import 'package:afforestation_app/features/dashboard/data/models/loc_types_response.dart';
import 'package:afforestation_app/features/dashboard/data/models/plant_names_response.dart';
import 'package:afforestation_app/features/dashboard/data/models/plant_types_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddAfforestationCubit extends Cubit<AddAfforestationState> {
  AddAfforestationCubit() : super(AddAfforestationInitialState());

  List<PlantTypesResponse> plantTypes = [];
  List<PlantNamesResponse> plantNames = [];
  List<LocTypesResponse> locationTypes = [];
  List<LocNamesResponse> locations = [];

  PlantTypesResponse? selectedPlantType;
  PlantNamesResponse? selectedPlantName;
  LocTypesResponse? selectedLocationType;
  LocNamesResponse? selectedLocationAddress;

  Future<void> loadInitialData() async {
    emit(AddAfforestationLoadingInitialState());
    try {
      final plantTypesFuture = AddAfforestationRepo.fetchPlantTypes();
      final locTypesFuture = AddAfforestationRepo.fetchLocationTypes();

      final results = await Future.wait([plantTypesFuture, locTypesFuture]);

      plantTypes = results[0] as List<PlantTypesResponse>;
      locationTypes = results[1] as List<LocTypesResponse>;

      emit(
        AddAfforestationInitialSuccessState(
          plantTypes: plantTypes,
          locationTypes: locationTypes,
        ),
      );
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').trim();
      emit(AddAfforestationErrorState(msg.isEmpty ? 'خطأ في تحميل البيانات الأولية' : msg));
    }
  }

  Future<void> onPlantTypeChanged(PlantTypesResponse? plantType) async {
    selectedPlantType = plantType;
    selectedPlantName = null;
    plantNames = [];

    if (plantType?.id == null) return;

    emit(AddAfforestationLoadingPlantsState());
    try {
      plantNames = await AddAfforestationRepo.fetchTreeNamesByType(plantType!.id!);
      emit(AddAfforestationPlantsLoadedState(plantNames));
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').trim();
      emit(AddAfforestationErrorState(msg.isEmpty ? 'خطأ في تحميل أسماء النباتات' : msg));
    }
  }

  Future<void> onLocationTypeChanged(LocTypesResponse? locType) async {
    selectedLocationType = locType;
    selectedLocationAddress = null;
    locations = [];

    if (locType?.id == null) return;

    emit(AddAfforestationLoadingLocationsState());
    try {
      locations = await AddAfforestationRepo.fetchLocationsByTypeId(locType!.id!);
      emit(AddAfforestationLocationsLoadedState(locations));
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').trim();
      emit(AddAfforestationErrorState(msg.isEmpty ? 'خطأ في تحميل المواقع' : msg));
    }
  }

  void onPlantNameChanged(PlantNamesResponse? plantName) {
    selectedPlantName = plantName;
  }

  void onLocationAddressChanged(LocNamesResponse? location) {
    selectedLocationAddress = location;
  }

  Future<void> submit({
    required DateTime dateOfPlanted,
    required int number,
  }) async {
    if (selectedPlantType == null) {
      emit(AddAfforestationErrorState('يرجى اختيار نوع النبات'));
      return;
    }
    if (selectedPlantName == null) {
      emit(AddAfforestationErrorState('يرجى اختيار اسم النبات'));
      return;
    }
    if (selectedLocationType == null) {
      emit(AddAfforestationErrorState('يرجى اختيار نوع الموقع'));
      return;
    }
    if (selectedLocationAddress == null) {
      emit(AddAfforestationErrorState('يرجى اختيار موقع الزراعة'));
      return;
    }
    if (number <= 0) {
      emit(AddAfforestationErrorState('يرجى إدخال عدد نباتات أكبر من الصفر'));
      return;
    }

    emit(AddAfforestationSubmittingState());

    try {
      final request = AddAfforestationRequestModel(
        dateOfPlanted: dateOfPlanted,
        treeTypeId: selectedPlantType!.id!,
        treeNameId: selectedPlantName!.id!,
        locationTypeId: selectedLocationType!.id!,
        locationId: selectedLocationAddress!.id!,
        number: number,
      );

      await AddAfforestationRepo.addAfforestationOperation(request: request);
      emit(AddAfforestationSubmitSuccessState('تم إضافة عملية التشجير بنجاح'));
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').trim();
      emit(AddAfforestationErrorState(msg.isEmpty ? 'فشل في إضافة عملية التشجير' : msg));
    }
  }
}
