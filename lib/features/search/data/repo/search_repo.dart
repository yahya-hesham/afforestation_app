import 'package:afforestation_app/core/services/apis/apis.dart';
import 'package:afforestation_app/core/services/apis/dio_provider.dart';
import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/features/search/data/models/paginated_result_model.dart';
import 'package:afforestation_app/features/search/data/models/search_request_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class SearchRepo {
  static Future<PaginatedResultModel> search({
    required SearchRequestModel request,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final token = SharedPref.getToken();
      var response = await DioProvider.post(
        endpoint: Apis.afforestationSearch,
        data: request.toJson(),
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
        },
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return PaginatedResultModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('فشل في البحث. الرجاء المحاولة مرة أخرى.');
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data ?? e.message}");
      final errorMsg = e.response?.data?.toString() ?? e.message ?? 'خطأ في الاتصال';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("Search error: $e");
      rethrow;
    }
  }
}
