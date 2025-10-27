//添加提现渠道的弹窗
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:vido/constants/box_decoration.dart';
import 'package:vido/models/course.dart';
import 'package:vido/pops/tipp_settings/tip_settings_controller.dart';
import 'package:vido/widgets/bottom_actions_btn.dart';
import 'package:vido/widgets/input.dart';
import 'package:vido/widgets/window_header.dart';

class TipSettingsPop extends StatelessWidget {
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final Widget? child; // 允许传入子Widget

  const TipSettingsPop({
    super.key,
    this.backgroundColor,
    this.width,
    this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final TipSettingsController controller = Get.put<TipSettingsController>(
      TipSettingsController(),
    );
    return Container(
      width: width ?? 880, // 默认宽度
      height: height ?? 600, // 默认高度
      decoration: AppDecorations.popBorderDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WindowHeader(
                label: '打赏设置',
                onClose: () => Navigator.pop(context),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                buildHeadBtn(context, controller),
                const SizedBox(height: 18), // Add some space
                buildListHeader(),
                // 1. 使用 Expanded 包裹列表，使其填充剩余空间
                Expanded(
                  child: Obx(
                    () => buildList(controller, controller.addedGifts),
                  ),
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
          ),
        ],
      ),
    );
  }

  Widget buildHeadBtn(BuildContext context, TipSettingsController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              foregroundColor: const Color(0xFFE94859),
              side: const BorderSide(color: Color(0xFFE94859)),
            ),
            child: const Text('添加'),
            onPressed: () {
              /**
               * 弹窗
               */
              Navigator.of(context).push(
                TDSlidePopupRoute(
                  modalBarrierColor: TDTheme.of(context).fontGyColor2,
                  slideTransitionFrom: SlideTransitionFrom.center,
                  builder: (context) {
                    return Container(
                      width: 460,
                      height: 430,
                      decoration: BoxDecoration(
                        color: const Color(0xFF212227),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xFF444444),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WindowHeader(
                            label: '添加渠道',
                            onClose: () => Navigator.pop(context),
                          ),

                          Column(
                            children: [
                              _inputComposed(
                                '名称',
                                '请输入名称',
                                context,
                                controller.giftNameController,
                              ),
                              const SizedBox(height: 12),
                              _inputComposed(
                                '价格',
                                '请输入价格',
                                context,
                                controller.giftPriceController,
                              ),
                            ],
                          ),
                          BottomActionButtons(
                            cancelTitle: '取消',
                            onCancelPressed: () {
                              Navigator.pop(context); // 关闭弹窗
                            },
                            confirmTitle: '确定',
                            onConfirmPressed: () {
                              controller.addGift();
                              Navigator.pop(context); // 关闭弹窗
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  //输入框组合
  Widget _inputComposed(
    String label,
    String hintText,
    BuildContext context,
    TextEditingController controller,
  ) {
    return SizedBox(
      // width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(color: Colors.white, fontSize: 18)),
          Input(controller: controller, hintText: hintText),
        ],
      ),
    );
  }

  //表头
  Widget buildListHeader() {
    return Container(
      height: 48,
      color: Colors.white.withOpacity(0.06),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        // Using a Row is simpler here
        children: const [
          Expanded(
            flex: 4,
            child: Center(
              child: Text(
                '名称',
                style: TextStyle(color: Color(0xFF999999), fontSize: 16),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                '金币',
                style: TextStyle(color: Color(0xFF999999), fontSize: 16),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                '操作',
                style: TextStyle(color: Color(0xFF999999), fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildList(TipSettingsController controller, List<Course> addedGifts) {
    return ListView.builder(
      itemCount: addedGifts.length,
      itemBuilder: (context, index) {
        final course = addedGifts[index];
        return buildListItem(
          course.name,
          course.price.toString(),
          controller,
          course,
          context,
        );
      },
    );
  }

  // 列表子项
  Widget buildListItem(
    String itemName,
    String coin,
    TipSettingsController controller,
    Course course,
    BuildContext context,
  ) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
      ), // Align with header padding
      child: Row(
        // Directly use a Row
        children: [
          Expanded(
            flex: 4,
            child: Center(
              child: Text(
                itemName,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                overflow: TextOverflow.ellipsis, // Prevent text overflow
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                coin,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '上/下架',
                    style: const TextStyle(
                      color: Color(0xFF77DFFE),
                      fontSize: 16,
                    ), // Made action color standout
                    overflow: TextOverflow.ellipsis,
                  ),
                  InkWell(
                    onTap: () {
                      controller.prepareEdit(course); // 准备编辑
                      Navigator.of(context).push(
                        TDSlidePopupRoute(
                          modalBarrierColor: TDTheme.of(context).fontGyColor2,
                          slideTransitionFrom: SlideTransitionFrom.center,
                          builder: (context) {
                            return Container(
                              width: 460,
                              height: 430,
                              decoration: BoxDecoration(
                                color: const Color(0xFF212227),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: const Color(0xFF444444),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  WindowHeader(
                                    label: '编辑',
                                    onClose: () => Navigator.pop(context),
                                  ),

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _inputComposed(
                                        '名称：',
                                        '请输入名称',
                                        context,
                                        controller.giftNameController,
                                      ),
                                      SizedBox(height: 24),
                                      _inputComposed(
                                        '金币：',
                                        '请输入金币',
                                        context,
                                        controller.giftPriceController,
                                      ),
                                    ],
                                  ),
                                  BottomActionButtons(
                                    cancelTitle: '取消',
                                    onCancelPressed: () {
                                      controller.exitEdit();
                                      Navigator.pop(context); // 关闭弹窗
                                    },
                                    confirmTitle: '确定',
                                    onConfirmPressed: () {
                                      controller.updateGift(); // 调用更新课程方法
                                      // 执行确定操作
                                      Navigator.pop(context); // 关闭弹窗
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                      // 编辑操作
                    },
                    child: Text(
                      '编辑',
                      style: const TextStyle(
                        color: Color(0xFF77DFFE),
                        fontSize: 16,
                      ), // Made action color standout
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      controller.deleteGift(course.id); // 删除操作
                    },
                    child: Text(
                      '删除',
                      style: const TextStyle(
                        color: Color(0xFF77DFFE),
                        fontSize: 16,
                      ), // Made action color standout
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
