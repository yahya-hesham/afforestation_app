import 'package:afforestation_app/core/services/apis/apis.dart';
import 'package:afforestation_app/core/services/apis/dio_provider.dart';
import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/features/dashboard/data/models/plant_types_response.dart';
import 'package:afforestation_app/features/dashboard/data/repository/plant_mange_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AddPlantRepo {
  /// Fetches all plant types from API (/TreeType/GetAllTreeType)
  static Future<List<PlantTypesResponse>> fetchPlantTypes() async {
    try {
      final types = await MangeRepo.fetchPlantTypes();
      if (types.isNotEmpty) {
        return types;
      }
    } catch (e) {
      debugPrint("fetchPlantTypes API warning: $e");
    }
    return [
      PlantTypesResponse(id: 1, type: 'أشجار'),
      PlantTypesResponse(id: 2, type: 'شجيرات'),
      PlantTypesResponse(id: 3, type: 'نباتات عشبية'),
      PlantTypesResponse(id: 4, type: 'متسلقات'),
    ];
  }

  /// Adds a new plant (tree) name to the backend API (/Tree/Add)
  static Future<void> addPlant({
    required String name,
    required String typeName,
    int? typeId,
    String? scientificName,
  }) async {
    try {
      final token = SharedPref.getToken();
      final response = await DioProvider.post(
        endpoint: Apis.treeAdd,
        data: {
          'name': name,
          'treeName': name,
          'treeTypeName': typeName,
          'typeId': typeId,
          'treeTypeId': typeId,
          if (scientificName != null && scientificName.trim().isNotEmpty)
            'scientificName': scientificName,
        },
        headers: token.isNotEmpty ? {'Authorization': 'Bearer $token'} : null,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('فشل في إضافة النبات.');
      }
    } on DioException catch (e) {
      debugPrint("Dio error (addPlant): ${e.response?.data ?? e.message}");
      final errorMsg = _extractError(e.response?.data, e.message);
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("addPlant error: $e");
      rethrow;
    }
  }

  static String _extractError(dynamic data, String? dioMessage) {
    if (data != null) {
      if (data is String && data.trim().isNotEmpty) return data;
      if (data is Map) {
        if (data['message'] != null &&
            data['message'].toString().trim().isNotEmpty) {
          return data['message'].toString();
        }
        if (data['title'] != null &&
            data['title'].toString().trim().isNotEmpty) {
          return data['title'].toString();
        }
        if (data['error'] != null &&
            data['error'].toString().trim().isNotEmpty) {
          return data['error'].toString();
        }
        if (data['errors'] != null) {
          return data['errors'].toString();
        }
      }
    }
    if (dioMessage != null && dioMessage.trim().isNotEmpty) return dioMessage;
    return 'خطأ في الاتصال بالخادم عند إضافة النبات';
  }
}
