import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/services/remote/public_remotes/support_remote.dart';

class SupportController extends GetxController {
  final SupportRemote supportRemote = SupportRemote(Get.find());
  final formKey = GlobalKey<FormState>();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();
  final isLoading = false.obs;

  Future<void> sendMessage() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      var response = await supportRemote.sendSupportMessage(
        subject: subjectController.text.trim(),
        message: messageController.text.trim(),
      );
      // افترض أن response تحتوي على 'status' أو ما شابه
      if (response['status'] == 'success') {
        Get.back(); // العودة إلى الإعدادات
        Get.snackbar('تم', 'تم إرسال رسالتك بنجاح، سيتم الرد عليها قريباً',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('خطأ', response['message'] ?? 'فشل الإرسال، حاول مجدداً');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ، تحقق من اتصالك بالإنترنت');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    subjectController.dispose();
    messageController.dispose();
    super.onClose();
  }
}