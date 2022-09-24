import 'package:dio/dio.dart';
import 'package:shopapp/shared/network/cacheHelper.dart';

class dioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://student.valuxapps.com/api/',
      receiveDataWhenStatusError: true,
    ));
  }

  static Future<Response> getData(String url,
      {Map<String, dynamic>? query,
      Map<String, dynamic>? data,
      String? token,
      String lang = 'en'}) async {
    dioHelper.dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token == null ? cacheHelper.getValue(key: 'token') : token,
    };
    return await dioHelper.dio.get(url, queryParameters: query);
  }

  static Future<Response> postData(String url,
      {Map<String, dynamic>? query,
      required Map<String, dynamic> data,
      String? token,
      String lang = 'en'}) async {
    dioHelper.dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization':
          token == null ? cacheHelper.getValue(key: 'token') : token,
    };
    return await dioHelper.dio.post(url, data: data, queryParameters: query);
  }

  static Future<Response> putData(String url,
      {Map<String, dynamic>? query,
      required Map<String, dynamic> data,
      String? token,
      String lang = 'en'}) async {
    dioHelper.dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization':
          token == null ? cacheHelper.getValue(key: 'token') : token,
    };
    return await dioHelper.dio.put(url, data: data);
  }
}
