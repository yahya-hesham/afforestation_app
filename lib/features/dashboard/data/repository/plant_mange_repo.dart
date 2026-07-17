import 'package:afforestation_app/core/services/apis/apis.dart';
import 'package:afforestation_app/core/services/apis/dio_provider.dart';
import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/features/dashboard/data/models/plant_names_response.dart';
import 'package:afforestation_app/features/dashboard/data/models/plant_types_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class MangeRepo {
  Future<List<PlantTypesResponse>> fetchPlantTypes() async {
    try {
      final token = SharedPref.getToken();
      var response = await DioProvider.get(
        endpoint: Apis.treeTypes,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => PlantTypesResponse.fromJson(json)).toList();
      } else {
        throw Exception('فشل في تحميل المستخدمين.');
      }
    } on DioException catch (e) {
      debugPrint("Dio error (fetchUsers): ${e.response?.data ?? e.message}");
      final errorMsg =
          e.response?.data?.toString() ??
          e.message ??
          'خطأ في تحميل المستخدمين';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("fetchUsers error: $e");
      rethrow;
    }
  }

  Future<List<PlantNamesResponse>> fetchPlantNames() async {
    try {
      final token = SharedPref.getToken();
      var response = await DioProvider.get(
        endpoint: Apis.treeNames,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => PlantNamesResponse.fromJson(json)).toList();
      } else {
        throw Exception('فشل في تحميل المستخدمين.');
      }
    } on DioException catch (e) {
      debugPrint("Dio error (fetchUsers): ${e.response?.data ?? e.message}");
      final errorMsg =
          e.response?.data?.toString() ??
          e.message ??
          'خطأ في تحميل المستخدمين';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("fetchUsers error: $e");
      rethrow;
    }
  }
}
