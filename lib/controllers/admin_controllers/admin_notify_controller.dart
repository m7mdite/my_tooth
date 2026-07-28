// lib/controllers/admin_controllers/admin_notify_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/services/functions/handling_data.dart';
import 'package:gr_flutter/utils/app_constants/status_request.dart';

import '../../services/remote/admin_remotes/admin_remote.dart';

class AdminNotifyController extends GetxController {
  final AdminRemote adminRemote = AdminRemote(Get.find());
  final TextEditingController messageController = TextEditingController();
  RxBool isLoading = false.obs;
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;

  Future<void> sendNotification() async {
    final content = messageController.text.trim();
    if (content.isEmpty) {
      Get.snackbar('تنبيه', 'الرجاء كتابة محتوى الإشعار');
      return;
    }

    isLoading.value = true;
    statusRequest.value = StatusRequest.loading;
    update();

    final response = await adminRemote.notifyAll(content);
    statusRequest.value = handlingData(response);

    if (statusRequest.value == StatusRequest.success) {
      messageController.clear();
      Get.back(); // إغلاق الديالوج
      Get.snackbar('نجاح', 'تم إرسال الإشعار لجميع المستخدمين');
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل إرسال الإشعار');
    }

    isLoading.value = false;
    update();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}