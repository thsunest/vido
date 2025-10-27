import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:vido/service/dio_client.dart'; // for debugPrint
import 'dart:typed_data';
// 定义一个通用的 API 服务类
class ApiService {
  final Dio _dio; // 私有 Dio 实例

  final box = GetStorage(); // 创建 GetStorage 实例

  ApiService() : _dio = DioClient.instance.dio {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = box.read('token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token'; 
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<Response<dynamic>> post(
    String url, {
    dynamic data, // 请求体数据
    Map<String, dynamic>? headers, // 额外的请求头
    Options? options, // 允许传入自定义Dio Options
  }) async {
    try {
      // 合并默认头和传入的额外头
      final Options requestOptions = options ?? Options(); // 默认请求头
      requestOptions.headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        ...(headers ?? {}),
        ...(requestOptions.headers ?? {}),
      };

      final Response<dynamic> res = await _dio.post(
        url,
        data: data,
        options: requestOptions,
      );

      if (res.statusCode != 200) {
        throw DioException(
          requestOptions: res.requestOptions,
          response: res,
          type: DioExceptionType.badResponse,
          error: '请求失败，状态码: ${res.statusCode}',
        );
      }
      return res; // 返回成功的响应
    } on DioException catch (e) {
      debugPrint('ApiService 网络请求错误: ${e.requestOptions.path}');
      debugPrint('ApiService 错误详情: $e');
      rethrow;
    } catch (e) {
      debugPrint('ApiService 未知错误: $e');
      rethrow;
    }
  }

  Future<Response<dynamic>> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options, required Map<String, int> params,
  }) async {
    try {
      // 合并默认头和传入的额外头
      final Options requestOptions = options ?? Options();
      requestOptions.headers = {
        'Content-Type': 'application/x-www-form-urlencoded', // 默认设置为 x-www-form-urlencoded
        ...(headers ?? {}),
        ...(requestOptions.headers ?? {}),
      };  

      final Response<dynamic> res = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: requestOptions,
      );

      if (res.statusCode != 200) {
        throw DioException(
          requestOptions: res.requestOptions,
          response: res,
          type: DioExceptionType.badResponse,
          error: '请求失败，状态码: ${res.statusCode}',
        );
      }
      return res; // 返回成功的响应
    } on DioException catch (e) {
      debugPrint('ApiService 网络请求错误: ${e.requestOptions.path}');
      debugPrint('ApiService 错误详情: $e');
      rethrow;
    } catch (e) {
      debugPrint('ApiService 未知错误: $e');
      rethrow;
    }
  }

  Future<Response<dynamic>> postWithFile(
    String url, {
    required Map<String, dynamic> data, 
    required TDUploadFile? file, 
  }) async {
    try {
      final formData = FormData.fromMap(data);

      if (file != null && file.assetPath != null) {

        formData.files.add(MapEntry(
          'imgs[]',
          await MultipartFile.fromFile(file.assetPath!, filename: file.assetPath),
        ));
      }

      final token = box.read('token');
      
      final Response<dynamic> res = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
        ),
      );

      if (res.statusCode != 200) {
        throw DioException(
          requestOptions: res.requestOptions,
          response: res,
          type: DioExceptionType.badResponse,
          error: '请求失败，状态码: ${res.statusCode}',
        );
      }
      return res;
    } on DioException catch (e) {
      debugPrint('ApiService 文件上传错误: ${e.requestOptions.path}');
      debugPrint('ApiService 错误详情: $e');
      rethrow;
    } catch (e) {
      debugPrint('ApiService 未知错误: $e');
      rethrow;
    }
  }
Future<Response<dynamic>> uploadScreenshot({

    required String url,
    required Uint8List imageData,
    required String filename,
  }) async {
    try {
      final formData = FormData.fromMap({
        'uid': box.read('userId') ?? 0,
        "fileType": "image",
        'imgs[]': MultipartFile.fromBytes(
          imageData,
          filename: filename,
        ),
      });

      final token = box.read('token');
      final Response<dynamic> res = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            if (token != null && token.isNotEmpty)
              'Authorization': 'Bearer $token',
          },
        ),
      );
      
      if (res.statusCode != 200) {
        throw DioException(
            requestOptions: res.requestOptions, response: res);
      }
      return res;
    } on DioException catch (e) {
      debugPrint('ApiService 截图上传错误: $e');
      rethrow;
    }
  }
}
