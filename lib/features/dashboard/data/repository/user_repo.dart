import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/api/api_consumer.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/end_points.dart';
import '../../../../core/models/afforestation_model.dart';
import '../../../../core/cache/cache_helper.dart';

class UserRepo {
  final ApiConsumer api;

  UserRepo(this.api);

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

  // ---------------------- تسجيل الخروج ----------------------
  Future<Either<Failure, Unit>> logout() async {
    try {
      await api.post(path: EndPoints.logout);
      await CacheHelper.removeData(key: 'token'); // ⚠️ تأكد لو زميلك مستخدم key تاني غير 'token'
      return const Right(unit);
    } on DioException catch (e) {
      await CacheHelper.removeData(key: 'token');
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      await CacheHelper.removeData(key: 'token');
      return Left(ServerFailure(e.toString()));
    }
  }
}