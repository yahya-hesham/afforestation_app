import 'dart:convert';
import 'package:afforestation_app/core/services/apis/apis.dart';
import 'package:afforestation_app/core/services/apis/dio_provider.dart';
import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/features/location/data/model/location_type_model.dart';
import 'package:afforestation_app/features/location/data/model/location_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LocationService {
  Future<List<LocationTypeModel>> getAllLocationTypes() async {
    try {
      final token = SharedPref.getToken();
      var response = await DioProvider.get(
        endpoint: Apis.locationTypes,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => LocationTypeModel.fromJson(json)).toList();
      } else {
        throw Exception('فشل في تحميل أنواع المواقع.');
      }
    } on DioException catch (e) {
      debugPrint(
        "Dio error (getAllLocationTypes): ${e.response?.data ?? e.message}",
      );
      final errorMsg =
          e.response?.data?.toString() ??
          e.message ??
          'خطأ في تحميل أنواع المواقع';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("getAllLocationTypes error: $e");
      rethrow;
    }
  }

  Future<LocationTypeModel> addNewLocationType(String typeName) async {
    try {
      final token = SharedPref.getToken();
      var response = await DioProvider.post(
        endpoint: Apis.addLocationType,
        data: {'locationType': typeName},
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return LocationTypeModel.fromJson(data);
        }
        if (data is String) {
          try {
            final decoded = jsonDecode(data);
            if (decoded is Map<String, dynamic>) {
              return LocationTypeModel.fromJson(decoded);
            }
          } catch (_) {}
        }
        throw Exception('فشل في إضافة نوع الموقع.');
      } else {
        throw Exception('فشل في إضافة نوع الموقع.');
      }
    } on DioException catch (e) {
      debugPrint(
        "Dio error (addNewLocationType): ${e.response?.data ?? e.message}",
      );
      final errorMsg =
          e.response?.data?.toString() ??
          e.message ??
          'خطأ في إضافة نوع الموقع';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("addNewLocationType error: $e");
      rethrow;
    }
  }

  Future<void> addNewLocation(LocationModel location) async {
    try {
      final token = SharedPref.getToken();
      var response = await DioProvider.post(
        endpoint: Apis.addLocation,
        data: location.toJson(),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('فشل في إضافة الموقع الجديد.');
      }
    } on DioException catch (e) {
      debugPrint(
        "Dio error (addNewLocation): ${e.response?.data ?? e.message}",
      );
      final errorMsg =
          e.response?.data?.toString() ?? e.message ?? 'خطأ في إضافة الموقع';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("addNewLocation error: $e");
      rethrow;
    }
  }

  Future<void> deleteLocationType(int id) async {
    try {
      final token = SharedPref.getToken();
      var response = await DioProvider.delete(
        endpoint: '${Apis.deleteLocationType}/$id',
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('فشل في حذف النوع.');
      }
    } on DioException catch (e) {
      debugPrint(
        "Dio error (deleteLocationType): ${e.response?.data ?? e.message}",
      );
      final errorMsg =
          e.response?.data?.toString() ?? e.message ?? 'خطأ في حذف النوع';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("deleteLocationType error: $e");
      rethrow;
    }
  }

  Future<LocationTypeModel> editLocationType(int id, String newName) async {
    try {
      final token = SharedPref.getToken();
      var response = await DioProvider.put(
        endpoint: '${Apis.editLocationType}/$id',
        data: {'locationType': newName},
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return LocationTypeModel.fromJson(data);
        }
        if (data is String) {
          try {
            final decoded = jsonDecode(data);
            if (decoded is Map<String, dynamic>) {
              return LocationTypeModel.fromJson(decoded);
            }
          } catch (_) {}
        }
        return LocationTypeModel(id: id, locationType: newName);
      } else {
        throw Exception('فشل في تعديل النوع.');
      }
    } on DioException catch (e) {
      debugPrint(
        "Dio error (editLocationType): ${e.response?.data ?? e.message}",
      );
      final errorMsg =
          e.response?.data?.toString() ?? e.message ?? 'خطأ في تعديل النوع';
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint("editLocationType error: $e");
      rethrow;
    }
  }
}
