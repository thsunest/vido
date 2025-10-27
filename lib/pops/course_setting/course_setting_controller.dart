import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vido/constants/url.dart';
import 'package:vido/models/gift.dart';
import 'package:vido/service/api_service.dart';

class CourseSettingController extends GetxController {
  // 控制器的逻辑
  final RxBool isCourseSettingVisible = false.obs;
  final RxList<Gift> giftItems = <Gift>[].obs;
  final Rxn<Gift> selectedGift = Rxn<Gift>();
  final RxList<Gift> addedGifts = <Gift>[].obs;
  final Rxn<Gift> editingGift = Rxn<Gift>();

  final ApiService _apiService = Get.find<ApiService>();

  final box = GetStorage();

  final TextEditingController coursePriceController = TextEditingController();
  final TextEditingController courseDurationController =
      TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchAddedCourses();
    fetchCourses();
  }

  void toggleCourseSetting() {
    isCourseSettingVisible.value = !isCourseSettingVisible.value;
  }

  void closeCourseSetting() {
    isCourseSettingVisible.value = false;
  }

  void updateSelectedGift(Gift? newValue) {
    selectedGift.value = newValue;
  }

  void exitEdit() {
    coursePriceController.clear();
    courseDurationController.clear();
    selectedGift.value = null;
    isCourseSettingVisible.value = false;
  }

  //获取可添加礼物的下拉列表
  Future<void> fetchCourses() async {
    try {
      final response = await _apiService.get(ApiUrls.getGiftUrl, params: {});
      if (response.statusCode == 200) {
        final data = response.data['Data'];
        if (data is List) {
          giftItems.clear();
          for (var item in data) {
            if (item is Map<String, dynamic> && item.containsKey('value')) {
              giftItems.add(Gift.fromJson(item));
            }
          }
          if (giftItems.isNotEmpty) {
            selectedGift.value = giftItems.first;
          }
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch courses');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching courses: $e');
    }
  }

  Future<void> fetchAddedCourses() async {
    final userId = box.read('userId');
    if (userId == null) {
      Get.snackbar('Error', 'User not logged in');
      return;
    }
    try {
      final response = await _apiService.get(
        '${ApiUrls.getGiftListUrl}?aid=$userId', params: {},
      );
      if (response.statusCode == 200) {
        final data = response.data['Data'];
        debugPrint('Fetched added courses: $data');
        if (data is List) {
          addedGifts.clear();
          for (var item in data) {
            if (item is Map<String, dynamic>) {
              // 这里的调用将使用新版本的 fromJson 方法
              addedGifts.add(Gift.fromJson(item));
            }
          }
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch added courses');
      }
    } catch (e) {
      debugPrint('Error fetching added courses: $e');
      Get.snackbar(
        'Error',
        'An error occurred while fetching added courses: $e',
      );
    }
  }

  Future<void> addCourse() async {
    final userId = box.read('userId');
    try {
      final response = await _apiService.post(
        ApiUrls.addGiftUrl,
        data: {
          'aid': userId,
          'price': int.parse(coursePriceController.text),
          'duration': int.parse(courseDurationController.text),
          'key': selectedGift.value?.key ?? '',
        },
      );
      if (response.statusCode == 200) {
        final newGift = Gift(
          key: selectedGift.value!.key,
          value: selectedGift.value!.value,
          valueEn: selectedGift.value!.valueEn,
          price: int.parse(coursePriceController.text),
          duration: int.parse(courseDurationController.text),
        );
        addedGifts.add(newGift);
        exitEdit();
        debugPrint(response.data.toString());

        Get.snackbar('Success', 'Course added successfully');
      } else {
        Get.snackbar('Error', 'Failed to add course');
      }
    } catch (e) {
      debugPrint('Error adding course: $e');
    }
  }

  Future<void> updateCourse() async {
    if (editingGift.value == null) {
      Get.snackbar('错误', '没有要编辑的课程');
      return;
    }
    final userId = box.read('userId');
    final price = int.tryParse(coursePriceController.text);
    final duration = int.tryParse(courseDurationController.text);
    if (price == null || duration == null) {
      Get.snackbar('错误', '金币和时长必须为数字');
      return;
    }

    try {
      final response = await _apiService.post(
        ApiUrls.updateGiftUrl,
        data: {
          'id': editingGift.value!.id,
          'aid': userId,
          'price': price,
          'duration': duration,
          'key': editingGift.value!.key, // 使用编辑礼物的 key
        },
      );
      if (response.statusCode == 200) {
        // 在列表中找到并更新礼物信息
        final index = addedGifts.indexWhere(
          (gift) => gift.key == editingGift.value!.key,
        );
        if (index != -1) {
          addedGifts[index].price = price;
          addedGifts[index].duration = duration;
        }
        addedGifts.refresh(); // 手动刷新列表
        Get.snackbar('成功', '课程更新成功');
        exitEdit();
      } else {
        Get.snackbar('错误', '课程更新失败');
      }
    } catch (e) {
      debugPrint('更新课程失败: $e');
    }
  }

  void prepareEdit(Gift gift) {
    editingGift.value = gift;
    coursePriceController.text = gift.price?.toString() ?? '';
    courseDurationController.text = gift.duration?.toString() ?? '';
  }

  Future<void> deleteCourse(Gift gift) async {
    final userId = box.read('userId');
    try {
      final response = await _apiService.post(
        ApiUrls.deleteGiftUrl,
        data: {'aid': userId, 'id': gift.id},
      );
      if (response.statusCode == 200) {
        addedGifts.remove(gift);
        Get.snackbar('成功', '课程删除成功');
      } else {
        Get.snackbar('错误', '课程删除失败');
      }
    } catch (e) {
      debugPrint('删除课程失败: $e');
    }
  }
}
