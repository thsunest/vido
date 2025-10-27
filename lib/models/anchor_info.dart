import 'package:vido/models/live_view_info.dart';

class AnchorInfo {
  bool isMale = true;
  DateTime? birthDay;
  String email = '';
  String? image;
  String remark = '';
}

enum LiveAnchorApplyStatusType { none, review, reject }

class LiveStreamSettingInfo {
  /// [uid] 主播ID
  String? uid;

  /// [roomName] 直播标题
  String roomName = '';

  /// [isCharge] 1收费房间 0免费房间
  int isCharge = 0;

  /// [chargeType] 1按场收费 2计时收费
  int chargeType = 1;

  /// [roomGold] 收费金币值
  int roomGold = 0;

  /// [playerImg] 直播封面（当用户没有设置时，使用封面上传接口roomUploadImg，每60秒定时上传更新）
  String? playerImg;

  bool isSetSuccess = false;

  LiveStreamSettingInfo();

  bool get isSetted => (roomName.isNotEmpty && (uid?.isNotEmpty ?? false));

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['roomName'] = roomName;
    data['isCharge'] = isCharge;
    data['chargeType'] = chargeType;
    data['roomGold'] = roomGold;
    data['playerImg'] = playerImg;
    return data;
  }

  Map<String, dynamic> toParams() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['roomName'] = roomName;
    data['isCharge'] = isCharge;
    data['chargeType'] = chargeType;
    data['roomGold'] = roomGold;
    return data;
  }

  LiveStreamSettingInfo.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] ?? '';
    roomName = json['roomName'] ?? '';
    isCharge = json['isCharge'] ?? 0;
    chargeType = json['chargeType'] ?? 1;
    roomGold = json['roomGold'] ?? 0;
    playerImg = json['playerImg'];
  }

  LiveAnchorInfo toLiveInfo() {
    LiveAnchorInfo info = LiveAnchorInfo();
    info.isCharge = isCharge;
    info.chargeType = chargeType;
    info.gold = roomGold;
    return info;
  }
}
