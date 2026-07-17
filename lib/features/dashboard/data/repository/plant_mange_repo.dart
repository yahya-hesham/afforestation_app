import 'package:afforestation_app/core/services/apis/apis.dart';
import 'package:afforestation_app/core/services/apis/dio_provider.dart';
import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/features/dashboard/data/models/loc_names_response.dart';
import 'package:afforestation_app/features/dashboard/data/models/loc_types_response.dart';
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
      debugPrint(
        "Dio error (fetchPlantTypes): ${e.response?.data ?? e.message}",
      );
      final errorMsg =
          e.response?.data?.toString() ?? e.message ?? 'خطأ في أنواع النباتات';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("fetchPlantTypes error: $e");
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
        return allPlants.where((plant) => plant.typeId == plantId).toList();
      } else {
        throw Exception('فشل في تحميل أسماء النباتات.');
      }
    } on DioException catch (e) {
      debugPrint(
        "Dio error (fetchTreeNamesByType): ${e.response?.data ?? e.message}",
      );
      final errorMsg =
          e.response?.data?.toString() ?? e.message ?? 'خطأ في تحميل النباتات';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("fetchTreeNamesByType error: $e");
      rethrow;
    }
  }

  static Future<List<LocTypesResponse>> fetchLocTypes() async {
    try {
      final token = SharedPref.getToken();
      var response = await DioProvider.get(
        endpoint: Apis.locationTypes,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => LocTypesResponse.fromJson(json)).toList();
      } else {
        throw Exception('فشل في تحميل أنواع المواقع.');
      }
    } on DioException catch (e) {
      debugPrint("Dio error (fetchLocTypes): ${e.response?.data ?? e.message}");
      final errorMsg =
          e.response?.data?.toString() ??
          e.message ??
          'خطأ في تحميل أنواع المواقع';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("fetchLocTypes error: $e");
      rethrow;
    }
  }

  /// Fetches every location, unfiltered. Used to build the per-type list
  /// (filtered client-side, same approach the rest of this file already
  /// uses) and to compute the overall total shown at the bottom of the
  /// screen.
  static Future<List<LocNamesResponse>> fetchAllLocations() async {
    try {
      final token = SharedPref.getToken();
      var response = await DioProvider.get(
        endpoint: Apis.locations,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final list = response.data as List<dynamic>;
        return list
            .map((e) => LocNamesResponse.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('فشل في تحميل المواقع.');
      }
    } on DioException catch (e) {
      debugPrint(
        "Dio error (fetchAllLocations): ${e.response?.data ?? e.message}",
      );
      final errorMsg =
          e.response?.data?.toString() ?? e.message ?? 'خطأ في تحميل المواقع';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("fetchAllLocations error: $e");
      rethrow;
    }
  }

  static Future<List<LocNamesResponse>> fetchLocNamesByType(int locId) async {
    // BUG FIX: this used to call Apis.treeNames, so it was fetching trees
    // and filtering them by a location typeId. Now it fetches locations.
    final all = await fetchAllLocations();
    return all.where((location) => location.locationTypeId == locId).toList();
  }

  // --- The three methods below hit endpoints I couldn't verify against
  // your Postman collection (see the note in apis.dart). Please confirm
  // the path, HTTP verb, and expected body shape once you can check it,
  // and adjust here + in apis.dart if needed. They also assume DioProvider
  // exposes .post / .put / .delete with the same signature as .get -
  // add those if they don't exist yet. ---

  static Future<void> addLocation({
    required String name,
    required int typeId,
  }) async {
    try {
      final token = SharedPref.getToken();
      final response = await DioProvider.post(
        endpoint: Apis.locationAdd,
        data: {'name': name, 'locationTypeId': typeId},
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('فشل في إضافة الموقع.');
      }
    } on DioException catch (e) {
      debugPrint("Dio error (addLocation): ${e.response?.data ?? e.message}");
      final errorMsg =
          e.response?.data?.toString() ?? e.message ?? 'خطأ في إضافة الموقع';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("addLocation error: $e");
      rethrow;
    }
  }

  static Future<void> updateLocation({
    required int id,
    required String name,
    int? locationTypeId,
  }) async {
    try {
      final token = SharedPref.getToken();
      final Map<String, dynamic> body = {
        'id': id,
        'name': name,
      };
      if (locationTypeId != null && locationTypeId > 0) {
        body['locationTypeId'] = locationTypeId;
      }
      final response = await DioProvider.put(
        endpoint: Apis.locationUpdate,
        data: body,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('فشل في تعديل الموقع.');
      }
    } on DioException catch (e) {
      debugPrint(
        "Dio error (updateLocation): ${e.response?.data ?? e.message}",
      );
      final errorMsg =
          e.response?.data?.toString() ?? e.message ?? 'خطأ في تعديل الموقع';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("updateLocation error: $e");
      rethrow;
    }
  }

  static Future<void> deleteLocation(int id) async {
    try {
      final token = SharedPref.getToken();
      final response = await DioProvider.delete(
        endpoint: '${Apis.locationDelete}/$id',
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('فشل في حذف الموقع.');
      }
    } on DioException catch (e) {
      debugPrint(
        "Dio error (deleteLocation): ${e.response?.data ?? e.message}",
      );
      final errorMsg =
          e.response?.data?.toString() ?? e.message ?? 'خطأ في حذف الموقع';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("deleteLocation error: $e");
      rethrow;
    }
  }

  static Future<void> updateTree({
    required int id,
    required String name,
    String? scientificName,
  }) async {
    try {
      final token = SharedPref.getToken();
      final response = await DioProvider.put(
        endpoint: Apis.treeUpdate,
        data: {
          'id': id,
          'name': name,
          if (scientificName != null) 'scientificName': scientificName,
        },
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('فشل في تعديل النبات.');
      }
    } on DioException catch (e) {
      debugPrint("Dio error (updateTree): ${e.response?.data ?? e.message}");
      final errorMsg =
          e.response?.data?.toString() ?? e.message ?? 'خطأ في تعديل النبات';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("updateTree error: $e");
      rethrow;
    }
  }

  static Future<void> deleteTree(int id) async {
    try {
      final token = SharedPref.getToken();
      final response = await DioProvider.delete(
        endpoint: '${Apis.treeDelete}/$id',
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('فشل في حذف النبات.');
      }
    } on DioException catch (e) {
      debugPrint("Dio error (deleteTree): ${e.response?.data ?? e.message}");
      if (e.response?.statusCode == 500 || e.response?.statusCode == 400) {
        throw Exception(
          'النبات مسجل بعملية لا يمكنك مسح هذا النبات قم بمسح العملية أولاً',
        );
      }
      final errorMsg =
          e.response?.data?.toString() ?? e.message ?? 'خطأ في حذف النبات';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("deleteTree error: $e");
      rethrow;
    }
  }

  static Future<void> addTree({
    required String name,
    required String typeName,
    String? scientificName,
  }) async {
    try {
      final token = SharedPref.getToken();
      final response = await DioProvider.post(
        endpoint: Apis.treeAdd,
        data: {
          'treeName': name,
          'treeTypeName': typeName,
          if (scientificName != null) 'scientificName': scientificName,
        },
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('فشل في إضافة النبات.');
      }
    } on DioException catch (e) {
      debugPrint("Dio error (addTree): ${e.response?.data ?? e.message}");
      final errorMsg =
          e.response?.data?.toString() ?? e.message ?? 'خطأ في إضافة النبات';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("addTree error: $e");
      rethrow;
    }
  }
}