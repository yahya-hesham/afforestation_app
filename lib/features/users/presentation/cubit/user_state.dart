import 'package:afforestation_app/features/users/data/models/user_model.dart';

abstract class UserState {}

class UserInitState extends UserState {}

class UserLoadingState extends UserState {}

class UserSuccessState extends UserState {
  final List<UserModel> users;
  final int totalCount;
  final int adminCount;

  UserSuccessState({
    required this.users,
    required this.totalCount,
    required this.adminCount,
  });
}

class UserErrorState extends UserState {
  final String message;

  UserErrorState(this.message);
}

class UserActionSuccessState extends UserState {
  final String message;

  UserActionSuccessState(this.message);
}
