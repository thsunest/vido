

class LiveViewInfo {
  int onlineNum = 0;
  LiveAnchorInfo anchorInfo = LiveAnchorInfo();
  bool isFocus = false;
  LiveUserInfo userInfo = LiveUserInfo();
  String sysNotice = "";
  String sysNoticeEn = "";

  LiveViewInfo();

  LiveViewInfo.fromJson(Map<String, dynamic> json) {
    onlineNum = json['onlineNum'] ?? 0;
    anchorInfo = LiveAnchorInfo.fromJson(json['anchorInfo']);
    isFocus = json['isFocus'] ?? false;
    userInfo = LiveUserInfo.fromJson(json['userInfo']);
    sysNotice = json['sysNotice'] ?? '';
    sysNoticeEn = json['sysNotice_en'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'onlineNum': onlineNum,
      'anchorInfo': anchorInfo.toJson(),
      'isFocus': isFocus,
      'userInfo': userInfo.toJson(),
      'sysNotice': sysNotice,
      'sysNotice_en': sysNoticeEn,
    };
  }
}

class LiveAnchorInfo {
  String id = '';
  String nikcname = '';
  String headimgurl = '';
  String anchorCover = '';
  int playerTime = 0;
  String playerUrl = '';
  String h5Server = '';
  String idLive = '';
  bool isBuy = false;
  bool isTry = false;
  int tryTime = 0;
  int userTry = 0;
  int isCharge = 0;
  int chargeType = 0;
  int maxWatch = 0;
  int gold = 0;
  String playServer = "";

  LiveAnchorInfo();

  LiveAnchorInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    nikcname = json['nikcname'] ?? '';
    headimgurl = json['headimgurl'] ?? '';
    anchorCover = json['anchorCover'] ?? '';
    playerTime = json['playerTime'] ?? 0;
    playerUrl = json['playerUrl'] ?? '';
    h5Server = json['h5_server'] ?? '';
    idLive = json['idLive'] ?? '';
    isBuy = json['isBuy'] ?? false;
    isTry = json['isTry'] ?? false;
    tryTime = json['tryTime'] ?? 0;
    userTry = json['userTry'] ?? 0;
    isCharge = json['isCharge'] ?? 0;
    chargeType = json['chargeType'] ?? 0;
    maxWatch = json['maxWatch'] ?? 0;
    gold = json['gold'] ?? 0;
    playServer = json['playServer'] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nikcname': nikcname,
      'headimgurl': headimgurl,
      'anchorCover': anchorCover,
      'playerTime': playerTime,
      'playerUrl': playerUrl,
      'h5_server': h5Server,
      'idLive': idLive,
      'isBuy': isBuy,
      'isTry': isTry,
      'tryTime': tryTime,
      'userTry': userTry,
      'isCharge': isCharge,
      'chargeType': chargeType,
      'maxWatch': maxWatch,
      'gold': gold,
    };
  }
}

class GiftInfo {
  int id = 0;
  int anchorId = 0;
  int type = 0;
  String name = '';
  String images = '';
  String svga = '';
  String animation = '';
  int price = 0;
  int sort = 0;
  int status = 0;
  String info = '';
  String nameEn = '';
  String key = "";
  int duration = 0;

  GiftInfo();

  GiftInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    anchorId = json['anchor_id'] ?? 0;
    type = json['type'] ?? 0;
    name = json['name'] ?? '';
    images = json['images'] ?? '';
    svga = json['svga'] ?? '';
    animation = json['animation'] ?? '';
    price = json['price'] ?? 0;
    sort = json['sort'] ?? 0;
    status = json['status'] ?? 0;
    info = json['info'] ?? '';
    nameEn = json['name_en'] ?? '';
    key = json['key'] ?? '';
    duration = json['duration'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'anchor_id': anchorId,
      'type': type,
      'name': name,
      'images': images,
      'svga': svga,
      'animation': animation,
      'price': price,
      'sort': sort,
      'status': status,
      'info': info,
      'name_en': nameEn,
      'key': key,
      'duration': duration,
    };
  }






}

class Gift3OptionInfo {
  String key = "";
  String value = "";
  String valueEn = "";

  Gift3OptionInfo.fromJson(Map<String, dynamic> json) {
    key = json['key'] ?? "";
    value = json['value'] ?? "";
    valueEn = json['value_en'] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {'key': key, 'value': value, 'value_en': valueEn};
  }

}

class GiftOrder {
  List<GiftInfo> giftList = [];

  GiftOrder();

  GiftOrder.fromJson(Map<String, dynamic> json) {
    giftList =
        (json['giftList'] as List<dynamic>?)?.map((e) => GiftInfo.fromJson(e)).toList() ?? [];
  }

  Map<String, dynamic> toJson() {
    return {'giftList': giftList.map((e) => e.toJson()).toList()};
  }
}

class LiveUserInfo {
  int id = 0;
  bool isVip = false;
  String username = '';
  int gold = 0;
  String headImg = '';
  bool isDisable = false;

  LiveUserInfo();

  LiveUserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    isVip = json['isVip'] ?? false;
    username = json['username'] ?? '';
    gold = json['gold'] ?? 0;
    headImg = json['headImg'] ?? '';
    isDisable = json['isDisable'] ?? false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isVip': isVip,
      'username': username,
      'gold': gold,
      'headImg': headImg,
      'isDisable': isDisable,
    };
  }
}

class Viewer {
  int id = 0;
  int userId = 0;
  String headImg = '';
  bool isDisable = false;
  String username = '';
  bool isVip = false;
  bool isKicked = false;

  Viewer();

  Viewer.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    userId = json['user_id'] ?? 0;
    headImg = json['headImg'] ?? '';
    isDisable = json['isDisable'] ?? false;
    username = json['username'] ?? '';
    isVip = json['isVip'] ?? false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'headImg': headImg,
      'isDisable': isDisable,
      'username': username,
      'isVip': isVip,
      'isKicked': isKicked,
    };
  }
}
