class AuthState {}

class AuthInitialState extends AuthState {}

//login states
class LoginLoading extends AuthState {}

class LoginError extends AuthState {}

class LoginSuccess extends AuthState {}

// register states
class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {}

class RoleChangedState extends AuthState {}

class RegisterFailure extends AuthState {
  final String errorMessage;
  RegisterFailure(this.errorMessage);
}
