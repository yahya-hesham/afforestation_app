import 'package:afforestation_app/features/adding_plant/data/repository/add_plant_repo.dart';
import 'package:afforestation_app/features/adding_plant/presentation/cubit/add_plant_state.dart';
import 'package:afforestation_app/features/dashboard/data/models/plant_types_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPlantCubit extends Cubit<AddPlantState> {
  AddPlantCubit() : super(AddPlantInitialState());

  List<PlantTypesResponse> plantTypes = [];
  PlantTypesResponse? selectedPlantType;

  Future<void> fetchPlantTypes() async {
    emit(AddPlantLoadingTypesState());
    try {
      plantTypes = await AddPlantRepo.fetchPlantTypes();
      emit(AddPlantTypesSuccessState(plantTypes));
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').trim();
      emit(
        AddPlantErrorState(msg.isEmpty ? 'خطأ في تحميل أنواع النباتات' : msg),
      );
    }
  }

  void onPlantTypeChanged(PlantTypesResponse? type) {
    selectedPlantType = type;
  }

  Future<void> addPlant({
    required String arabicName,
    required String scientificName,
  }) async {
    if (arabicName.trim().isEmpty) {
      emit(AddPlantErrorState('يرجى إدخال اسم النبات باللغة العربية'));
      return;
    }
    if (selectedPlantType == null || selectedPlantType!.type == null) {
      emit(AddPlantErrorState('يرجى اختيار نوع النبتة من القائمة'));
      return;
    }

    emit(AddPlantSubmittingState());
    try {
      await AddPlantRepo.addPlant(
        name: arabicName.trim(),
        typeName: selectedPlantType!.type!,
        typeId: selectedPlantType!.id,
        scientificName: scientificName.trim(),
      );
      emit(AddPlantSuccessState('تم إضافة النبات بنجاح'));
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').trim();
      emit(AddPlantErrorState(msg.isEmpty ? 'فشل في إضافة النبات' : msg));
    }
  }
}
