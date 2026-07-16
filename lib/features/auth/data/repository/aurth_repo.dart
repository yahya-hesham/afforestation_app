import 'package:afforestation_app/core/services/apis/apis.dart';
import 'package:afforestation_app/core/services/apis/dio_provider.dart';
import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/features/auth/data/models/auth_params.dart';
import 'package:afforestation_app/features/dashboard/data/models/auth_response/user.dart';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class AuthRepo {
  static Future<AuthParams?> login({
    required String email,
    required String password,
  }) async {
    try {
      var response = await DioProvider.post(
        endpoint: Apis.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        var data = AuthParams.fromJson(response.data);
        await SharedPref.saveToken(data.token);
        await SharedPref.saveRole(data.role);
      
        // Construct and save user info locally
        var user = User(
          id: data.id,
          email: data.email,
   
        );
        await SharedPref.saveUserInfo(user);
        
        return data;
      } else {
        return null;
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data ?? e.message}");
      return null;
    } catch (e) {
      debugPrint("Login error: $e");
      return null;
    }
  }

  static Future<String?> register({
    required String name,
    required String email,
    required String password,
    required int role,
  }) async {
    try {
      var response = await DioProvider.post(
        endpoint: Apis.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        },
      );

      if (response.statusCode == 200) {
        return response.data as String?;
      } else {
        return null;
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?.toString() ?? e.message;
      debugPrint("Dio error: $errorMsg");
      return Future.error(errorMsg ?? "Registration failed.");
    } catch (e) {
      debugPrint("Register error: $e");
      return Future.error(e.toString());
    }
  }
}