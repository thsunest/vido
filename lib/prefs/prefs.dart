import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vido/models/user_info.dart';

/// 一个极简的 Prefs 类，仅为 WebSocketManager 提供用户状态。
class Prefs {
  // --- 单例模式保持不变 ---
  static Prefs? _instance;
  factory Prefs() => _instance ??= Prefs._internal();
  Prefs._internal() {
    _instance = this;
  }

  late SharedPreferences _prefs;

  // --- 核心用户数据 ---
  UserInfo? userInfo;
  String? userId;
  String? token;

  // --- 判断登录状态的便捷 getter ---
  bool get isLogin => (token != null && token!.isNotEmpty);

  /// 初始化方法，从本地存储加载用户数据。
  /// 在 App 启动时必须调用一次。
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    // 从 SharedPreferences 加载 userId 和 token
    userId = _prefs.getString(PrefsKey.userId.name);
    token = _prefs.getString(PrefsKey.token.name);
    debugPrint('Prefs initialized with token: $token');

    // 如果用户ID和token都存在，则从网络获取完整的用户信息
    // 这是获取 user 的核心逻辑，必须保留
    if (userId != null &&
        token != null &&
        userId!.isNotEmpty &&
        token!.isNotEmpty) {
      userInfo = await UserInfo.getUserInfo(userid: userId!);

      // GlobalStrategy().startHeartbeat();
      // MessageManager().updateMessage();
    }
  }

  /// 保存用户ID，并在需要时重新获取用户信息。
  Future<void> saveUserId(String? userId) async {
    this.userId = userId;
    await _prefs.setString(PrefsKey.userId.name, userId ?? "");
    debugPrint('Saved userId: $userId');
    if (userId != null && userId.isNotEmpty) {
      // 当ID更新时，重新获取用户信息
      userInfo = await UserInfo.getUserInfo(userid: userId);
    }
  }

  /// 保存Token，并管理全局心跳。
  Future<void> saveToken(String? token) async {
    this.token = token;
    // 根据 token 是否存在来启动或停止心跳
    if (token == null || token.isEmpty) {
      // GlobalStrategy().stopHeartbeat();
    } else {
      // GlobalStrategy().startHeartbeat();
    }
    await _prefs.setString(PrefsKey.token.name, token ?? "");
  }

  String? getValueFromKey(String key) => _prefs.getString(key);
}

/// SharedPreferences 的键名，只保留用到的。
enum PrefsKey { userId, token }
