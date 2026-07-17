import 'package:afforestation_app/features/auth/data/repository/aurth_repo.dart';
import 'package:afforestation_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  String currentRole = 'مستخدم عادي (User)';
  List<String> roles = ['مستخدم عادي (User)', 'مستخدم مسؤول (Admin)'];

  void changeRole(String newRole) {
    currentRole = newRole;
    emit(RoleChangedState());
  }

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      var result = await AuthRepo.login(email: email, password: password);

      if (result != null) {
        emit(AuthSucess());
      } else {
        emit(
          AuthError(
            'فشل تسجيل الدخول. يرجى التحقق من صحة البريد الإلكتروني أو كلمة المرور.',
          ),
        );
      }
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    emit(AuthLoading());
    try {
      // Map String role selection to enum values (0 = Admin, 1 = User)
      int roleId = role == 'مستخدم مسؤول (Admin)' ? 0 : 1;

      await AuthRepo.register(
        name: fullName,
        email: email,
        password: password,
        role: roleId,
      );

      emit(AuthSucess());
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }
}
