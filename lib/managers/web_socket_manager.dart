import 'dart:async';
import 'dart:convert';
import 'package:better_web_socket/better_web_socket.dart';
import 'package:better_web_socket/better_web_socket_api.dart';
import 'package:flutter/material.dart';
import 'package:vido/models/anchor_info.dart';
import 'package:vido/models/gift.dart';
import 'package:vido/models/live_view_info.dart';
import 'package:vido/models/user_info.dart';
import 'package:vido/prefs/prefs.dart';

class WebSocketManager {
  late BetterWebSocketController _controller;
  late StreamSubscription _receiveDataSubscription;

  VoidCallback? onEndLive;
  Function(UserMessageModel)? onRecvMessage;
  Function(GiftMessageModel)? onRecvGift;
  Function(UserInfo)? onUserLogout;
  Function(UserInfo)? onUserLogin;
  Function(LiveStreamSettingInfo)? onUpdateRoomInfo;
  Function(UserInfo)? onUserFocus;
  VoidCallback? onKickOutAnchor;
  Function(UserInfo)? onReLogin;
  VoidCallback? onUpdateGift;
  VoidCallback? onKickMine;

  int _timeToHearbeat = 0;
  String anchor = "";

  WebSocketManager({required String url, required this.anchor}) {
    debugPrint('url: $url');
    _controller = BetterWebSocketController(url);
    _controller.addListener(_onChangedState);
    _receiveDataSubscription = _controller.receiveDataStream.listen((data) {
      debugPrint('socket data: $data');
      _handleRecvData(data);
    });
  }

  void dispose() {
    _receiveDataSubscription.cancel();
    _controller.stopWebSocketConnectAfter();
  }

  void connect() {
    _controller.startWebSocketConnect(
      retryCount: double.maxFinite.toInt(),
      retryDuration: Duration(seconds: 1),
    );
  }

  void disconnect() {
    _controller.stopWebSocketConnectAfter(duration: Duration.zero);
  }

  void sendData(dynamic data) {
    _controller.sendData(data);
  }

  void sendMessage(String text) {
    final data = {
      "type": "msg",
      "anchor": anchor,
      "data": {"text": text, "user": Prefs().userInfo?.toJson()},
    };
    sendData(jsonEncode(data));
  }

  void sendGift(Gift gift) {
    final data = {
      "type": "giveGift",
      "anchor": anchor,
      "data": {"gift": gift.toJson(), "user": Prefs().userInfo?.toJson()},
    };
    sendData(jsonEncode(data));
  }

  void sendUpdateGift() {
    final data = {"type": "updateGift", "anchor": anchor};
    sendData(jsonEncode(data));
  }

  void sendUserLogout() {
    final data = {
      "type": "userLogout",
      "anchor": anchor,
      "data": {"user": Prefs().userInfo?.toJson()},
    };
    sendData(jsonEncode(data));
  }

  void sendUpdateRoomInfo(LiveStreamSettingInfo info) {
    final data = {"type": "updateRoomInfo", "anchor": anchor, "data": info.toParams()};
    sendData(jsonEncode(data));
  }

  void sendUserFocus() {
    final data = {"type": "userFocus", "anchor": anchor, "data": Prefs().userInfo?.toJson()};
    sendData(jsonEncode(data));
  }

  void sendEndLive() {
    final data = {"type": "endLive", "anchor": anchor};
    sendData(jsonEncode(data));
  }

  void sendUserLogin() {
    final data = {"type": "login", "anchor": anchor, "data": Prefs().userInfo?.toJson()};
    sendData(jsonEncode(data));
  }

  void sendUserMute({required Viewer user}) {
    final data = {
      "type": "mute",
      "anchor": anchor,
      "data": {"user": user.toJson()},
    };
    sendData(jsonEncode(data));
  }

  void sendUserKick({required Viewer user}) {
    final data = {
      "type": "kick",
      "anchor": anchor,
      "data": {"user": user.toJson()},
    };
    sendData(jsonEncode(data));
  }

  void _onChangedState() {
    String result;
    switch (_controller.value.socketState) {
      case BetterWebSocketConnectState.SUCCESS:
        result = "🟢";
        break;
      case BetterWebSocketConnectState.FAIL:
        result = "🔴";
        break;
      case BetterWebSocketConnectState.CONNECTING:
        result = "🟡";
        break;
    }
    debugPrint('socketState: $result');
  }

  void heartbeat() {
    _timeToHearbeat += 1;
    if (_timeToHearbeat < 9) return;
    _timeToHearbeat = 0;
    sendData(jsonEncode({"type": "pong"}));
  }

