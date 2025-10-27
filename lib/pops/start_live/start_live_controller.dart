import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class StartLiveController extends GetxController {
  final uploadedFiles = <TDUploadFile>[].obs;
  void onValueChanged(
    List<TDUploadFile> value,
    TDUploadType event,
  ) {
    switch (event) {
      case TDUploadType.add:
        uploadedFiles.addAll(value);

        break;
      case TDUploadType.remove:
        uploadedFiles.removeWhere((element) => element.key == value[0].key);

        break;
      case TDUploadType.replace:
        final firstReplaceFile = value.first;
        final index = uploadedFiles.indexWhere(
          (file) => file.key == firstReplaceFile.key,
        );
        if (index != -1) {
          uploadedFiles[index] = firstReplaceFile;
        }

        break;
    }
  }
   void clearFiles() {
    uploadedFiles.clear();
  }
}
