import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vido/constants/box_decoration.dart';
import 'package:vido/widgets/bottom_actions_btn.dart';
import 'package:vido/widgets/input.dart';
import 'package:vido/widgets/window_header.dart';

//添加提现渠道的弹窗
class AddChannelPop extends StatelessWidget {
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final Widget? child; // 允许传入子Widget

  const AddChannelPop({
    super.key,
    this.backgroundColor,
    this.width,
    this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 460, // 默认宽度
      height: height ?? 430, // 默认高度
      decoration: AppDecorations.popBorderDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              WindowHeader(
                label: 'add_channel'.tr,
                onClose: () => Navigator.pop(context),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _inputComposed('channel'.tr, 'select_channel'.tr, context),
              SizedBox(height: 24),
              _inputComposed('account_name'.tr, 'enter_account_name'.tr, context),
              SizedBox(height: 24),
              _inputComposed('account'.tr, 'select_account'.tr, context),
              SizedBox(height: 24),
              _inputComposed('remark'.tr, 'enter_remark'.tr, context),
              SizedBox(height: 24),
            ],
          ),
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
    );
  }

  Widget _inputComposed(String label, String hintText, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(color: Colors.white, fontSize: 18)),
          Input(controller: TextEditingController(), hintText: hintText),
        ],
      ),
    );
  }
}