  void _handleRecvData(dynamic data) async {
    final json = jsonDecode(data);
    if (!(json != null && json is Map)) return;
    final anchor = json["anchor"];
    if (this.anchor != anchor) return;
    final type = json["type"];
    if (type == "endLive") {
      /// 直播结束（endLive）：如果消息来自当前主播，提示用户直播已结束，并提供返回选项。
      onEndLive?.call();
    } else if (type == "msg") {
      /// 普通消息（msg）：判断消息是否来自当前用户或主播，并根据消息类型（通知或普通消息）进行处理。
      onRecvMessage?.call(UserMessageModel.fromMessage(json["data"]));
    } else if (type == "giveGift") {
      /// 礼物消息（giveGift）：如果消息来自当前用户或主播，触发礼物特效。
      onRecvGift?.call(GiftMessageModel.fromMessage(json["data"]));
    } else if (type == 'login') {
      onUserLogin?.call(UserInfo.fromJson(json["data"]));
    } else if (type == "userLogout") {
      /// 用户退出（userLogout）：如果消息来自当前用户或主播，触发用户退出操作。
      onUserLogout?.call(UserInfo.fromJson(json["data"]));
    } else if (type == "updateRoomInfo") {
      /// 更新房间信息（updateRoomInfo）：如果消息来自当前用户或主播，更新房间信息并触发相应的计时器。
      onUpdateRoomInfo?.call(LiveStreamSettingInfo.fromJson(json["data"]));
    } else if (type == "userFocus") {
      /// 用户关注（userFocus）：如果消息来自当前主播，提示主播有新用户关注。
      onUserFocus?.call(UserInfo.fromJson(json["data"]));
    } else if (type == "kickOutAnchor") {
      /// 踢出主播（kickOutAnchor）：如果消息来自当前主播，提示主播后台结束了直播。
      onKickOutAnchor?.call();
    } else if (type == "login") {
      /// 登录（login）：如果消息来自当前用户或主播，提示用户重新登录。
      onReLogin?.call(UserInfo.fromJson(json["data"]));
    } else if (type == "updateGift") {
      /// 更新礼物（updateGift）：如果消息来自当前用户或主播，更新礼物列表。
      onUpdateGift?.call();
    } else if (type == "mute") {
      /// 禁言（mute）：如果消息来自当前用户或主播，触发禁言操作。
      final message = UserMessageModel();
      message.user = UserInfo();
      message.user?.nickname = json["data"]["user"]["username"];
      message.user?.userId = json["data"]["user"]["user_id"].toString();
      final isMute = json["data"]["user"]["isDisable"];
      message.isMute = isMute ? 1 : 2;
      onRecvMessage?.call(message);
    } else if (type == "kick") {
      /// 踢人（kick）：如果消息来自当前用户或主播，触发踢人操作。
      final message = UserMessageModel();
      message.user = UserInfo();
      message.user?.nickname = json["data"]["user"]["username"];
      final isKick = json["data"]["user"]["isKicked"];
      message.isKick = isKick ? 1 : 2;
      onRecvMessage?.call(message);
      final userId = json["data"]["user"]["user_id"];
      debugPrint('userId: $userId, current: ${Prefs().userId}, onKickMine: $onKickMine');
      if (userId.toString() == Prefs().userId) {
        debugPrint('onKickMine: $onKickMine');
        onKickMine?.call();
      }
    }
  }
}

class UserMessageModel {
  String text = "";
  int isMute = -1;
  int isKick = -1;
  int giftType = 0;
  UserInfo? user;

  UserMessageModel();

  UserMessageModel.fromMessage(Map<String, dynamic> message) {
    text = message["text"] ?? "";
    user = UserInfo.fromJson(message["user"]);
  }

  String get typeName {
    if (giftType == 1) {
      return "赠送";
    } else if (giftType == 2) {
      return "打赏";
    } else if (giftType == 3) {
      return "购买";
    }
    return "";
  }

  String get typeColor {
    if (giftType == 1) {
      return "#9F1E12";
    } else if (giftType == 2) {
      return "#A58031";
    } else if (giftType == 3) {
      return "#457F5A";
    }
    return "#FFFFFF";
  }
}

class GiftMessageModel {
  Gift? gift;
  UserInfo? user;

  GiftMessageModel.fromMessage(Map<String, dynamic> message) {
    gift = Gift.fromJson(message["gift"]);
    user = UserInfo.fromJson(message["user"]);
  }

   String getTypeName(int giftType) {
    switch (giftType) {
      case 1:
        return "赠送";
      case 2:
        return "打赏";
      case 3:
        return "购买";
      default:
        return "";
    }
  }
  Map<String,dynamic>getMessageCover(int giftType){
    switch (giftType) {
      case 1:
        return {
          "text": "赠送",
          "color": "0xFFFAB100"
        };
      case 2:
        return {
          "text": "打赏",
          "color": "0xFFE7525A"
        };
      case 3:
        return {
          "text": "购买",
          "color": "0xFF9F94FF"
        };
      default:
        return {};
    }

  }
}
