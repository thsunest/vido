import 'package:flutter/material.dart';
import 'package:get/get.dart';
//窗户头
class WindowHeader extends StatelessWidget implements PreferredSizeWidget {
  final String label; // 标题文本
  final VoidCallback? onClose; // 关闭按钮的回调
  final Color borderColor; // 底部边框颜色
  final double borderWidth; // 底部边框宽度
  final Color labelColor; // 标题文本颜色
  final double labelFontSize; // 标题文本字体大小
  final Color closeIconColor; // 关闭图标颜色
  final double height; // 标题栏高度


  const WindowHeader({
    super.key,
    required this.label,
    this.onClose,
    this.borderColor = const Color(0xFF444444),
    this.borderWidth = 1.0,
    this.labelColor = Colors.white, // 默认为纯白色，可以调整为 withOpacity(0.5)
    this.labelFontSize = 18.0,
    this.closeIconColor = Colors.white,
    this.height = 56.0, // 默认高度
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: borderColor, width: borderWidth),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: labelColor.withOpacity(0.5), // 确保 opacity 应用到传入的颜色上
              fontSize: labelFontSize,
            ),
          ),
          IconButton(
            onPressed: onClose ?? Get.back, // 使用传入的回调
            icon: Icon(Icons.close, color: closeIconColor),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height); // 实现 PreferredSizeWidget
}