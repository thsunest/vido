import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:vido/constants/url.dart';
import 'package:vido/managers/web_socket_manager.dart';
import 'package:vido/models/user.dart';
import 'package:vido/models/user_message.dart';
import 'package:vido/models/webRTCPlayer.dart';
import 'package:vido/pops/start_live/start_live_controller.dart';
import 'package:vido/prefs/prefs.dart';
import 'package:vido/service/api_service.dart';
import 'package:flutter_svga/flutter_svga.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:audioplayers/audioplayers.dart';

class LiveController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var initStatus = false.obs; // 初始化状态
  var onTone = true.obs;

  final ApiService _apiService = Get.find<ApiService>();
  final Prefs _prefs = Prefs();

  final ScrollController messageScrollController = ScrollController();

  var erCode = ''.obs; // 设备编码
  var volume = 50.0.obs;
  var micro = 50.0.obs;

  var mirror = true.obs;

  var adList = <dynamic>[].obs; // 广告列表

  var userList = <User>[].obs; // 用户列表

  var messageList = <UserMessage>[].obs; // 消息列表

  var anchorId = ''.obs; // 用户ID

  var isLive = false.obs; // 直播状态

  var startUrl = ''.obs; // 直播地址

  var nickName = ''.obs; // 昵称

  var headImg = ''.obs; // 头像地址

  // 直播间相关变量
  RxInt isCharge = 0.obs;

  var openCharge = false.obs;

  RxInt chargeType = 0.obs;

  RxInt roomGold = 0.obs;

  TextEditingController roomGoldController = TextEditingController();

  TextEditingController roomNameController = TextEditingController();

  late SVGAAnimationController svgaAnimationController;

  final GlobalKey videoWidgetKey = GlobalKey();

  Timer? _autoCoverScreenshotTimer;
  final Rx<String?> currentSvgaUrl = Rx<String?>(null);

  final AudioPlayer audioPlayer = AudioPlayer();

  RxString playerImg = ''.obs;

  var selectedChargeMethod = 0.obs;

  //分页加载用户列表
  var currentPage = 1.obs;
  var isLoading = false.obs;
  var hasMoreData = true.obs;
  var totalUserCount = 0.obs;
  static const int _limit = 20;

  // WebSocket 相关变量
  WebSocketManager? webSocketManager;
  final List<UserMessage> messages = <UserMessage>[].obs;
  final List<String> logs = <String>[].obs;
  String? wsUrl;
  TextEditingController messageController = TextEditingController();

  void selectChargeMethod(int method) {
    selectedChargeMethod.value = method;
    debugPrint('Selected charge method: $method');
  }

  // WebRTC 相关变量
  final webrtc.RTCVideoRenderer localRenderer = webrtc.RTCVideoRenderer();
  webrtc.MediaStream? localStream;
  webrtc.RTCPeerConnection? peerConnection;
  var isStreaming = false.obs;
  var isLocalVideoInitialized = false.obs;
  var peerConnectionState =
      webrtc.RTCPeerConnectionState.RTCPeerConnectionStateNew.obs;

  // === 新增：媒体设备相关变量 ===
  final availableVideoDevices = <webrtc.MediaDeviceInfo>[].obs;
  final availableAudioDevices = <webrtc.MediaDeviceInfo>[].obs;
  final Rx<webrtc.MediaDeviceInfo?> selectedVideoDevice = Rx(null);
  final Rx<webrtc.MediaDeviceInfo?> selectedAudioDevice = Rx(null);

  void toggleMuteUser(User user) {
    user.isDisable = !user.isDisable;
    debugPrint('用户 ${user.id} 静音状态: ${user.isDisable}');
  }

  //开启提示音
  void toggleSound() {
    onTone.value = !onTone.value;
    debugPrint('提示音状态: ${onTone.value}');
  }

  void toggleCharge() {
    openCharge.value = !openCharge.value;
    isCharge.value = isCharge.value == 0 ? 1 : 0;
    if (openCharge.value) {
      webSocketManager?.sendMessage('本场直播开启收费');
    } else {
      webSocketManager?.sendMessage('本场直播关闭收费');
    }
    debugPrint('收费状态: ${isCharge.value}');
  }

  //MARK onInit
  @override
  void onInit() {
    // startLiveBroadcast();
    getLiveInfo();
    svgaAnimationController = SVGAAnimationController(vsync: this);
    svgaAnimationController.addStatusListener((status) {
      // 当动画状态变为“完成”时
      if (status == AnimationStatus.completed) {
        debugPrint("SVGA 动画播放完成");
        // 将 URL 设置为 null，从而向 UI 发出隐藏播放器的信号
        currentSvgaUrl.value = null;
      }
    });
    // testPlayGiftAnimation();

    super.onInit();
    loadMediaDevices();
    if (Get.arguments != null) {
      final Map<String, dynamic> args = Get.arguments;
      if (args.containsKey('token')) {
        _prefs.saveToken(args['token'].toString());
      }
      if (args.containsKey('userId')) {
        _prefs.saveUserId(args['userId'].toString());
        anchorId.value = args['userId'].toString(); //登录页传入的主播id
        debugPrint('Received userId: ${args['userId']}');
      }
      if (args.containsKey('wsUrl')) {
        wsUrl = args['wsUrl'].toString();
        debugPrint('Received wsUrl: ${args['wsUrl']}');
      }
    }
    _connect();
    getQRCode();

    // getAdInfo();
  }

  Future<void> getAdInfo() async {
    try {
      final res = await _apiService.post(
        ApiUrls.adInfoUrl,
        data: {'position_id': 4, 'limit': 6},
      );
      debugPrint('获取广告信息: ${res.data.toString()}');
      if (res.statusCode != 200) return;

      if (res.data['Data'] is List) {
        adList.assignAll(List<Map<String, dynamic>>.from(res.data['Data']));
        debugPrint('广告信息获取成功: ${adList.toString()} ');
      } else {
        debugPrint('广告信息获取失败: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('获取广告信息失败: $e');
    }
  }

  //MARK initlive
  Future<void> startLiveBroadcast(BuildContext context) async {
    try {
      final uid = int.parse(anchorId.value);
      final res = await _apiService.post(
        ApiUrls.startLiveUrl,
        data: {'uid': uid},
      );
      debugPrint('初始化请求参数: uid: $uid');
      if (res.statusCode == 200) {
        startUrl.value = res.data['Data']['startUrl'] ?? '';
        nickName.value = res.data['Data']['nikcname'] ?? '';
        headImg.value = res.data['Data']['headimgurl'] ?? '';
        debugPrint('直播初始化成功');
        debugPrint('初始化应答参数: ${res.data.toString()}');
        initStatus.value = true; // 设置初始化状态为true
      } else {
        debugPrint('直播开始失败: ${res.statusCode}');
        initStatus.value = false; // 设置初始化状态为false
      }
    } catch (e) {
      debugPrint('开始直播失败: $e');
    } finally {
      if (!initStatus.value) {
        // 如果初始化失败，清理相关资源
        localRenderer.dispose();
        localStream?.dispose();
        peerConnection?.close();
        peerConnection?.dispose();
        peerConnection = null;
        localStream = null;
      }
    }
  }

  //MARK 结束直播
  Future<void> endLiveBroadcast() async {
    try {
      final res = await _apiService.post(
        ApiUrls.endLiveUrl,
        data: {'userId': anchorId.value},
      );
      debugPrint('结束直播请求参数: ${anchorId.value}');
      if (res.statusCode == 200) {
        debugPrint('结束直播: ${peerConnectionState.value.toString()}');
        debugPrint('直播结束成功');
        isLive.value = false;
        webSocketManager!.sendMessage('直播已结束');
        _disconnect();
        Get.back(result: {'wss': res.data['Data']['server']});
      } else {
        debugPrint('直播结束失败: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('结束直播失败: $e');
    }
  }

  //MARK 直播间设置
  Future<void> liveBoradcastSettings(BuildContext context) async {
    try {
      final startLiveController = Get.find<StartLiveController>();
      final int uid = int.parse(anchorId.value);
      final Map<String, dynamic> data = {
        'uid': uid,
        'isCharge': openCharge.value ? 1 : 0,
        'chargeType': chargeType.value,
        'roomGold': int.parse(
          roomGoldController.text.isEmpty ? '0' : roomGoldController.text,
        ), // 默认值为0
        'roomName': roomNameController.text,
        'playerImg': playerImg.value,
      };
      final TDUploadFile? coverImageFile =
          startLiveController.uploadedFiles.isNotEmpty
              ? startLiveController.uploadedFiles.first
              : null;
      final bool shouldStartAutoScreenshot = (coverImageFile == null);
      final res = await _apiService.post(
        ApiUrls.liveSettingsUrl,
        data: {
          'uid': uid,
          'isCharge': openCharge.value ? 1 : 0,
          'chargeType': chargeType.value,
          'roomGold': int.parse(
            roomGoldController.text.isEmpty ? '0' : roomGoldController.text,
          ), // 默认值为0
          'roomName': roomNameController.text,
          'playerImg': headImg.value,
        },
      );
      final fileRes = await _apiService.postWithFile(
        ApiUrls.uploadFileUrl,
        data: {"fileType": "image", "uid": uid},
        file: coverImageFile,
      );

      if (res.statusCode == 200) {
        debugPrint('直播间设置应答参数: ${res.data.toString()}');
        Get.back(result: {'wss': res.data['Data']['server']});
        TDToast.showText('开启直播', context: context);
        await startPushStream();
        if (shouldStartAutoScreenshot) {
          _startAutoCoverScreenshotTimer();
        }
        // await connect();
      } else {
        debugPrint('直播间设置失败: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('直播间设置失败: $e');
    }
  }

  Future<void> startPushStream() async {
    if (peerConnection != null) {
      await stopPushStream();
    }

    if (startUrl.value.isEmpty) {
      debugPrint('错误: startUrl 为空，无法开始推流');
      return;
    }

    try {
      isStreaming.value = true;
      await localRenderer.initialize();

      // final Map<String, dynamic> mediaConstraints = {
      //   'audio': true,
      //   'video': {
      //     'mandatory': {
      //       'minWidth': '1280',
      //       'minHeight': '720',
      //       'minFrameRate': '30',
      //     },
      //     'facingMode': 'user',
      //   },
      // };
      final Map<String, dynamic> videoConstraints = {
        'mandatory': {
          'minWidth': '1280',
          'minHeight': '720',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
      };
      // 如果有选中的视频设备，则使用其 deviceId
      if (selectedVideoDevice.value != null) {
        videoConstraints['optional'] = [
          {'sourceId': selectedVideoDevice.value!.deviceId},
        ];
      }

      final Map<String, dynamic> audioConstraints = {};
      // 如果有选中的音频设备，则使用其 deviceId
      if (selectedAudioDevice.value != null) {
        audioConstraints['optional'] = [
          {'sourceId': selectedAudioDevice.value!.deviceId},
        ];
      }

      final Map<String, dynamic> mediaConstraints = {
        'audio': audioConstraints.isEmpty ? true : audioConstraints,
        'video': videoConstraints,
      };

      localStream = await webrtc.navigator.mediaDevices.getUserMedia(
        mediaConstraints,
      );
      localRenderer.srcObject = localStream;
      isLocalVideoInitialized.value = true;

      isStreaming.value = true;

      final Map<String, dynamic> configuration = {
        'iceServers': [
          {
            'urls': [
              'stun:stun.l.google.com:19302',
              'stun:stun.cloudflare.com:3478',
            ],
          },
        ],
        'sdpSemantics': 'unified-plan',
      };

      peerConnection = await webrtc.createPeerConnection(configuration);

      if (peerConnection != null) {
        await _startStatsLogging(peerConnection!);
      }
      peerConnection?.onConnectionState = (state) {
        debugPrint('Peer Connection 状态改变: $state');
        peerConnectionState.value = state;
      };

      localStream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localStream!);
      });

      webrtc.RTCSessionDescription offer = await peerConnection!.createOffer();
      await peerConnection!.setLocalDescription(offer);

      await _sendOfferToServer(offer);
    } catch (e) {
      debugPrint('推流失败: $e');
      isStreaming.value = false;
    }
  }

  // 信令交互逻辑
  Future<void> _sendOfferToServer(webrtc.RTCSessionDescription offer) async {
    debugPrint('开始信令交换，发送 Offer...');
    HttpClient client = HttpClient();
    try {
      WebRTCUri uri = WebRTCUri.parse(startUrl.value, isStream: true);

      final params = json.encode({
        'api': uri.api,
        'streamurl': uri.streamUrl,
        'sdp': offer.sdp,
      });
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      HttpClientRequest req = await client.postUrl(Uri.parse(uri.api));
      req.headers.set('Content-Type', 'application/json');
      req.add(utf8.encode(params));
      debugPrint('WebRTC request: ${uri.api} offer=${offer.sdp?.length}B');
      HttpClientResponse res = await req.close();
      String reply = await res.transform(utf8.decoder).join();
      debugPrint('WebRTC reply: ${reply.length}B, ${res.statusCode}');
      Map<String, dynamic> o = json.decode(reply);
      debugPrint('WebRTC got reply: $o');
      if (!o.containsKey('code') || !o.containsKey('sdp') || o['code'] != 0) {
        debugPrint('与信令服务器交换失败: 响应无效或错误代码. Response: $o');
        // 更新UI状态，告知用户推流失败
        isStreaming.value = false;
        return;
      }
      peerConnection?.setRemoteDescription(
        webrtc.RTCSessionDescription(o['sdp'], 'answer'),
      );
      debugPrint('信令交换完成，已设置远程描述');
    } catch (e) {
      debugPrint('与信令服务器通信失败: $e');
      debugPrint('webrtc地址: ${startUrl.value}');

      isStreaming.value = false; // 通信失败，更新状态
    } finally {
      isLoading.value = false;
      client.close();
    }
  }

  Future<void> getLiveInfo() async {
    if (isLoading.value || !hasMoreData.value) {
      return;
    }

    isLoading.value = true;
    try {
      final res = await _apiService.post(
        ApiUrls.liveInfoUrl,
        data: {
          'aid': anchorId.value,

          // 'aid': 16955,
          'page': currentPage.value,
          'limit': _limit,
        },
      );
      debugPrint('获取直播信息: ${res.data.toString()}');
      if (res.statusCode == 200) {
        totalUserCount.value = res.data['Data']['total'] ?? 0;
        final List<dynamic> newUsersData = res.data['Data']['data'] as List;
        if (newUsersData.isNotEmpty) {
          final newUsers =
              newUsersData
                  .map((item) => User.fromJson(item as Map<String, dynamic>))
                  .toList();
          userList.addAll(newUsers);
          currentPage.value++; // 成功后增加页码
          if (newUsers.length < _limit) {
            hasMoreData.value = false;
          }
        } else {
          hasMoreData.value = false;
        }
        debugPrint('直播信息获取成功: ${res.data.toString()}');
        // 处理直播信息
      } else {
        debugPrint('直播信息获取失败: ${res.statusCode}');
        hasMoreData.value = false;
      }
    } catch (e) {
      debugPrint('获取直播信息失败: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> stopPushStream() async {
    await _stopStatsLogging();
    _cancelAutoCoverScreenshotTimer();
    try {
      localStream?.getTracks().forEach((track) {
        track.stop();
      });
      await localStream?.dispose();
      localStream = null;

      await peerConnection?.close();
      await peerConnection?.dispose();
      peerConnection = null;

      localRenderer.srcObject = null;
      // await localRenderer.dispose();
    } catch (e) {
      debugPrint('停止推流时出错: $e');
    } finally {
      isStreaming.value = false;
      isLocalVideoInitialized.value = false;
      peerConnectionState.value =
          webrtc.RTCPeerConnectionState.RTCPeerConnectionStateClosed;
    }
  }

  @override
  void onClose() {
    _stopStatsLogging();
    stopPushStream();
    localRenderer.dispose();
    roomGoldController.dispose();
    roomNameController.dispose();
    messageController.dispose();
    svgaAnimationController.dispose();
    audioPlayer.dispose();
    _cancelAutoCoverScreenshotTimer();
    _disconnect();
    super.onClose();
  }

  Future<void> anchorOutUser(int userId, BuildContext context) async {
    try {
      final res = await _apiService.post(
        ApiUrls.anchorOutUserUrl,
        data: {
          'aid': anchorId.value,
          'uid': userId,
          'type': 2, // 1表示踢出用户
        },
      );
      debugPrint('踢出用户: ${res.data.toString()}');
      if (res.statusCode == 200) {
        debugPrint('踢出用户成功: ${res.data.toString()}');
        TDToast.showText('踢出用户成功', context: context);
        userList.clear();
        currentPage.value = 1;
        hasMoreData.value = true;
        getLiveInfo();
        // 处理成功逻辑
      } else {
        debugPrint('踢出用户失败: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('踢出用户失败: $e');
    }
  }

  //MARK 禁言用户
  Future<void> muteUser(User user, BuildContext context) async {
    try {
      final res = await _apiService.post(
        ApiUrls.updateSendMsUrl,
        data: {
          'aid': anchorId.value,
          'uid': user.userId,
          'type': user.isMuted.value ? 1 : 2, // 1表示开启静音，2表示关闭静音
        },
      );
      user.isMuted.value = !user.isMuted.value;
      debugPrint('禁言用户: ${res.data.toString()}');
      if (res.statusCode == 200) {
        debugPrint('禁言用户成功: ${res.data.toString()}');
        user.isMuted.value
            ? TDToast.showText('用户已被禁言', context: context)
            : TDToast.showText('用户已解除禁言', context: context);
      } else {
        debugPrint('禁言用户失败: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('禁言用户失败: $e');
    }
  }

  //MARK WSS
  void _connect() {
    if (webSocketManager != null) {
      return;
    }
    final url = wsUrl ?? '';

    webSocketManager = WebSocketManager(url: url, anchor: anchorId.value);
    webSocketManager!.onUserLogin = (user) {
      var ms = UserMessage(
        userName: user.nickname,
        message: '进来了',
        messageType: MessageType.userEnter,
      );
      messageList.add(ms);
      scrollMessageListToBottom();
      userList.clear();
      currentPage.value = 1;
      hasMoreData.value = true;
      getLiveInfo();
    };

    webSocketManager!.onUserLogout = (user) {
      var ms = UserMessage(
        userName: user.nickname,
        message: '${user.nickname} 退出了直播间',
        messageType: MessageType.userEnter,
      );
      messageList.add(ms);
      scrollMessageListToBottom();
      userList.clear();
      getLiveInfo();
    };
    webSocketManager!.onUserFocus = (user) {
      var ms = UserMessage(
        userName: user.nickname,
        message: '关注了主播',
        messageType: MessageType.userEnter,
      );
      messageList.add(ms);
      scrollMessageListToBottom();
    };
    webSocketManager!.onKickOutAnchor = () {
      var ms = UserMessage(
        userName: '主播',
        message: '离开了',
        messageType: MessageType.userEnter,
      );
      messageList.add(ms);
      scrollMessageListToBottom();
    };

    webSocketManager!.onRecvMessage = (msg) async {
      final senderId = msg.user?.userId;
      if (senderId == null) return;
      final res = await _apiService.post(
        ApiUrls.getUserInfoUrl,
        data: {'userId': msg.user?.userId},
      );
      final data = res.data['Data'];

      if (msg.user?.userId == anchorId.value) {
        var ms = UserMessage(
          userName: data['nickname'] ?? '',
          message: msg.text,
          avatarUrl: data['avatar'] ?? '',
          messageType: MessageType.chatMessage,
        );
        messageList.add(ms);
        scrollMessageListToBottom();
        return;
      }

      // --- 核心修改：在这里检查用户是否被禁言 ---
      try {
        // 1. 从 userList 中查找发消息的用户
        final sender = userList.firstWhere(
          (u) => u.userId.toString() == senderId.toString(),
        );

        // 2. 检查用户的 isMuted 状态
        if (sender.isMuted.value) {
          // 3. 如果用户被禁言，则打印日志并丢弃该消息
          debugPrint('<<< 收到被禁言用户 [${sender.userName}] 的消息，已屏蔽: ${msg.text}');
          return; // 直接返回，不把消息添加到 messageList
        }
      } catch (e) {
        // 如果在 userList 中没找到该用户（可能因为网络延迟等原因列表尚未刷新），
        // 默认先让消息通过，或根据产品要求决定是否屏蔽。
        // 这里我们选择让消息通过。
        debugPrint('在本地用户列表中未找到用户 $senderId，消息默认放行。错误: $e');
      }
      var ms = UserMessage(
        userName: msg.user?.nickname ?? '',
        message: msg.text,
        avatarUrl: msg.user?.avatar ?? '',
        messageType: MessageType.chatMessage,
      );
      messageList.add(ms);
      scrollMessageListToBottom();

      debugPrint('<<< 收到消息: ${msg.user?.nickname}: ${msg.text}');

      // messageList.add(ms);
      scrollMessageListToBottom();
    };
    webSocketManager!.onRecvGift = (giftMsg) async {
      debugPrint('<< 收到礼物: ${giftMsg.toString()}');
      final String actionText = giftMsg.getTypeName(giftMsg.gift?.type ?? 0);
      var ms = UserMessage(
        userName: giftMsg.user!.nickname,
        message: actionText + giftMsg.gift!.value,
        messageType: MessageType.userTiped,
      );
      messageList.add(ms);
      scrollMessageListToBottom();
      final String? svgaUrl = giftMsg.gift?.svga;
      if (svgaUrl != null && svgaUrl.isNotEmpty) {
        currentSvgaUrl.value = svgaUrl;
        _playSvgaAnimation(svgaUrl);
      }
      if (giftMsg.gift?.type == 1 && onTone.value) {
        await audioPlayer.play(AssetSource('sound/ring.mp3'));
      }
    };

    webSocketManager!.onEndLive = () {
      debugPrint('<< 直播已结束');
      var ms = UserMessage(
        userName: '',
        message: '直播已结束',
        messageType: MessageType.userEnter,
      );
      messageList.add(ms);
      scrollMessageListToBottom();
    };
    webSocketManager!.onKickMine = () {
      debugPrint('<< 警告: 你已被踢出房间！');
    };

    // 开始连接
    webSocketManager!.connect();
    debugPrint('连接指令已发送...');
  }

  void _disconnect() {
    webSocketManager?.disconnect();
    webSocketManager?.dispose(); // 清理资源
    webSocketManager = null;
    debugPrint('连接已断开并清理。');
  }

  void sendMessage() {
    if (webSocketManager == null) {
      debugPrint('WebSocketManager 未初始化，请先连接');
      return;
    }
    if (messageController.text.isEmpty) {
      debugPrint('错误: 消息不能为空。');
      return;
    }
    debugPrint('>> 发送消息: ${messageController.text}');
    webSocketManager!.sendMessage(messageController.text);
    messageController.clear();
  }

  void _log(String message) {
    logs.insert(
      0,
      '[${DateTime.now().toIso8601String().substring(11, 19)}] $message',
    );
  }

  Future<void> getQRCode() async {
    try {
      final res = await _apiService.post(
        ApiUrls.getQrCodeUrl,
        data: {'userId': anchorId.value},
      );
      if (res.statusCode == 200) {
        erCode.value = res.data['Data']['poster'] ?? '';
        debugPrint('二维码获取成功: ${erCode.value}');
      } else {
        debugPrint('二维码获取失败: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('获取二维码失败: $e');
    }
  }

  Future<void> _playSvgaAnimation(String url) async {
    if (url.isEmpty) return;

    try {
      final videoItem = await SVGAParser.shared.decodeFromURL(url);
      svgaAnimationController.videoItem = videoItem;
      svgaAnimationController.reset();
      svgaAnimationController.forward();
    } catch (e) {
      debugPrint("播放 SVGA 动画失败: $e");
      // 出错时，同样清空URL以隐藏播放器
      currentSvgaUrl.value = null;
    }
  }

  void testPlayGiftAnimation() {
    // 使用一个已知的网络 SVGA 地址进行测试
    const String testSvgaUrl =
        'http:\/\/shipinapi.dev.yimoit.com\/XResource\/20250622\/ZFtJTmYk7jXkcArdXp26GeQPsPSHckEp.svga';
    debugPrint("--- 开始手动测试播放SVGA: $testSvgaUrl ---");

    // 防止在动画播放时重复点击
    if (currentSvgaUrl.value != null) {
      debugPrint("动画正在播放中，请稍后重试");
      return;
    }

    // 调用我们之前写好的逻辑来播放动画
    currentSvgaUrl.value = testSvgaUrl;
    // _playSvgaAnimation(testSvgaUrl);
  }

  void _startAutoCoverScreenshotTimer() {
    _autoCoverScreenshotTimer?.cancel();

    _autoCoverScreenshotTimer = Timer.periodic(const Duration(seconds: 5), (
      timer,
    ) {
      debugPrint("定时器触发：正在截取并上传直播封面...");
      _captureAndUploadCover();
    });
  }

  void _cancelAutoCoverScreenshotTimer() {
    if (_autoCoverScreenshotTimer?.isActive ?? false) {
      _autoCoverScreenshotTimer!.cancel();
      debugPrint("自动封面截图定时器已取消。");
    }
  }

  Future<void> _captureAndUploadCover() async {
    // 确保正在推流且视频渲染器已初始化
    if (!isStreaming.value || !isLocalVideoInitialized.value) {
      debugPrint("截图失败：直播未在进行中。");
      return;
    }

    try {
      RenderRepaintBoundary boundary =
          videoWidgetKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) {
        debugPrint("截图失败：无法转换为 ByteData。");
        return;
      }
      Uint8List screenshotBytes = byteData.buffer.asUint8List();
      // 从 RTCVideoRenderer 捕获当前帧的截图

      if (screenshotBytes == null) {
        debugPrint("截图失败：无法获取图像数据。");
        return;
      }

      final response = await _apiService.uploadScreenshot(
        url: ApiUrls.uploadFileUrl,
        imageData: screenshotBytes,
        filename: 'cover_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      if (response.data['code'] == 200) {
        debugPrint("自动封面上传成功！");
      } else {
        debugPrint("自动封面上传失败，服务器信息: ${response.data['message']}");
      }
    } catch (e) {
      debugPrint("截图或上传过程中发生异常: $e");
    }
  }

  void scrollMessageListToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (messageScrollController.hasClients) {
        messageScrollController.animateTo(
          messageScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), // 滚动动画时长
          curve: Curves.easeOut,
        );
      }
    });
  }

  //MARK DEBUG
  Timer? _statsTimer;
  IOSink? _statsLogSink;
  webrtc.RTCPeerConnection? _loggingPC;

  Future<void> _startStatsLogging(webrtc.RTCPeerConnection pc) async {
    if (webrtc.WebRTC.platformIsDesktop) {
      _loggingPC = pc;
      try {
        final dir = await getApplicationDocumentsDirectory();
        final logPath =
            '${dir.path}/webrtc_stats_${DateTime.now().millisecondsSinceEpoch}.jsonl';
        print('WebRTC 统计日志将保存在: $logPath');

        _statsLogSink = File(logPath).openWrite(mode: FileMode.append);
        _statsTimer?.cancel();

        _statsTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
          if (_loggingPC == null) {
            timer.cancel();
            return;
          }
          try {
            final List<webrtc.StatsReport> reports =
                await _loggingPC!.getStats();
            final List<Map<String, dynamic>> reportMaps = [];

            for (final report in reports) {
              reportMaps.add({
                'id': report.id,
                'type': report.type,
                'timestamp': report.timestamp,
                'values': report.values,
              });
            }

            final String jsonString = json.encode(reportMaps);
            _statsLogSink?.writeln(jsonString);
          } catch (e) {
            print('获取或写入统计信息时出错: $e');
          }
        });
      } catch (e) {
        print('启动日志记录失败: $e');
      }
    }
  }

  Future<void> _stopStatsLogging() async {
    try {
      _statsTimer?.cancel();
      await _statsLogSink?.flush();
      await _statsLogSink?.close();
      _statsTimer = null;
      _statsLogSink = null;
      _loggingPC = null; // 清除引用
      print('WebRTC 统计日志记录已停止。');
    } catch (e) {
      print('停止日志记录时出错: $e');
    }
  }

  Future<void> loadMediaDevices() async {
    try {
      final devices = await webrtc.navigator.mediaDevices.enumerateDevices();
      availableVideoDevices.clear();
      availableAudioDevices.clear();

      for (var device in devices) {
        if (device.kind == 'videoinput') {
          availableVideoDevices.add(device);
        } else if (device.kind == 'audioinput') {
          availableAudioDevices.add(device);
        }
      }

      // 如果列表不为空，默认选中第一个设备
      if (availableVideoDevices.isNotEmpty) {
        selectedVideoDevice.value = availableVideoDevices.first;
      }
      if (availableAudioDevices.isNotEmpty) {
        selectedAudioDevice.value = availableAudioDevices.first;
      }
      print('视频设备数量: ${availableVideoDevices.length}');
      print('音频设备数量: ${availableAudioDevices.length}');
    } catch (e) {
      print('加载媒体设备失败: $e');
    }
  }
}
