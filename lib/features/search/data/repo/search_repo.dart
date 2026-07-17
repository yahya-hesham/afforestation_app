import 'package:afforestation_app/core/services/apis/apis.dart';
import 'package:afforestation_app/core/services/apis/dio_provider.dart';
import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/features/search/data/models/dropdown_item_model.dart';
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
        headers: {'Authorization': 'Bearer $token'},
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
        headers: {'Authorization': 'Bearer $token'},
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
        headers: {'Authorization': 'Bearer $token'},
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

  /// Fetches all users from GET /api/User/all
  static Future<List<DropdownItemModel>> fetchUsers() async {
    try {
      final token = SharedPref.getToken();
      var response = await DioProvider.get(
        endpoint: Apis.users,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final list = response.data as List<dynamic>;
        return list
            .map((e) => DropdownItemModel.fromJson(e as Map<String, dynamic>))
            .toList();
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

  /// Fetches all locations from GET /api/Location/all
  static Future<List<DropdownItemModel>> fetchLocations() async {
    try {
      final token = SharedPref.getToken();
      var response = await DioProvider.get(
        endpoint: Apis.locations,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final list = response.data as List<dynamic>;
        return list
            .map((e) => DropdownItemModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('فشل في تحميل المواقع.');
      }
    } on DioException catch (e) {
      debugPrint(
        "Dio error (fetchLocations): ${e.response?.data ?? e.message}",
      );
      final errorMsg =
          e.response?.data?.toString() ?? e.message ?? 'خطأ في تحميل المواقع';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("fetchLocations error: $e");
      rethrow;
    }
  }

  /// Fetches all tree names from GET /api/TreeName/all
  static Future<List<DropdownItemModel>> fetchTreeNames() async {
    try {
      final token = SharedPref.getToken();
      var response = await DioProvider.get(
        endpoint: Apis.treeNames,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final list = response.data as List<dynamic>;
        return list
            .map((e) => DropdownItemModel.fromJson(e as Map<String, dynamic>))
            .toList();
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

  /// Calls POST /api/afforestation/export
  /// Downloads Excel report as binary bytes (List<int>)
  static Future<List<int>> exportExcel({
    required SearchRequestModel request,
  }) async {
    try {
      final token = SharedPref.getToken();
      var response = await DioProvider.dio.post(
        Apis.afforestationExport,
        data: request.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data as List<int>;
      } else {
        throw Exception('فشل في تصدير ملف الإكسل.');
      }
    } on DioException catch (e) {
      debugPrint("Dio error (exportExcel): ${e.response?.data ?? e.message}");
      final errorMsg =
          e.response?.data?.toString() ?? e.message ?? 'خطأ في الاتصال بالخادم';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("exportExcel error: $e");
      rethrow;
    }
  }
}
