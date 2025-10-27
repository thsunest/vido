import 'package:flutter/material.dart';

class AppDecorations {
  //渐进色的装饰
  static BoxDecoration buildPrimaryGradientDecoration({double radius = 5.0}) {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      gradient: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFFEA4159), // #EA4159
          Color(0xFFE5655C), // #E5655C
        ],
        stops: [0.0, 1.0],
      ),
    );
  }

    //次要按钮的装饰
  static BoxDecoration cacelDecoration({double radius = 4.0}) {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  //弹窗的边框装饰
  static final BoxDecoration popBorderDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    color: Color(0xFF212227),
    border: Border.all(color: Color(0xFF444444), width: 1),
  );

}
