import 'package:afforestation_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:afforestation_app/features/dashboard/presentation/cubit/plant_manage_cubit/plant_manage_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlantManageCubit extends Cubit<PlantManagementState> {
  PlantManageCubit() : super(PlantManagementInitial());

  String currentRole = 'مستخدم عادي (User)';
  List<String> roles = ['مستخدم عادي (User)', 'مستخدم مسؤول (Admin)'];

  // void changeRole(String newRole) {
  //   currentRole = newRole;
  //   emit(RoleChangedState());
  // }

  Future<void> loadDashboard() async {
    emit(PlantManagementLoading());
    try {
      final plant_types = await await Future.delayed(
        const Duration(seconds: 2),
      );
      //api call

      emit(PlantManagementSuccess());
    } catch (error) {
      emit(PlantManagementFailure());
    }
  }
}
