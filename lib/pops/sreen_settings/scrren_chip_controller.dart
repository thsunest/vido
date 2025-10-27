import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';
class ScreenChipController extends GetxController {
  // 控制器的状态变量
  var currentValue = 5.0.obs; // 当前值，初始为5

  var skinSmoothingValue = 50.0.obs; // 磨皮
  var whiteningValue = 50.0.obs; // 美白
  var eyeEnlargingValue = 50.0.obs; // 大眼
  var faceThinningValue = 50.0.obs; // 瘦脸

  @override
  void onInit() async{
    super.onInit();
  }

  // 更新当前值
  void updateCurrentValue(double value) {
    currentValue.value = value;
  }
}
