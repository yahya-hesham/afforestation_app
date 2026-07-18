import 'package:afforestation_app/core/services/apis/apis.dart';
import 'package:afforestation_app/core/services/apis/dio_provider.dart';
import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/features/users/data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class UserManagementRepo {
  static Future<List<UserModel>> fetchUsers() async {
    try {
      final token = SharedPref.getToken();
      var response = await DioProvider.get(
        endpoint: Apis.users,
        headers: token != null && token.isNotEmpty
            ? {'Authorization': 'Bearer $token'}
            : null,
      );

      if (response.statusCode == 200) {
        final list = response.data as List<dynamic>;
        return list
            .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('فشل في تحميل قائمة المستخدمين.');
      }
    } on DioException catch (e) {
      debugPrint("Dio error (fetchUsers): ${e.response?.data ?? e.message}");
      final errorMsg = e.response?.data?.toString() ??
          e.message ??
          'خطأ في تحميل المستخدمين';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("fetchUsers error: $e");
      rethrow;
    }
  }

  static Future<void> deleteUser(int id) async {
    try {
      final token = SharedPref.getToken();
      final response = await DioProvider.delete(
        endpoint: '${Apis.userDelete}/$id',
        headers: token != null && token.isNotEmpty
            ? {'Authorization': 'Bearer $token'}
            : null,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('فشل في حذف المستخدم.');
      }
    } on DioException catch (e) {
      try {
        final token = SharedPref.getToken();
        final response = await DioProvider.delete(
          endpoint: Apis.userDelete,
          queryParameters: {'id': id},
          headers: token != null && token.isNotEmpty
              ? {'Authorization': 'Bearer $token'}
              : null,
        );
        if (response.statusCode != 200 && response.statusCode != 204) {
          throw Exception('فشل في حذف المستخدم.');
        }
      } catch (_) {
        debugPrint("Dio error (deleteUser): ${e.response?.data ?? e.message}");
        final errorMsg =
            e.response?.data?.toString() ?? e.message ?? 'خطأ في حذف المستخدم';
        throw Exception(errorMsg);
      }
    } catch (e) {
      debugPrint("deleteUser error: $e");
      rethrow;
    }
  }

  static Future<void> updateUser({
    required int id,
    required String name,
    required String email,
    required int role,
  }) async {
    try {
      final token = SharedPref.getToken();
      final response = await DioProvider.put(
        endpoint: Apis.userUpdate,
        data: {
          'id': id,
          'name': name,
          'email': email,
          'role': role,
        },
        headers: token != null && token.isNotEmpty
            ? {'Authorization': 'Bearer $token'}
            : null,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('فشل في تحديث بيانات المستخدم.');
      }
    } on DioException catch (e) {
      debugPrint("Dio error (updateUser): ${e.response?.data ?? e.message}");
      final errorMsg =
          e.response?.data?.toString() ?? e.message ?? 'خطأ في تحديث البيانات';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("updateUser error: $e");
      rethrow;
    }
  }
}
