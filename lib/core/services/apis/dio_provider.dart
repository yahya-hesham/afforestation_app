// import 'package:counter_screen/feautures/auth/data/models/auth_response/auth_response.dart';
import 'package:dio/dio.dart';

class DioProvider {
  static late Dio dio;
  static void init() {
    dio = Dio();
  }


// post
  static Future<Response> post({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParamaters,
  }) {
    return dio.post(path, data: data, queryParameters: queryParamaters);
  }

  // put
  static Future<Response> put({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParamaters,
  }) {
    return dio.put(path, data: data, queryParameters: queryParamaters);
  }
  // get
  static Future<Response> get({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParamaters,
  }) {
    return dio.get(path, data: data, queryParameters: queryParamaters);
  }
}

