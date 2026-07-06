import 'package:afforestation_app/feautures/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

    Future <void> register({
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
