import 'package:equatable/equatable.dart';
import '../../../../../../core/models/afforestation_model.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

// ---------------------- Add Afforestation Operation ----------------------
class AddAfforestationLoading extends UserState {}

class AddAfforestationSuccess extends UserState {
  final AfforestationModel afforestation;
  const AddAfforestationSuccess(this.afforestation);
  @override
  List<Object?> get props => [afforestation];
}

class AddAfforestationError extends UserState {
  final String message;
  const AddAfforestationError(this.message);
  @override
  List<Object?> get props => [message];
}

// ---------------------- Logout ----------------------
class LogoutLoading extends UserState {}

class LogoutSuccess extends UserState {}

class LogoutError extends UserState {
  final String message;
  const LogoutError(this.message);
  @override
  List<Object?> get props => [message];
}