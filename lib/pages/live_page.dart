import 'package:flutter/material.dart';
import 'package:flutter_svga/flutter_svga.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:vido/constants/box_decoration.dart';
import 'package:vido/models/user.dart';
import 'package:vido/models/user_message.dart';
import 'package:vido/pages/controller/live_controller.dart';
import 'package:vido/pops/charge_settings/charge_settings_pop.dart';
import 'package:vido/pops/course_setting/course_setting_pop.dart';
import 'package:vido/pops/sreen_settings/sreen_setttings_pop.dart';
import 'package:vido/pops/start_live/start_live_pop.dart';
import 'package:vido/pops/tipp_settings/tip_settings_pop.dart';
import 'package:vido/pops/withdrawl/withdrawl_pop.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

class LivePage extends StatelessWidget {
  const LivePage({super.key});

  @override
  Widget build(BuildContext context) {
    final LiveController controller = Get.put(LiveController());
    return Scaffold(
      backgroundColor: Color(0xFF18181A),
      body: _buildLiveContent(context, controller),
    );
  }

  //MARK 总布局
  Widget _buildLiveContent(BuildContext context, LiveController controller) {
    return Column(
      children: [
        Obx(() => _buildCustomToolbar(controller)),
        Expanded(
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 2,
                child: Container(child: _buildInfo(context, controller)),
              ),
              Expanded(
                flex: 5,
                child: _buildStreamArea(context, controller),
                // Obx(() => _buildStreamArea(context, controller)),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: _buildInteractSection(context, controller),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //MARK 工具栏
  Widget _buildCustomToolbar(LiveController controller) {
    return Container(
      height: 56, // 工具栏高度
      color: const Color(0xFF212227), // 工具栏背景色
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 窗口可拖动区域，覆盖工具栏大部分空间
          Expanded(
            child: GestureDetector(
              onPanStart: (_) {
                windowManager.startDragging();
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  '测试系统',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ),
          ),
          Text(
            'tip'.tr,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(width: 4),

          TDSwitch(
            isOn: controller.onTone.value,
            onChanged: (value) {
              controller.toggleSound();
              return value;
            },
            trackOnColor: Color(0xFFEA4159),
            thumbContentOnColor: Color(0xFFEA4159),
          ),
          const SizedBox(width: 12),

          Container(width: 1, height: 16, color: Colors.white24),
          SizedBox(width: 12),
          Image.asset('assets/icons/book.png', width: 24, height: 24),
          const SizedBox(width: 4),

          Text(
            'platform_terms'.tr,
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(width: 12),

          Container(width: 1, height: 16, color: Colors.white24),
          SizedBox(width: 12),

          TDAvatar(
            avatarSize: 28,
            type: TDAvatarType.normal,
            defaultUrl: 'assets/images/avatar.jpg',
          ),
          SizedBox(width: 12),

          Text(
            controller.nickName.value,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(width: 16),
          Container(width: 1, height: 16, color: Colors.white24),

          TextButton(
            onPressed: () {
              windowManager.minimize();
            },
            child: const Text(
              '-',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.fullscreen, size: 18, color: Colors.white70),
            onPressed: () async {
              bool isMaximized = await windowManager.isMaximized();
              if (isMaximized) {
                windowManager.restore();
              } else {
                windowManager.maximize();
              }
            },
          ),

          // 关闭按钮
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.white70),
            onPressed: () {
              windowManager.close();
            },
          ),
        ],
      ),
    );
  }

  //MARK 左侧信息区
  Widget _buildInfo(BuildContext context, LiveController controller) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _buildRev(context),
          SizedBox(height: 12),
          _buildViewer(),
          SizedBox(height: 12),
          _buildQRcodeContainer(controller),
          // _buildDotsSwiper(context, controller),
          SizedBox(height: 12),

          Expanded(child: _buildUserListContainer(controller, context)),
        ],
      ),
    );
  }

