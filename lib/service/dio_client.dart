import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:vido/constants/url.dart';

class DioClient {
  late Dio _dio; 

  DioClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiUrls.baseUrl, 
      connectTimeout: const Duration(seconds: 10), // 连接超时
      receiveTimeout: const Duration(seconds: 10), // 接收超时
      sendTimeout: const Duration(seconds: 10), // 发送超时
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded', // 默认设置为 x-www-form-urlencoded
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
      error: true,
      logPrint: (obj) => debugPrint(obj.toString()),
    ));
  }

  // 单例模式
  static final DioClient _instance = DioClient._internal();
  static DioClient get instance => _instance;

  Dio get dio => _dio;
}