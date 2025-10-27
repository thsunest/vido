import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:vido/constants/box_decoration.dart';
import 'package:vido/pops/add_chanel/add_channel_pop.dart';
import 'package:vido/widgets/bottom_actions_btn.dart';
import 'package:vido/widgets/input.dart';
import 'package:vido/widgets/window_header.dart';

class WithdrawlPop extends StatelessWidget {
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final Widget? child; // 允许传入子Widget

  const WithdrawlPop({
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
              WindowHeader(label: '提现', onClose: () => Navigator.pop(context)),
              _btn(context),
            ],
          ),
          Column(
            children: [
              _inputComposed('渠道：', '请选择渠道', context),
              SizedBox(height: 24),
              _inputComposed('金币：', '请输入账号名称', context),
            ],
          ),
          BottomActionButtons(
            cancelTitle: '取消',
            onCancelPressed: () {
              Navigator.pop(context); // 关闭弹窗
            },
            confirmTitle: '确定',
            onConfirmPressed: () {
              // 执行确定操作
              Navigator.pop(context); // 关闭弹窗
            },
          ),
        ],
      ),
    );
  }

  Widget _btn(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Color(0xFFE94859).withOpacity(0.1),
            foregroundColor: Color(0xFFE94859),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: Color(0xFFE94859)),
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(
              TDSlidePopupRoute(
                modalBarrierColor: TDTheme.of(context).fontGyColor2,
                slideTransitionFrom: SlideTransitionFrom.center,
                builder: (context) {
                  return const AddChannelPop();
                },
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            child: const Text('添加渠道', style: TextStyle(fontSize: 18)),
          ),
        ),
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
