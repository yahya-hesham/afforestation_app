  import 'package:afforestation_app/feautures/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

  class AuthCubit extends Cubit<AuthState> {
    AuthCubit() : super(AuthInitialState());

    String currentRole = 'مستخدم عادي (User)';
    List<String> roles = ['مستخدم عادي (User)', 'مستخدم مسؤول (Admin)'];

    void changeRole(String newRole) {
      currentRole = newRole;
      emit(RoleChangedState());
    }

    Future<void> register({
      required String fullName,
      required String email,
      required String password,
      required String role,
    }) async {
      emit(RegisterLoading());
      try {
        await Future.delayed(const Duration(seconds: 2));
        //api call

        emit(RegisterSuccess());
      } catch (error) {
        emit(RegisterFailure(error.toString()));
      }
    }
  }
