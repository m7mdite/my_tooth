// controllers/admin_controllers/admin_notify_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:gr_flutter/services/functions/handling_data.dart';
import 'package:gr_flutter/utils/app_constants/status_request.dart';

import '../../services/remote/admin_remotes/admin_remote.dart';
import '../../utils/app_constants/colors_constant.dart';

class AdminNotifyController extends GetxController {
  final AdminRemote adminRemote = AdminRemote(Get.find());
  
  // Controllers للنصوص
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  
  // الأدوار المختارة
  RxList<String> selectedRoles = <String>[].obs;
  RxBool isLoading = false.obs;
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;

  // قائمة الأدوار المتاحة مع تسمياتها
  final List<Map<String, dynamic>> availableRoles = [
    {'value': 'student', 'label': 'طلاب', 'icon': Icons.school},
    {'value': 'patient', 'label': 'مرضى', 'icon': Icons.health_and_safety},
    {'value': 'overseer', 'label': 'مشرفين', 'icon': Icons.verified_user},
    {'value': 'admin', 'label': 'مديرين', 'icon': Icons.admin_panel_settings},
  ];

  @override
  void onInit() {
    super.onInit();
    // تحديد دور "student" كافتراضي (يمكنك تغييره)
    selectedRoles.add('student');
  }

  void toggleRole(String role) {
    if (selectedRoles.contains(role)) {
      selectedRoles.remove(role);
    } else {
      selectedRoles.add(role);
    }
    update();
  }

  bool isRoleSelected(String role) {
    return selectedRoles.contains(role);
  }

  Future<void> sendNotification() async {
    final title = titleController.text.trim();
    final body = bodyController.text.trim();

    if (title.isEmpty) {
      Get.snackbar('تنبيه', 'الرجاء كتابة عنوان الإشعار');
      return;
    }
    if (body.isEmpty) {
      Get.snackbar('تنبيه', 'الرجاء كتابة محتوى الإشعار');
      return;
    }
    if (selectedRoles.isEmpty) {
      Get.snackbar('تنبيه', 'الرجاء اختيار دور واحد على الأقل');
      return;
    }

    isLoading.value = true;
    statusRequest.value = StatusRequest.loading;
    update();

    final response = await adminRemote.notifyUsersByRoles(
      title: title,
      body: body,
      roles: selectedRoles,
    );
    
    statusRequest.value = handlingData(response);

    if (statusRequest.value == StatusRequest.success) {
      titleController.clear();
      bodyController.clear();
      // لا نغلق الديالوج تلقائياً لنعرض للمستخدم النتيجة
      Get.snackbar(
        'نجاح',
        response['message'] ?? 'تم إرسال الإشعار بنجاح',
        backgroundColor: AppColors.success,
        colorText: AppColors.white,
        duration: const Duration(seconds: 4),
      );
    } else {
      Get.snackbar(
        'خطأ',
        response['message'] ?? 'فشل إرسال الإشعار',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    }

    isLoading.value = false;
    update();
  }

  @override
  void onClose() {
    titleController.dispose();
    bodyController.dispose();
    super.onClose();
  }
}