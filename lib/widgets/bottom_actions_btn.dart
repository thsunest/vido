import 'package:flutter/material.dart';
import 'package:vido/constants/box_decoration.dart';

// 定义按钮的类型，以便区分主色调和次要色调按钮
enum BottomButtonType {
  primary, // 主要按钮，使用AppDecorations.buildPrimaryGradientDecoration
  secondary, // 次要按钮，使用半透明背景
}

// 抽象出的单个按钮 Widget (私有或内部使用)
class _ActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final BottomButtonType type;
  final double width;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle; // 允许自定义文字样式

  const _ActionButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.type = BottomButtonType.primary,
    this.width = 88,
    this.height = 38,
    this.borderRadius = 4,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration;
    TextStyle currentTextStyle = textStyle ??
        const TextStyle(color: Colors.white, fontSize: 18);
    // 根据按钮类型选择不同的装饰
    if (type == BottomButtonType.primary) {
      decoration = AppDecorations.buildPrimaryGradientDecoration(radius: borderRadius);
    } else {
      // BottomButtonType.secondary
      decoration = AppDecorations.cacelDecoration(radius: borderRadius);
    }

    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: decoration,
        child: Center(
          child: Text(
            title,
            style: currentTextStyle,
          ),
        ),
      ),
    );
  }
}


// 抽象出的底部按钮组 Widget (这是外部会使用的)
class BottomActionButtons extends StatelessWidget {
  final String? cancelTitle; // 取消按钮的标题，如果为null则不显示
  final VoidCallback? onCancelPressed; // 取消按钮的回调
  final String confirmTitle; // 确定按钮的标题
  final VoidCallback onConfirmPressed; // 确定按钮的回调
  final EdgeInsetsGeometry padding; // 整个按钮组的内边距
  final double buttonSpacing; // 按钮之间的间距
  final double buttonWidth; // 单个按钮的默认宽度
  final double buttonHeight; // 单个按钮的默认高度
  final double buttonBorderRadius; // 单个按钮的默认圆角

   BottomActionButtons({
    Key? key,
    this.cancelTitle,
    this.onCancelPressed,
    required this.confirmTitle,
    required this.onConfirmPressed,
    this.padding = const EdgeInsets.all(16),
    this.buttonSpacing = 16,
    this.buttonWidth = 88,
    this.buttonHeight = 38,
    this.buttonBorderRadius = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // 按钮组靠右对齐
        children: [
          // 取消按钮（如果存在）
          if (cancelTitle != null && onCancelPressed != null)
            _ActionButton(
              title: cancelTitle!,
              onPressed: onCancelPressed!,
              type: BottomButtonType.secondary,
              width: buttonWidth,
              height: buttonHeight,
              borderRadius: buttonBorderRadius,
            ),
          
          // 如果有取消按钮，则添加间距
          if (cancelTitle != null && onCancelPressed != null)
            SizedBox(width: buttonSpacing),
          
          // 确定按钮
          _ActionButton(
            title: confirmTitle,
            onPressed: onConfirmPressed,
            type: BottomButtonType.primary,
            width: buttonWidth,
            height: buttonHeight,
            borderRadius: buttonBorderRadius,
          ),
        ],
      ),
    );
  }
}