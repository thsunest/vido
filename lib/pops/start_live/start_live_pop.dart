import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:vido/pages/controller/live_controller.dart';
import 'package:vido/pops/start_live/start_live_controller.dart';
import 'package:vido/constants/box_decoration.dart';
import 'package:vido/widgets/input.dart';
import 'package:vido/widgets/window_header.dart';

//进入弹窗的方法
///      onTap: () {
//               Navigator.of(context).push(
//           TDSlidePopupRoute(
//             modalBarrierColor: TDTheme.of(context).fontGyColor2,
//             slideTransitionFrom: SlideTransitionFrom.center,
//             builder: (context) {
//               return const WithdrawlPop();
//             },
//           ),
//         );
//       },
///
class StartLivePop extends StatelessWidget {
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final Widget? child;

  StartLivePop({
    super.key,
    this.backgroundColor,
    this.width,
    this.height,
    this.child,
    this.args,
  });
  final Map? args;
  final List<TDUploadFile> files1 = [];

  void onClick(int key) {
    print('点击 $key');
  }

  void onCancel() {
    print('取消');
  }

  @override
  Widget build(BuildContext context) {
    final LiveController liveController = Get.put(LiveController());
    final startLiveController = Get.put(StartLiveController());
    startLiveController.clearFiles();
    return Container(
      width: width ?? 640,
      height: height ?? 580,
      decoration: AppDecorations.popBorderDecoration,
      child: Column(
        children: [
          WindowHeader(label: 'start_live'.tr),
          //MARK 布局
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _inputComposed(
                  'live_title'.tr,
                  'enter_live_title'.tr,
                  context,
                  liveController.roomNameController,
                ),
                _uploadSingle(context, startLiveController),
                _inputComposed(
                  'live_category'.tr,
                  'select_live_category'.tr,
                  context,
                  liveController.roomNameController,
                ),
              Obx(() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 105),
                child: _buildDeviceSelector(
                        context: context,
                        label: 'video_device'.tr,
                        devices: liveController.availableVideoDevices,
                        selectedDevice: liveController.selectedVideoDevice.value,
                        onChanged: (device) {
                          liveController.selectedVideoDevice.value = device;
                        },
                      ),
              )),
                Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 105),
                  child: _buildDeviceSelector(
                        context: context,
                        label: 'audio_device'.tr,
                        devices: liveController.availableAudioDevices,
                        selectedDevice: liveController.selectedAudioDevice.value,
                        onChanged: (device) {
                          liveController.selectedAudioDevice.value = device;
                        },
                      ),
                )),
              ],
            ),
          ),
          buildBtnCom(context, liveController),
        ],
      ),
    );
  }

  //MARK input
  Widget _inputComposed(
    String label,
    String hintText,
    BuildContext context,
    TextEditingController controller,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(color: Colors.white, fontSize: 18)),
          Input(controller: controller, hintText: hintText),
        ],
      ),
    );
  }

  Widget wrapDemoContainer(String title, {required Widget child}) {
    return Container(
      height: 120,
      width: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Color.fromARGB(255, 46, 47, 51)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [child],
      ),
    );
  }

  //MARK upload
  Widget _uploadSingle(BuildContext context, StartLiveController controller) {
    return wrapDemoContainer(
      'single_choice_upload'.tr,
      child: Obx(
        () => TDUpload(
          files: controller.uploadedFiles.toList(),
          onClick: onClick,
          onCancel: onCancel,
          onError: print,
          onValidate: print,
          onChange:
              (files, type) => controller.onValueChanged(files, type),
        ),
      ),
    );
  }

  //MARK开播
  Widget buildBtnCom(BuildContext context, LiveController liveController) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildCancelBtn(context, '取消', () {
            Get.back();
          }),
          SizedBox(width: 24),
          buildBtn(context, '开始直播', () {
            liveController.liveBoradcastSettings(context);
          }),
        ],
      ),
    );
  }

  Widget buildBtn(BuildContext context, String title, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 88,
        height: 38,
        decoration: AppDecorations.buildPrimaryGradientDecoration(radius: 4),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget buildCancelBtn(
    BuildContext context,
    String title,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 88,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
  Widget _buildDeviceSelector({
    required BuildContext context,
    required String label,
    required List<webrtc.MediaDeviceInfo> devices,
    required webrtc.MediaDeviceInfo? selectedDevice,
    required ValueChanged<webrtc.MediaDeviceInfo?> onChanged,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(color: Colors.white, fontSize: 18)),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 46, 47, 51),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<webrtc.MediaDeviceInfo>(
                  value: selectedDevice,
                  isExpanded: true,
                  dropdownColor: Color.fromARGB(255, 46, 47, 51),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white70),
                  hint: Text(
                    devices.isEmpty ? '未找到设备' : '请选择设备',
                    style: TextStyle(color: Colors.white54),
                  ),
                  items: devices.map((device) {
                    return DropdownMenuItem<webrtc.MediaDeviceInfo>(
                      value: device,
                      child: Text(
                        device.label,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
