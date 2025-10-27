

import 'package:get/get.dart';
import 'package:vido/constants/url.dart';
import 'package:vido/service/api_service.dart';

class UserInfo {
  String avatar = "";
  String username = "";
  String nickname = "";
  int sex = 0;
  String tel = "";
  String email = "";
  bool isVip = false;
  int vipEndDate = 0;
  String vipEndTime = "";
  String money = "0";
  int coin = 0;
  int watch = 0;
  int watchCount = 0;
  UserDown down = UserDown();
  String shareRewardText = "";
  String recText = "";
  int isPermanent = 0;
  bool sign = false;
  String signTip = "";
  int signPint = 0;
  String userId = "";
  bool isAnchor = false;

  UserInfo();

  UserInfo.fromJson(Map<String, dynamic> json) {
    avatar = json['avatar'] ?? "";
    username = json['username'] ?? "";
    nickname = json['nickname'] ?? "";
    sex = json['sex'] ?? 0;
    tel = json['tel'] ?? "";
    email = json['email'] ?? "";
    isVip = json['isVip'] ?? false;
    vipEndDate = json['vipEndDate'] ?? 0;
    vipEndTime = json['vipEndTime'] ?? "";
    money = "${json['money'] ?? 0}";
    coin = json['corn'] ?? 0;
    watch = json['watch'] ?? 0;
    watchCount = json['watch_count'] ?? 0;
    down = UserDown.fromJson(json['down'] ?? {});
    shareRewardText = json['share_reward_text'] ?? "";
    recText = json['rec_text'] ?? "";
    isPermanent = json['is_permanent'] ?? 0;
    sign = json['sign'] ?? false;
    signTip = json['signTip'] ?? "";
    signPint = json['signPint'] ?? 0;
    userId = json['userid'] ?? "";
    isAnchor = json['isAnchor'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['avatar'] = avatar;
    data['username'] = username;
    data['nickname'] = nickname;
    data['sex'] = sex;
    data['tel'] = tel;
    data['email'] = email;
    data['isVip'] = isVip;
    data['vipEndDate'] = vipEndDate;
    data['vipEndTime'] = vipEndTime;
    data['money'] = money;
    data['corn'] = coin;
    data['watch'] = watch;
    data['watch_count'] = watchCount;
    data['down'] = down.toJson();
    data['share_reward_text'] = shareRewardText;
    data['rec_text'] = recText;
    data['is_permanent'] = isPermanent;
    data['sign'] = sign;
    data['signTip'] = signTip;
    data['signPint'] = signPint;
    data['userid'] = userId;
    data['isAnchor'] = isAnchor;
    return data;
  }
  static final ApiService apiService = Get.find<ApiService>();


  static Future<UserInfo?> getUserInfo({required String userid}) async {
    final res = await apiService.post(
      ApiUrls.getUserInfoUrl,
      data: {"userId": userid},   
    );
    if (res.statusCode == 200) {
      final user = UserInfo.fromJson(res.data);
      user.userId = userid;
      return user;
    }
    return null;
  }
}


class UserDown {
  int sum = 0;
  int tot = 0;

  UserDown();

  UserDown.fromJson(Map<String, dynamic> json) {
    sum = json['sum'] ?? 0;
    tot = json['tot'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sum'] = sum;
    data['tot'] = tot;
    return data;
  }
}
