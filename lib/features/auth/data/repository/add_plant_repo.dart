import 'package:dio/dio.dart';

class AddPlantRepo {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://localhost:7197',
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static Future<void> addNewRecord({
    required String dateOfPlanted,
    required int treeTypeId,
    required int treeNameId,
    required int locationTypeId,
    required int locationNameId,
    required int userId,
    required int number,
    required String token, 
  }) async {
    try {
      await _dio.post(
        '/api/afforestation/Add', 
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          "dateOfPlanted": dateOfPlanted,
          "treeTypeId": treeTypeId,
          "treeNameId": treeNameId,
          "locationTypeId": locationTypeId,
          "locationNameId": locationNameId,
          "userId": userId,
          "number": number,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}