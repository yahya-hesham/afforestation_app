import 'package:afforestation_app/core/services/apis/apis.dart';
import 'package:afforestation_app/core/services/apis/dio_provider.dart';
import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/features/add_affrostation/data/models/add_afforestation_request_model.dart';
import 'package:afforestation_app/features/dashboard/data/models/loc_names_response.dart';
import 'package:afforestation_app/features/dashboard/data/models/loc_types_response.dart';
import 'package:afforestation_app/features/dashboard/data/models/plant_names_response.dart';
import 'package:afforestation_app/features/dashboard/data/models/plant_types_response.dart';
import 'package:afforestation_app/features/dashboard/data/repository/plant_mange_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AddAfforestationRepo {
  static Future<List<PlantTypesResponse>> fetchPlantTypes() async {
    return await MangeRepo.fetchPlantTypes();
  }

  static Future<List<PlantNamesResponse>> fetchTreeNamesByType(int typeId) async {
    return await MangeRepo.fetchTreeNamesByType(typeId);
  }

  static Future<List<LocTypesResponse>> fetchLocationTypes() async {
    return await MangeRepo.fetchLocTypes();
  }

  static Future<List<LocNamesResponse>> fetchLocationsByTypeId(int typeId) async {
    final allLocations = await MangeRepo.fetchAllLocations();
    return allLocations.where((loc) => loc.locationTypeId == typeId).toList();
  }

  static Future<void> addAfforestationOperation({
    required AddAfforestationRequestModel request,
  }) async {
    try {
      final token = SharedPref.getToken();

      final response = await DioProvider.post(
        endpoint: Apis.afforestation,
        data: request.toJson(),
        headers: token.isNotEmpty ? {'Authorization': 'Bearer $token'} : null,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('فشل في إضافة عملية التشجير.');
      }
    } on DioException catch (e) {
      debugPrint("Dio error (addAfforestationOperation): ${e.response?.data ?? e.message}");
      final errorMsg = _extractError(e.response?.data, e.message);
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("addAfforestationOperation error: $e");
      rethrow;
    }
  }

  static String _extractError(dynamic data, String? dioMessage) {
    if (data != null) {
      if (data is String && data.trim().isNotEmpty) return data;
      if (data is Map) {
        if (data['message'] != null && data['message'].toString().trim().isNotEmpty) {
          return data['message'].toString();
        }
        if (data['title'] != null && data['title'].toString().trim().isNotEmpty) {
          return data['title'].toString();
        }
        if (data['error'] != null && data['error'].toString().trim().isNotEmpty) {
          return data['error'].toString();
        }
        if (data['errors'] != null) {
          return data['errors'].toString();
        }
      }
    }
    if (dioMessage != null && dioMessage.trim().isNotEmpty) return dioMessage;
    return 'خطأ في الاتصال بالخادم عند إضافة عملية التشجير';
  }
}
