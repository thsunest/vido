import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final TextEditingController controller; // 输入框控制器
  final String hintText; // 提示文本
  final bool isPassword; // 是否为密码框
  final double width; // 输入框宽度
  final Color? backgroundColor; // 背景颜色
  final BorderRadius? borderRadius; // 边框圆角
  final double? height; // 高度
  final TextStyle? hintTextStyle; // 提示文本样式
  final TextStyle? inputTextStyle; // 输入文本样式
  final EdgeInsetsGeometry? contentPadding; // 内容内边距
  final Widget? suffixIcon; // 右侧图标 (例如清除按钮或密码可见性切换)
  final Widget? prefixIcon; // 左侧图标

  const Input({
    super.key,
    required this.controller, // 控制器是必须的
    required this.hintText, // 提示文本是必须的
    this.isPassword = false,
    this.width = 350,
    this.backgroundColor = const Color.fromARGB(255, 46, 47, 51), // 默认背景色
    this.borderRadius, // 默认不设置，让Container的默认生效，或直接设置一个默认值
    this.height = 48, // 默认高度
    this.hintTextStyle, // 默认使用内部 TextStyle
    this.inputTextStyle, // 默认使用内部 TextStyle
    this.contentPadding, // 默认使用内部 EdgeInsets
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(4), // 默认圆角
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style:
            inputTextStyle ??
            const TextStyle(
              color: Colors.white, // 默认输入文本颜色
              fontSize: 18, // 默认输入文本字体大小
            ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              hintTextStyle ??
              const TextStyle(
                color: Color(0xFF969799),
                fontSize: 18,
              ), 
          border: InputBorder.none, // 移除默认边框
          contentPadding:
              contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // 默认内边距
          suffixIcon: suffixIcon, // 右侧图标
          prefixIcon: prefixIcon, // 左侧图标
        ),
      ),
    );
  }
}
