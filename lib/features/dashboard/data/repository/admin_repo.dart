import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:afforestation_app/core/api/api_consumer.dart';
import 'package:afforestation_app/core/errors/failures.dart';
import 'package:afforestation_app/core/utils/end_points.dart';
import 'package:afforestation_app/core/models/afforestation_model.dart';
import 'package:afforestation_app/dashboard/data/repository/models/plant_model.dart';

class AdminRepo {
  final ApiConsumer api;

  AdminRepo(this.api);

  // ---------------------- إضافة نوع نبات ----------------------
  Future<Either<Failure, dynamic>> addPlantType({
    required String name,
  }) async {
    try {
      final response = await api.post(
        path: EndPoints.addPlantType,
        data: {'name': name},
      );
      return Right(response); // رجعنا الاستجابة مباشرة لتفادي كراش الموديل الناقص
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ---------------------- إضافة نوع موقع ----------------------
  Future<Either<Failure, dynamic>> addLocationType({
    required String name,
  }) async {
    try {
      final response = await api.post(
        path: EndPoints.addLocationType,
        data: {'name': name},
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ---------------------- إضافة عملية تشجير ----------------------
  Future<Either<Failure, AfforestationModel>> addAfforestationOperation({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await api.post(
        path: EndPoints.addAfforestationOperation,
        data: data,
      );
      return Right(AfforestationModel.fromJson(response));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ---------------------- إضافة نبات ----------------------
  Future<Either<Failure, PlantModel>> addPlant({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await api.post(
        path: EndPoints.addPlant,
        data: data,
      );
      return Right(PlantModel.fromJson(response));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ---------------------- إضافة موقع ----------------------
  Future<Either<Failure, dynamic>> addLocation({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await api.post(
        path: EndPoints.addLocation,
        data: data,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ---------------------- إضافة مستخدم جديد ----------------------
  Future<Either<Failure, dynamic>> addUser({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await api.post(
        path: EndPoints.addUser,
        data: data,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ---------------------- إظهار المستخدمين ----------------------
  Future<Either<Failure, List<dynamic>>> getUsers() async {
    try {
      final response = await api.get(path: EndPoints.getUsers);
      final List list = response is List ? response : (response['data'] ?? []);
      return Right(list);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ---------------------- إظهار كل النباتات ----------------------
  Future<Either<Failure, List<PlantModel>>> getPlants() async {
    try {
      final response = await api.get(path: EndPoints.getPlants);
      final List list = response is List ? response : (response['data'] ?? []);
      return Right(list.map((e) => PlantModel.fromJson(e)).toList());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ---------------------- إظهار كل المواقع ----------------------
  Future<Either<Failure, List<dynamic>>> getLocations() async {
    try {
      final response = await api.get(path: EndPoints.getLocations);
      final List list = response is List ? response : (response['data'] ?? []);
      return Right(list);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}