import 'package:afforestation_app/features/users/data/models/user_model.dart';
import 'package:afforestation_app/features/users/data/repository/user_management_repo.dart';
import 'package:afforestation_app/features/users/presentation/cubit/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitState());

  List<UserModel> usersList = [];

  Future<void> getUsers() async {
    emit(UserLoadingState());
    try {
      usersList = await UserManagementRepo.fetchUsers();
      _emitSuccess();
    } catch (e) {
      emit(UserErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await UserManagementRepo.deleteUser(id);
      usersList.removeWhere((u) => u.id == id);
      emit(UserActionSuccessState('تم حذف المستخدم بنجاح'));
      _emitSuccess();
    } catch (e) {
      emit(UserErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> updateUser({
    required int id,
    required String name,
    required String email,
    required int role,
  }) async {
    try {
      await UserManagementRepo.updateUser(
        id: id,
        name: name,
        email: email,
        role: role,
      );
      emit(UserActionSuccessState('تم تحديث بيانات المستخدم بنجاح'));
      await getUsers();
    } catch (e) {
      emit(UserErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void _emitSuccess() {
    final totalCount = usersList.length;
    final adminCount =
        usersList.where((u) => u.roleId == 0 || u.role == 'مشرف').length;
    emit(
      UserSuccessState(
        users: List.unmodifiable(usersList),
        totalCount: totalCount,
        adminCount: adminCount,
      ),
    );
  }
}
