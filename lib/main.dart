import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vido/constants/localazation.dart';
import 'package:vido/pages/live_page.dart';
import 'package:vido/pages/login_page.dart';
import 'package:vido/prefs/prefs.dart';
import 'package:vido/service/api_service.dart';
import 'package:vido/service/dio_client.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';

void main(List<String> args) async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('debug启动参数: $args');
  Get.put<DioClient>(DioClient.instance);
  Get.put<ApiService>(ApiService());
  Prefs().init();
  // Get.isDarkMode = true;

  await windowManager.ensureInitialized();

  await Window.initialize();
  await Window.setEffect(effect: WindowEffect.titlebar, color: Color(0x212227));
  // 通过 WidgetsBinding 获取初始窗口的物理尺寸和设备像素比
  final Size physicalScreenSize = WidgetsBinding.instance.window.physicalSize;
  final double devicePixelRatio = WidgetsBinding.instance.window.devicePixelRatio;

  // // 将物理像素转换为逻辑像素（dp），这通常更接近我们理解的“屏幕尺寸”
     final  Size fullScreenSize = Size(
    physicalScreenSize.width / devicePixelRatio ,
    physicalScreenSize.height / devicePixelRatio,
  );
  
  WindowOptions windowOptions = const  WindowOptions(

    size: Size(1920, 1024),
    // size: Size(960, 512),

    // size: Size(1536, 820),
  

    center: true,
    minimumSize: Size(400, 300),
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Localization(),
      locale: const Locale('zh', 'CN'), // 初始语言为中文
      fallbackLocale: const Locale('en', 'US'), // 备用语言为英文
      theme: ThemeData(fontFamily: 'pingfang'),
      title: 'vidoDemo',

      home: const LoginPage(),
      // home: const LivePage(),
    );
  }
}
