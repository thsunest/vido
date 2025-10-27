//添加提现渠道的弹窗
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:vido/constants/box_decoration.dart';
import 'package:vido/models/gift.dart';
import 'package:vido/pops/course_setting/course_setting_controller.dart';
import 'package:vido/widgets/bottom_actions_btn.dart';
import 'package:vido/widgets/input.dart';
import 'package:vido/widgets/window_header.dart';

class CourseSettingsPop extends StatelessWidget {
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final Widget? child; // 允许传入子Widget

  const CourseSettingsPop({
    super.key,
    this.backgroundColor,
    this.width,
    this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final CourseSettingController controller = Get.put(
      CourseSettingController(),
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
                label: '课程设置',
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
                Expanded(
                  child: Obx(
                    () => buildList(controller.addedGifts, context, controller),
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

  Widget buildHeadBtn(
    BuildContext context,
    CourseSettingController controller,
  ) {
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
              // controller.exitEdit(); // 清空输入框
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
                            label: '添加',
                            onClose: () => Navigator.pop(context),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _inputComposed(
                                '时间：',
                                '请输入时间',
                                context,
                                controller.courseDurationController,
                              ),
                              SizedBox(height: 24),
                              _buildCourseDropdown(controller),
                              SizedBox(height: 24),
                              _inputComposed(
                                '金币：',
                                '请输入金币',
                                context,
                                controller.coursePriceController,
                              ),
                            ],
                          ),
                          BottomActionButtons(
                            cancelTitle: '取消',
                            onCancelPressed: () {
                              controller.exitEdit(); // 清空输入框
                              Navigator.pop(context); // 关闭弹窗
                            },
                            confirmTitle: '确定',
                            onConfirmPressed: () {
                              controller.addCourse(); // 调用添加课程方法
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
          Input(width: 322, controller: controller, hintText: hintText),
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
            flex: 1,
            child: Center(
              child: Text(
                '时间',
                style: TextStyle(color: Color(0xFF999999), fontSize: 16),
              ),
            ),
          ),
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

  Widget buildList(
    List<Gift> gifts,
    BuildContext context,
    CourseSettingController controller,
  ) {
    return ListView.builder(
      itemCount: gifts.length,
      itemBuilder: (context, index) {
        final gift = gifts[index];
        return buildListItem(
          gift.duration.toString(),
          gift.value,
          gift.price.toString(),
          gift,
          context,
          controller,
        );
      },
    );
  }

  // 列表子项
  Widget buildListItem(
    String duraiton,
    String name,
    String price,

    Gift gift,
    BuildContext context,
    CourseSettingController controller,
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
            flex: 1,
            child: Center(
              child: Text(
                gift.duration.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                overflow: TextOverflow.ellipsis, // Prevent text overflow
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: Text(
                gift.value,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                overflow: TextOverflow.ellipsis, // Prevent text overflow
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                gift.price.toString(),
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
                    /**
                     * 编辑的弹窗
                     */
                    onTap: () {
                      controller.prepareEdit(gift); // 准备编辑
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
                                        '时间：',
                                        '请输入时间',
                                        context,
                                        controller.courseDurationController,
                                      ),
                                      SizedBox(height: 24),
                                      _inputComposed(
                                        '金币：',
                                        '请输入金币',
                                        context,
                                        controller.coursePriceController,
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
                                      controller.updateCourse(); // 调用更新课程方法
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
                      Get.snackbar('Edit', 'Edit action for ');
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
                      controller.deleteCourse(gift);
                      Get.snackbar('Delete', 'Delete action for ${gift.value}');
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
  // course_setting_pop.dart

  Widget _buildCourseDropdown(CourseSettingController controller) {
    return SizedBox(
      width: 480,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '名称：',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(width: 8),
          Obx(() {
            if (controller.giftItems.isEmpty) {
              return Container(
                width: 320,
                height: 48,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 46, 47, 51),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  '加载中...',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }
            return Container(
              width: 320,
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 46, 47, 51),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Gift>(
                  value: controller.selectedGift.value,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF969799),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  dropdownColor: const Color(0xFF212227),
                  onChanged: (Gift? newValue) {
                    if (newValue != null) {
                      controller.updateSelectedGift(newValue);
                    }
                  },
                  items:
                      controller.giftItems.map<DropdownMenuItem<Gift>>((
                        Gift gift,
                      ) {
                        return DropdownMenuItem<Gift>(
                          value: gift,
                          child: Text(gift.value),
                        );
                      }).toList(),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
