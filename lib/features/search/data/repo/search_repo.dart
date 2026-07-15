import 'package:afforestation_app/core/services/apis/apis.dart';
import 'package:afforestation_app/core/services/apis/dio_provider.dart';
import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/features/search/data/models/search_request_model.dart';
import 'package:afforestation_app/features/search/data/models/search_result_model.dart';
import 'package:afforestation_app/features/search/data/models/update_record_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SearchRepo {
  /// Calls POST /api/afforestation/search
  /// Returns full list — pagination is handled on the UI side.
  static Future<List<SearchResultModel>> search({
    required SearchRequestModel request,
  }) async {
    try {
      final token = SharedPref.getToken();
      var response = await DioProvider.post(
        endpoint: Apis.afforestationSearch,
        data: request.toJson(),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final list = response.data as List<dynamic>;
        return list
            .map((e) => SearchResultModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('فشل في البحث. الرجاء المحاولة مرة أخرى.');
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data ?? e.message}");
      final errorMsg =
          e.response?.data?.toString() ?? e.message ?? 'خطأ في الاتصال';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("Search error: $e");
      rethrow;
    }
  }

  /// Calls DELETE /api/afforestation/{id}
  static Future<void> deleteRecord(int id) async {
    try {
      final token = SharedPref.getToken();
      var response = await DioProvider.delete(
        endpoint: '${Apis.afforestation}/$id',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('فشل في حذف السجل.');
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data ?? e.message}");
      final errorMsg =
          e.response?.data?.toString() ?? e.message ?? 'خطأ في الحذف';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("Delete error: $e");
      rethrow;
    }
  }

  /// Calls PUT /api/afforestation/{id}
  static Future<void> updateRecord({
    required int id,
    required UpdateRecordModel data,
  }) async {
    try {
      final token = SharedPref.getToken();
      var response = await DioProvider.put(
        endpoint: '${Apis.afforestation}/$id',
        data: data.toJson(),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('فشل في تحديث السجل.');
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data ?? e.message}");
      final errorMsg =
          e.response?.data?.toString() ?? e.message ?? 'خطأ في التحديث';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("Update error: $e");
      rethrow;
    }
  }
}
