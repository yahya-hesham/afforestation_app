import 'package:afforestation_app/core/services/apis/apis.dart';
import 'package:afforestation_app/core/services/apis/dio_provider.dart';
import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/features/dashboard/data/models/plant_names_response.dart';
import 'package:afforestation_app/features/dashboard/data/models/plant_types_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class MangeRepo {
  static Future<List<PlantTypesResponse>> fetchPlantTypes() async {
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
        throw Exception('فشل في تحميل أنواع النباتات.');
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

  static Future<List<PlantNamesResponse>> fetchTreeNamesByType(
    int plantId,
  ) async {
    try {
      final token = SharedPref.getToken();
      var response = await DioProvider.get(
        endpoint: Apis.treeNames,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final list = response.data as List<dynamic>;
        final allPlants = list
            .map((e) => PlantNamesResponse.fromJson(e as Map<String, dynamic>))
            .toList();
        final filteredPlants = allPlants
            .where((plant) => plant.typeId == plantId)
            .toList();
        return filteredPlants;
      } else {
        throw Exception('فشل في تحميل أسماء النباتات.');
      }
    } on DioException catch (e) {
      debugPrint(
        "Dio error (fetchTreeNames): ${e.response?.data ?? e.message}",
      );
      final errorMsg =
          e.response?.data?.toString() ?? e.message ?? 'خطأ في تحميل النباتات';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("fetchTreeNames error: $e");
      rethrow;
    }
  }
}
