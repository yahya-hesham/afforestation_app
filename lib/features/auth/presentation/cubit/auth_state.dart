class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSucess extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class RoleChangedState extends AuthState {}
