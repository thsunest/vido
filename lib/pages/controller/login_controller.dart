import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:vido/constants/url.dart';
import 'package:vido/pages/live_page.dart';
import 'package:vido/service/api_service.dart';

class LoginController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final box = GetStorage();

  static const List<Locale> supportedLocales = [
    Locale('zh', 'CN'), // 中文
    Locale('en', 'US'), // 英文
  ];

  final Rx<Locale> _currentLocale = const Locale('zh', 'CN').obs;
  Locale get currentLocale => _currentLocale.value;
  @override
  void onInit() async {
    super.onInit();
  }

  Future<void> login(BuildContext context) async {
    String username = usernameController.text;
    String password = passwordController.text;
    if (username.isEmpty || password.isEmpty) {
      TDToast.showText('用户名或密码不能为空', context: context);
      return;
    }
    try {
      final res = await _apiService.post(
        ApiUrls.loginUrl,
        data: {'account': username, 'pwd': password},
      );

      String? receivedToken;
      int? userId;
      String? wsUrl;
      if (res.data is Map<String, dynamic>) {
        receivedToken = res.data['Data']?['token'];
        userId = res.data['Data']?['member_id'];
        wsUrl = res.data['Data']?['wserver'];
      }

      if (receivedToken != null && receivedToken.isNotEmpty) {
        box.write('token', receivedToken);
        box.write('userId', userId);

        debugPrint('登录成功: $receivedToken');
        TDToast.showText('登录成功', context: context);

        Get.offAll(
          () => LivePage(),
          arguments: {'token': receivedToken, 'userId': userId, 'wsUrl': wsUrl},
        );
      } else {
        TDToast.showText('登录失败,请检查您的用户名和密码', context: context);
      }
    } catch (e) {
      debugPrint('登录失败: $e');
    }
  }
   void updateLanguage(Locale locale) {
    if (_currentLocale.value == locale) return; // 如果语言没有改变，则不做任何操作
    _currentLocale.value = locale;
    Get.updateLocale(locale); // 核心：使用 GetX 更新应用语言
  }
}
