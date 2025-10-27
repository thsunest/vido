// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../service/api_service.dart';

// class GlobalStrategy {
//   static GlobalStrategy? _instance;
//   factory GlobalStrategy() => _instance ?? GlobalStrategy._internal();
//   GlobalStrategy._internal();

//   Timer? _heartbeatTimer;
//   static final ApiService apiService = Get.find<ApiService>();

//   void startHeartbeat() {
//     _heartbeatTimer?.cancel();
//     _heartbeatTimer = Timer.periodic(const Duration(seconds: 60), (timer) async {
//       final res = await NetService().post(
//         path: GlobalApis.heartBeat,
//         params: {"userId": Prefs().userId, "sys": Prefs().sys},
//       );
//       debugPrint('res: $res');
//     });
//   }

//   void stopHeartbeat() {
//     _heartbeatTimer?.cancel();
//   }
// }