  //收入区
  Widget _buildRev(BuildContext context) {
    return Container(
      height: 100,
      decoration: AppDecorations.buildPrimaryGradientDecoration(radius: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildRevDigitalCell('income'.tr, '1000.00'),
          _buildRevDigitalCell('balance'.tr, '5000.00'),
          _buildBtn(context),
        ],
      ),
    );
  }

  //收入和余额数字组件
  Widget _buildRevDigitalCell(String title, String number) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: TextStyle(fontSize: 18, color: Colors.white)),
        SizedBox(height: 10),
        Text(
          number,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontFamily: 'pingfang-h',
          ),
        ),
      ],
    );
  }

  //提现按钮
  Widget _buildBtn(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          TDSlidePopupRoute(
            modalBarrierColor: TDTheme.of(context).fontGyColor2,
            slideTransitionFrom: SlideTransitionFrom.center,
            builder: (context) {
              return const WithdrawlPop();
            },
          ),
        );
      },
      child: Container(
        height: 32,
        width: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.2),
        ),
        child: Center(
          child: Text(
            'withdraw'.tr,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  //观众信息区
  Widget _buildViewer() {
    return Container(
      height: 96,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color(0xFF212227),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildViewerCell('live_sessions'.tr, 'assets/icons/count.png', '1000'),
          _buildViewerCell(
            'live_duration'.tr,
            'assets/icons/clock.png',
            '1000',
            endText: 'minutes'.tr,
          ),

          _buildViewerCell('viewer_count'.tr, 'assets/icons/user.png', '1000'),
        ],
      ),
    );
  }

  // 观众信息单元格
  Widget _buildViewerCell(
    String title,
    String imgUrl,
    String dig, {
    String endText = '',
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imgUrl, width: 18, height: 18),
            SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(fontSize: 18, color: Color(0xFFCCCCCC)),
            ),
          ],
        ),
        SizedBox(width: 6),
        Text(
          dig + endText,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontFamily: 'pingfang-h',
          ),
        ),
      ],
    );
  }

  Widget _buildQRcodeContainer(LiveController controller) {
    return Container(
      height: 136,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withOpacity(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Obx(
              () => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                width: 90,
                height: 90,
                child: controller.erCode.value.isNotEmpty
                    ? Image.network(controller.erCode.value, fit: BoxFit.cover)
                    : Container(),
              ),
            ),
            SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(child: const Text('滚动消息滚动消息',style: TextStyle(fontSize: 18, color: Colors.white),)),
                InkWell(
                  onTap: controller.getQRCode,
                  child: Container(
                    width: 52,
                    height: 28,
                    decoration: AppDecorations.buildPrimaryGradientDecoration(radius: 16),
                    child: Center(child:  Text('refresh'.tr,style: TextStyle(fontSize: 14, color: Colors.white),)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  //轮播图
  Widget _buildDotsSwiper(BuildContext context, LiveController controller) {
    return SizedBox(
      height: 136,
      child: Swiper(
        autoplay: true,
        itemCount: controller.adList.length,
        loop: true,
        pagination: const SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: TDSwiperPagination.dots,
        ),
        itemBuilder: (BuildContext context, int index) {
          // debugPrint( '广告图片地址: ${controller.adList[index]['content']}');
          return TDImage(
            // imgUrl: controller.adList[index]['content'],
            assetUrl: 'assets/images/image.png',
            // type: TDImageType.clip,
          );
        },
      ),
    );
  }

  Widget _buildUserListContainer(
    LiveController liveController,
    BuildContext context,
  ) {
    return Column(
      children: [
        Obx(() => _buildHeader(liveController.totalUserCount.value.toString())),
        Expanded(child: _buildUserList(liveController, context)),
      ],
    );
  }

  // 用户列表头部
  /// @param userCount 在线用户数
  Widget _buildHeader(String userCount) {
    return Container(
      height: 56,
      // padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xFF2B2B2B),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 16),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,

            children: [
              const SizedBox(),
              Text('online_users'.tr, style: TextStyle(fontSize: 20, color: Colors.white)),
              SizedBox(height: 8),
              Container(
                height: 4,
                width: 24,
                decoration: AppDecorations.buildPrimaryGradientDecoration(
                  radius: 3,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ' $userCount',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //MARK 用户列表
  Widget _buildUserList(LiveController liveController, BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!liveController.isLoading.value &&
            liveController.hasMoreData.value &&
            scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent) {
          liveController.getLiveInfo();
          return true; 
        }
        return false; 
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF212227),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Obx(() {
          final itemCount =
              liveController.userList.length +
              (liveController.isLoading.value ? 1 : 0);

          return ListView.builder(
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index == liveController.userList.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFFEA4159)),
                  ),
                );
              }
              final user = liveController.userList[index];
              return _buildUserItem(user, liveController, context);
            },
          );
        }),
      ),
    );
  }

  //单个用户列表项
  Widget _buildUserItem(
    User user,
    LiveController liveController,
    BuildContext context,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //头像和用户名
              Row(
                children: [
                  SizedBox(
                    width: 34,
                    height: 34,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.avatarUrl),
                      // backgroundImage: AssetImage(user.avatarUrl),
                      radius: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    user.userName,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
              //操作按钮
              Row(
                children: [
                  Obx(()=>InkWell(
                    onTap: () {
                      liveController.muteUser(user, context);
                    },
                    child:
                        user.isMuted.value
                            ? Icon(Icons.mic_off, color: Colors.red, size: 22)
                            : Icon(
                              Icons.mic_outlined,
                              color: Colors.white,
                              size: 22,
                            ),
                    // Image.asset('assets/icons/micro.png', width: 18, height: 18)
                  ),),
                  SizedBox(width: 23),
                  InkWell(
                    onTap: () {
                      liveController.anchorOutUser(user.userId, context);
                    },
                    child: Image.asset(
                      'assets/icons/user_2.png',
                      width: 20,
                      height: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: const Divider(color: Color(0xFF2E2E2E), height: 1),
        ),
      ],
    );
  }

  Widget _buildStreamArea(BuildContext context, LiveController controller) {
    return Column(
      children: [
        Obx(() => _streamHeader(controller)),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildStream(controller),
              _buildSvgaPlayer(controller),
            ],
          ),
        ),
        SizedBox(height: 12),
        _buildStreamFoot(context, controller),
        SizedBox(height: 12),
      ],
    );
  }
   Widget _buildSvgaPlayer(LiveController controller) {
    return Obx(() {
      if (controller.currentSvgaUrl.value != null) {
        return IgnorePointer(
          ignoring: true, 
          child: SizedBox.expand( 
            child: SVGAImage(controller.svgaAnimationController),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  Widget _streamHeader(LiveController controller) {
    return Container(
      height: 144,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              controller.headImg.value,
              width: 144,
              height: 144,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[800],
                  width: 144,
                  height: 144,
                  child: Center(
                    child: Icon(Icons.error, color: Colors.grey[600], size: 48),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 16),
          //直播信息
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'live_title'.tr,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              // Container(
              //   width: 88,
              //   height: 32,
              //   decoration: BoxDecoration(
              //     color: Colors.white.withOpacity(0.2),
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: Center(
              //     child: const Text(
              //       '直播分类',
              //       style: TextStyle(fontSize: 16, color: Colors.white),
              //     ),
              //   ),
              // ),
              Row(
                children: [
                  Image.asset('assets/icons/fire.png', width: 18, height: 18),
                  Text(
                    '7895,34',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  //MARK 直播视频流
  Widget _buildStream(LiveController controller) {
    return Container(
      color: Color(0xFF000000),
      height: 755,
      child: Center(
        child: SizedBox(
          height: 100,
          child: Obx(() {
            if (controller.isLocalVideoInitialized.value) {
              return RepaintBoundary(
                key: controller.videoWidgetKey,
                child: webrtc.RTCVideoView(
                controller.localRenderer,
                objectFit:
                    webrtc.RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                mirror: controller.mirror.value,
              )
              );
            } else {
              // 否则显示占位符
              return  Center(
                child: SizedBox(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.videocam_off_outlined, // 换一个更合适的图标
                        size: 48,
                        color: Color.fromARGB(255, 153, 153, 153),
                      ),
                      SizedBox(height: 23),
                      Text(
                        'click_to_start_live'.tr,
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
        ),
      ),
      // padding: const EdgeInsets.symmetric(vertical: 12),
    );
  }

  //MARK直播间底部
  // 包含音频、视频滑动条和开始直播按钮
  Widget _buildStreamFoot(BuildContext context, LiveController controller) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Color(0xFF212227),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/icons/micro_2.png', width: 20, height: 20),
            Obx(() => _buildSingleHandleWithNumber(
              context,
              '',
              controller.volume.value,
              (newValue) {
                controller.volume.value = newValue;
              },
            ),),
            Image.asset('assets/icons/volume.png', width: 20, height: 20),

            Obx(() => _buildSingleHandleWithNumber(
              context,
              '',
              controller.micro.value,
              (newValue) {
                controller.micro.value = newValue;
              },
            ),),
            Obx(() => _buildStartBtn(context, controller)),
          ],
        ),
      ),
    );
  }

  Widget _buildStartBtn(BuildContext context, LiveController controller) {
    return InkWell(
      onTap: () {
        controller.isStreaming.value
            ? {
              controller.stopPushStream(),
              controller.endLiveBroadcast(),
              controller.isStreaming.value = false,
            }
            : {
              Navigator.of(context).push(
                TDSlidePopupRoute(
                  modalBarrierColor: TDTheme.of(context).fontGyColor2,
                  slideTransitionFrom: SlideTransitionFrom.center,
                  builder: (context) {
                    return StartLivePop(child: Container());
                  },
                ),
              ),
              controller.startLiveBroadcast(context),
            };
      },
      child: Container(
        width: 156,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white.withOpacity(0.1),
        ),

        child: Center(
          child: Text(
            controller.isStreaming.value ? 'end_live'.tr : 'start_live'.tr,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // 单个滑动条组件，带数字显示
  // Widget _buildSingleHandleWithNumber(BuildContext context) {
  //   return SizedBox(
  //     width: 284,
  //     // height: 300,
  //     child: TDSlider(
  //       boxDecoration: BoxDecoration(color: Colors.transparent),
  //       sliderThemeData: TDSliderThemeData(
  //         activeTrackColor: Color(0xFFEA4159),
  //         inactiveTrackColor: Color(0xFF2E2E2E),
  //         context: context,
  //         scaleFormatter: (value) => value.toInt().toString(),
  //         min: 0,
  //         max: 100,
  //       ),
  //       value: 10,
  //       rightLabel: '100',
  //       onChanged: (value) {},
  //     ),
  //   );
  // }
   Widget _buildSingleHandleWithNumber(
    BuildContext context,
    String label,
    double currentValue,
    Function(double) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontSize: 18)),
        SizedBox(
          width: 284,
          child: TDSlider(
            boxDecoration: BoxDecoration(color: Colors.transparent),
            sliderThemeData: TDSliderThemeData(
              activeTrackColor: Color(0xFFEA4159),
              inactiveTrackColor: Color(0xFF2E2E2E),
              context: context,
              scaleFormatter: (value) => value.toInt().toString(),
              min: 0,
              max: 100,
            ),
            value: currentValue,
            onChanged: onChanged,
          ),
        ),
        Text(
          currentValue.toInt().toString(),
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }

  //MARK 右边互动区
  Widget _buildInteractSection(
    BuildContext context,
    LiveController controller,
  ) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          _buildSettingPanel(context),
          SizedBox(height: 12),
          Expanded(child: _buildInteractList(controller)),
        ],
      ),
    );
  }

  // 设置面板
  Widget _buildSettingPanel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Color(0xFF212227),
      ),
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSettingCell(context, 'screen_settings'.tr, 'assets/icons/screen.png', () {
            Navigator.of(context).push(
              TDSlidePopupRoute(
                modalBarrierColor: TDTheme.of(context).fontGyColor2,
                slideTransitionFrom: SlideTransitionFrom.center,
                builder: (context) {
                  return const SreenSetttingsPop();
                },
              ),
            );
          }),
          _buildSettingCell(context, 'charge_settings'.tr, 'assets/icons/wallet.png', () {
            Navigator.of(context).push(
              TDSlidePopupRoute(
                modalBarrierColor: TDTheme.of(context).fontGyColor2,
                slideTransitionFrom: SlideTransitionFrom.center,
                builder: (context) {
                  return const ChargeSettingsPop();
                },
              ),
            );
          }),
          _buildSettingCell(context, 'tip_settings'.tr, 'assets/icons/coin.png', () {
            Navigator.of(context).push(
              TDSlidePopupRoute(
                modalBarrierColor: TDTheme.of(context).fontGyColor2,
                slideTransitionFrom: SlideTransitionFrom.center,
                builder: (context) {
                  return const TipSettingsPop();
                },
              ),
            );
          }),
          _buildSettingCell(context, 'course_settings'.tr, 'assets/icons/course.png', () {
            Navigator.of(context).push(
              TDSlidePopupRoute(
                modalBarrierColor: TDTheme.of(context).fontGyColor2,
                slideTransitionFrom: SlideTransitionFrom.center,
                builder: (context) {
                  return const CourseSettingsPop();
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  // 设置单元格
  Widget _buildSettingCell(
    BuildContext context,
    String title,
    String iconPath,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 48, height: 48),
          SizedBox(height: 10),
          Text(title, style: TextStyle(fontSize: 18, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildInteractList(LiveController controller) {
    return Column(
      children: [
        _buildInteractHeader(),
        Expanded(child: Obx(() => _buildMessageList(controller.messageList))),
        SizedBox(height: 48),
        Stack(
          children: [
            _input(controller.messageController, 'say_something'.tr),
            Positioned(
              right: 4,
              bottom: 4,
              child: InkWell(
                onTap: () {
                  controller.sendMessage();
                },
                child: Container(
                  width: 68,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFEA4159),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      'send'.tr,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInteractHeader() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Color(0xFF2B2B2B),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(),
              Text('interactive_messages'.tr, style: TextStyle(fontSize: 20, color: Colors.white)),
              SizedBox(height: 8),
              Container(
                height: 4,
                width: 24,
                decoration: AppDecorations.buildPrimaryGradientDecoration(
                  radius: 3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(List<UserMessage> messages) {
    final LiveController controller = Get.find<LiveController>();
    return Container(
      padding: const EdgeInsets.all(12),
      // height: 538,
      decoration: BoxDecoration(
        color: Color(0xFF212227),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListView.builder(
        controller: controller.messageScrollController,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return _buildMessageItem(messages[index]);
        },
      ),
    );
  }

  _buildMessageItem(UserMessage message) {
    if ((message.messageType != MessageType.chatMessage &&
        message.messageType != MessageType.anchorMessage)) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Image.asset('assets/icons/message.png', width: 18, height: 18),
          SizedBox(width: 8),
          Text(
            message.userName,
            style: TextStyle(fontSize: 18, color: Color(0xFFCCCCCC)),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              message.message,
              style: TextStyle(
                fontSize: 18,
                color: message.messageColor ?? Colors.white,
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          TDAvatar(
            avatarSize: 38,
            type: TDAvatarType.normal,
            avatarUrl: message.avatarUrl,
          ),
          SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  message.userName,
                  style: TextStyle(fontSize: 18, color: Color(0xFFCCCCCC)),
                ),
                SizedBox(height: 4),
                Text(
                  message.message,
                  style: TextStyle(
                    fontSize: 18,
                    color: message.messageColor ?? Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _input(
    TextEditingController controller,
    String hintText, {
    bool isPassword = false,
    double width = 460,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 33, 33, 33),
        borderRadius: BorderRadius.circular(5),
      ),
      height: 48,
      child: TextField(
        style: TextStyle(color: Colors.white, fontSize: 16),
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Color(0xFF969799), fontSize: 22),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        ),
      ),
    );
  }
}
