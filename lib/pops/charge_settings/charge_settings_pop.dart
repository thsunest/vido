//添加提现渠道的弹窗
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:vido/constants/box_decoration.dart';
import 'package:vido/pages/controller/live_controller.dart';
import 'package:vido/pops/charge_settings/charge_settings_controller.dart';
import 'package:vido/widgets/bottom_actions_btn.dart';
import 'package:vido/widgets/input.dart';
import 'package:vido/widgets/window_header.dart';

class ChargeSettingsPop extends StatelessWidget {
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final Widget? child; // 允许传入子Widget

  const ChargeSettingsPop({
    super.key,
    this.backgroundColor,
    this.width,
    this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ChargeSettingsController controller = Get.put(
      ChargeSettingsController(),
    );
    final LiveController liveController = Get.put(LiveController());
    return Container(
      width: width ?? 460, // 默认宽度
      height: height ?? 430, // 默认高度
      decoration: AppDecorations.popBorderDecoration,
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              WindowHeader(
                label: 'charge_settings'.tr,
                onClose: () => Navigator.pop(context),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => _buildSwitch(context, 'enable_charging'.tr, liveController)),
                  Obx(
                    () => _buildChargeMethod(
                      context,
                      liveController.roomGoldController,
                      'enter_coins'.tr,
                      'per_session_charge'.tr,
                      liveController,
                      1,
                    ),
                  ),
                  Obx(
                    () => _buildChargeMethod(
                      context,
                      TextEditingController(),
                      'please_select'.tr,
                      'time_based_charge'.tr,
                      liveController,
                      2,
                    ),
                  ),

                   Text(
                    'coins_per_minute'.tr,
                    style: TextStyle(color: Color(0xFF999999), fontSize: 14),
                  ),
                  BottomActionButtons(
                    cancelTitle: 'cancel'.tr,
                    onCancelPressed: () {
                      Navigator.pop(context); // 关闭弹窗
                    },
                    confirmTitle: 'confirm'.tr,
                    onConfirmPressed: () {
                      if (liveController.roomGoldController.text.isEmpty) {
                        TDToast.showText('coin_amount_required'.tr, context: context);
                      } else {
                        Navigator.pop(context); // 关闭弹窗
                      }
                      
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch(
    BuildContext context,
    String title,
    LiveController liveController,
  ) {
    return Row(
      children: [
        Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
        SizedBox(
          width: 44,
          height: 24,
          child: TDSwitch(
            isOn: liveController.openCharge.value,
            onChanged: (value) {
              liveController.toggleCharge();
              liveController.isCharge.value = value ? 1 : 0;
              return value;
            },
            trackOnColor: Color(0xFFEA4159),
            thumbContentOnColor: Color(0xFFEA4159),
          ),
        ),
      ],
    );
  }

  Widget _buildChargeMethod(
    BuildContext context,
    TextEditingController controller,
    String hintText,
    String frontText,
    LiveController chargeSettingsController,
    int methodValue,
  ) {
    return SizedBox(
      width: 412,
      child: Row(
        children: [
          SizedBox(
            height: 48,
            width: 48,
            child: Radio(
              value: methodValue,
              groupValue: chargeSettingsController.selectedChargeMethod.value,
              onChanged: (value) {
                chargeSettingsController.selectChargeMethod(methodValue);
              },
            ),
          ),
          Text(frontText, style: TextStyle(color: Colors.white, fontSize: 18)),
          Input(controller: controller, hintText: hintText, width: 297),
        ],
      ),
    );
  }
}
