//添加提现渠道的弹窗
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:vido/constants/box_decoration.dart';
import 'package:vido/pages/controller/live_controller.dart';
import 'package:vido/pops/sreen_settings/scrren_chip_controller.dart';
import 'package:vido/widgets/bottom_actions_btn.dart';
import 'package:vido/widgets/window_header.dart';

class SreenSetttingsPop extends StatelessWidget {
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final Widget? child; // 允许传入子Widget

  const SreenSetttingsPop({
    super.key,
    this.backgroundColor,
    this.width,
    this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ScreenChipController screenChipController = Get.put(
      ScreenChipController(),
    );
    final LiveController liveController = Get.find<LiveController>();
    return Container(
      width: width ?? 640, // 默认宽度
      height: height ?? 580, // 默认高度
      decoration: AppDecorations.popBorderDecoration,
      child: Column(
        children: [
          WindowHeader(label: '画面设置'),
          _buildContent(context, screenChipController, liveController),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ScreenChipController screenChipController,
    LiveController liveController,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //画面操作按钮组
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSettingBtn('mirror_flip'.tr, () {
                  liveController.mirror.value = !liveController.mirror.value;
                  TDToast.showText(liveController.mirror.value ? 'mirror_enabled'.tr : 'mirror_disabled'.tr, context: context);
                }, 'assets/icons/flip.png'),
                _buildSettingBtn('screen_rotation'.tr, () {}, 'assets/icons/revolve.png'),
              ],
            ),
            //画面效果操作组
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(
                    () => _buildSingleHandleWithNumber(
                      context,
                      'skin_smoothing'.tr,
                      screenChipController.skinSmoothingValue.value,
                      (newValue) =>
                          screenChipController.skinSmoothingValue.value =
                              newValue,
                    ),
                  ),
                  Obx(
                    () => _buildSingleHandleWithNumber(
                      context,
                      'whitening'.tr,
                      screenChipController.whiteningValue.value,
                      (newValue) =>
                          screenChipController.whiteningValue.value = newValue,
                    ),
                  ),
                  Obx(
                    () => _buildSingleHandleWithNumber(
                      context,
                      'eye_enlarging'.tr,
                      screenChipController.eyeEnlargingValue.value,
                      (newValue) =>
                          screenChipController.eyeEnlargingValue.value =
                              newValue,
                    ),
                  ),
                  Obx(
                    () => _buildSingleHandleWithNumber(
                      context,
                      'face_thinning'.tr,
                      screenChipController.faceThinningValue.value,
                      (newValue) =>
                          screenChipController.faceThinningValue.value =
                              newValue,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BottomActionButtons(
                  cancelTitle: 'cancel'.tr,
                  onCancelPressed: () {
                    Navigator.pop(context); // 关闭弹窗
                  },
                  confirmTitle: 'confirm'.tr,
                  onConfirmPressed: () {
                    // 执行确定操作
                    Navigator.pop(context); // 关闭弹窗
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingBtn(
    String title,
    VoidCallback onPressed,
    String iconPath,
  ) {
    return SizedBox(
      height: 109,
      child: InkWell(
        onTap: onPressed,
        splashColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(iconPath, width: 68, height: 68),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }

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
          width: 412,
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
}
