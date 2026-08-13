import 'dart:io';

import 'package:get/get.dart';
import 'package:gr_flutter/services/remote/admin_remotes/admin_remote.dart';

import '../../models/admin_models/advertisement_model.dart';
import '../../services/functions/handling_data.dart';
import '../../services/remote/crud.dart';
import '../../utils/app_constants/status_request.dart';

abstract class AdminHomeCntr extends GetxController{

}
class AdminHomeController extends AdminHomeCntr{
  final AdminRemote remote = AdminRemote(Get.find<Crud>());
  RxList<AdvertisementModel> advertisements = <AdvertisementModel>[].obs;
  RxBool isLoading = false.obs;
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAdvertisements();
  }

    Future<void> fetchAdvertisements() async {
    isLoading.value = true;
    statusRequest.value = StatusRequest.loading;
    var response = await remote.getAllAdvertisements();
    statusRequest.value = handlingData(response);
    if (statusRequest.value == StatusRequest.success) {
       List<dynamic> data = response['data'] ?? [];
      advertisements.value = data.map((json) => AdvertisementModel.fromJson(json)).toList();
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل تحميل الإعلانات');
    }
    isLoading.value = false;
  }

  Future<void> createAdvertisement(String content, File imageFile) async {
    if (content.trim().isEmpty) {
      Get.snackbar('تنبيه', 'الرجاء كتابة محتوى الإعلان');
      return;
    }
    isLoading.value = true;
    final response = await remote.createAdvertisement(content: content, imageFile: imageFile);
    if (handlingData(response) == StatusRequest.success) {
      Get.back(); // إغلاق الحوار
      await fetchAdvertisements();
      Get.snackbar('نجاح', 'تم إضافة الإعلان بنجاح');
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل الإضافة');
    }
    isLoading.value = false;
  }

  Future<void> deleteAdvertisement(String id) async {
    isLoading.value = true;
    final response = await remote.deleteAdvertisement(id);
    if (handlingData(response) == StatusRequest.success) {
      advertisements.removeWhere((adv) => adv.sId == id);
      Get.snackbar('نجاح', 'تم حذف الإعلان بنجاح');
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل الحذف');
    }
    isLoading.value = false;
  }
}