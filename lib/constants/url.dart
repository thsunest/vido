class ApiUrls {
  static String baseUrl = 'http://app.nndo.live';
  static String appApi = 'appapi';
  static String appkey = 'appkey';
  static String abc123456 = 'abc123456'; 

  static String loginUrl = '$baseUrl/$appApi/modLogin/$appkey/$abc123456';

  static String adInfoUrl = '$baseUrl/$appApi/getAdInfo/$appkey/$abc123456';

  static String startLiveUrl = '$baseUrl/$appApi/startLiveBroadcast/$appkey/$abc123456';

  static String endLiveUrl = '$baseUrl/$appApi/endLiveBroadcast/$appkey/$abc123456';

  static String liveSettingsUrl = '$baseUrl/$appApi/saveRoomData/$appkey/$abc123456';

  static String liveInfoUrl = '$baseUrl/$appApi/onlineMember/$appkey/$abc123456';

  static String anchorOutUserUrl = '$baseUrl/$appApi/anchorOutUser/$appkey/$abc123456';

  static String updateSendMsUrl = '$baseUrl/$appApi/updateSendMs/$appkey/$abc123456';

  static String getGiftUrl = '$baseUrl/$appApi/getAnchorGiftConfig/$appkey/$abc123456';

  static String getGiftListUrl = '$baseUrl/$appApi/getAnchorGiftTable/$appkey/$abc123456';

  static String addGiftUrl = '$baseUrl/$appApi/addAnchorGiftTable/$appkey/$abc123456';

  static String updateGiftUrl = '$baseUrl/$appApi/updateAnchorGiftTable/$appkey/$abc123456';

  static String deleteGiftUrl = '$baseUrl/$appApi/delAnchorGiftTable/$appkey/$abc123456';

  static String getGift2Url = '$baseUrl/$appApi/getAnchorGift/$appkey/$abc123456'; 

  static String addGift2Url = '$baseUrl/$appApi/addAnchorGift/$appkey/$abc123456';  

  static String updateGift2Url = '$baseUrl/$appApi/updateAnchorGift/$appkey/$abc123456';

  static String deleteGift2Url = '$baseUrl/$appApi/delAnchorGift/$appkey/$abc123456';

  static String getUserInfoUrl = '$baseUrl/$appApi/getUserInfo/$appkey/$abc123456';

  static String heartBeat = '$baseUrl/$appApi/heartBeat/$appkey/$abc123456';

  static String getQrCodeUrl = '$baseUrl/$appApi/getQrcode/$appkey/$abc123456';

  static String uploadFileUrl = '$baseUrl/$appApi/roomUploadImg/$appkey/$abc123456';

}
