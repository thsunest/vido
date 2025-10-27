import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:vido/service/api_service.dart';

import '../constants/url.dart';

class User {
  final int id;
  int userId;
  bool isDisable;
  var isMuted = false.obs;
  final String userName;
  final String nickName;
  final String avatarUrl; // headImg;
  final bool isVip;

  User(
    this.id,
    this.userId,
    this.isVip,
    this.isDisable,
    this.nickName, {
      bool isMuted = false,
    required this.userName,
    required this.avatarUrl,
  }){
    this.isMuted.value = isMuted;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'] as int,
      json['user_id'] as int,
      json['isDisable'] as bool,
      json['isVip'] as bool,
      json['nickname'] as String? ?? '',
      userName: json['username'] as String,
      avatarUrl: json['headImg'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'isDisable': isDisable,
      'username': userName,
      'nickname': nickName,
      'headImg': avatarUrl,
      'isVip': isVip,
    };
  }

  static final ApiService apiService = Get.find<ApiService>();

  static Future<User> getUserInfo(int userId) async {
    final res = await apiService.post(
      ApiUrls.getUserInfoUrl,
      data: {'userId': userId},
    );
    if (res.statusCode == 200) {
      final data = res.data;
      if (data != null && data is Map<String, dynamic>) {
        final user = User.fromJson(data);
        user.userId = userId;
        return user;
      } else {
        throw Exception('Invalid user data format');
      }
    } else {
      throw Exception('Failed to load user info: ${res.statusMessage}');
    }
  }
}
