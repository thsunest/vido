import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vido/constants/url.dart';
import 'package:vido/models/course.dart';
import 'package:vido/service/api_service.dart';

class TipSettingsController extends GetxController {
  final RxList<Course> addedGifts = <Course>[].obs;
  final ApiService _apiService = Get.find<ApiService>();
  final Rxn<Course> editingGift = Rxn<Course>();

  final TextEditingController giftPriceController = TextEditingController();
  final TextEditingController giftNameController = TextEditingController();

  final box = GetStorage();

  @override
  void onInit() {
    fetchAddedGifts();
    super.onInit();
  }

  void exitEdit() {
    giftPriceController.clear();
    giftNameController.clear();
  }

  Future<void> fetchAddedGifts() async {
    final aid = box.read('userId');
    try {
      final response = await _apiService.get('${ApiUrls.getGift2Url}?aid=$aid', params: {});
      if (response.statusCode == 200) {
        final data = response.data['Data'];
        if (data is List) {
          addedGifts.clear();
          for (var item in data) {
            if (item is Map<String, dynamic>) {
              addedGifts.add(Course.fromJson(item));
            }
          }
        }
      } else {
        debugPrint('获取礼物列表失败: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('获取礼物列表异常: $e');
    }
  }

  Future<void> addGift() async {
    final String name = giftNameController.text.trim();
    final String price = giftPriceController.text.trim();

    final userId = box.read('userId');

    if (name.isEmpty || price.isEmpty) {
      Get.snackbar('错误', '名称和价格不能为空');
      return;
    }

    try {
      final response = await _apiService.post(
        ApiUrls.addGift2Url,

        data: {price: price, 'aid': userId, 'name': name, 'name_en': name},
      );
      if (response.statusCode == 200) {
        final newCourse = Course.fromJson(response.data['Data']);
        addedGifts.add(newCourse);
        exitEdit();

        Get.snackbar('成功', '礼物添加成功');
        fetchAddedGifts(); // 刷新列表
      } else {
        Get.snackbar('失败', '添加礼物失败: ${response.data}');
      }
    } catch (e) {
      Get.snackbar('异常', '添加礼物异常: $e');
    }
  }

  Future<void> updateGift() async {
    if (editingGift.value == null) {
      Get.snackbar('错误', '没有正在编辑的礼物');
      return;
    }
    final int aid = box.read('userId');
    final int id = editingGift.value!.id;
    final String name = giftNameController.text.trim();
    final int price = int.tryParse(giftPriceController.text.trim()) ?? 0;

    if (name.isEmpty || price == 0) {
      Get.snackbar('错误', '名称和价格不能为空');
      return;
    }

    try {
      final response = await _apiService.post(
        ApiUrls.updateGift2Url,
        data: {'aid': aid, 'id': id, 'name': name, 'price': price},
      );
      if (response.statusCode == 200) {
        final updatedCourse = Course(
          id: id,
          anchorId: aid,
          type: 1,
          name: name,
          price: price,
          nameEn: name,
        );
        final index = addedGifts.indexWhere((gift) => gift.id == id);
        if (index != -1) {
          addedGifts[index] = updatedCourse;
        }
        exitEdit();
        Get.snackbar('成功', '礼物更新成功');
      } else {
        Get.snackbar('失败', '更新礼物失败: ${response.data}');
      }
    } catch (e) {
      debugPrint('更新礼物异常: $e');
      Get.snackbar('异常', '更新礼物异常: $e');
    }
  }

  Future<void> deleteGift(int id) async {
    final int aid = box.read('userId');

    try {
      final response = await _apiService.post(
        ApiUrls.deleteGift2Url,
        data: {'aid': aid, 'id': id},
      );
      if (response.statusCode == 200) {
        addedGifts.removeWhere((gift) => gift.id == id);
        Get.snackbar('成功', '礼物删除成功');
      } else {
        Get.snackbar('失败', '删除礼物失败: ${response.data}');
      }
    } catch (e) {
      Get.snackbar('异常', '删除礼物异常: $e');
    }
  }

  void prepareEdit(Course course) {
    editingGift.value = course;
    giftPriceController.text = course.price.toString();
    giftNameController.text = course.name;
  }
}
