import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afforestation_app/features/dashboard/data/repository/user_repo.dart';
import 'package:afforestation_app/features/dashboard/presentation/cubit/user_cudit/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepo userRepo;

  UserCubit(this.userRepo) : super(UserInitial());

  // ---------------------- إضافة عملية تشجير ----------------------
  Future<void> addAfforestationOperation({
    required Map<String, dynamic> data,
  }) async {
    emit(AddAfforestationLoading());
    final result = await userRepo.addAfforestationOperation(data: data);
    result.fold(
      (failure) => emit(AddAfforestationError(failure.errMessage)),
      (afforestation) => emit(AddAfforestationSuccess(afforestation)),
    );
  }

  // ---------------------- تسجيل الخروج ----------------------
  Future<void> logout() async {
    emit(LogoutLoading());
    final result = await userRepo.logout();
    result.fold(
      (failure) => emit(LogoutError(failure.errMessage)),
      (_) => emit(LogoutSuccess()),
    );
  }
}