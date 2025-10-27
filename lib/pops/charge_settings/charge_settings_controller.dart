import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChargeSettingsController extends GetxController {
  var openCharge = false.obs;
  // var perSession = false.obs;
  // var perHour = false.obs;

  var selectedChargeMethod = 0.obs;
  TextEditingController chargeMethodController = TextEditingController();

  void toggleCharge() {
    openCharge.value = !openCharge.value;
  }

  void selectChargeMethod(int method) {
    selectedChargeMethod.value = method;
    debugPrint('Selected charge method: $method');
  }


}
