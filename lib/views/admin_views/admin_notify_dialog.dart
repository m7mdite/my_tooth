// lib/views/admin_views/admin_notify_dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/admin_controllers/admin_notify_controller.dart';

class AdminNotifyDialog extends StatelessWidget {
  const AdminNotifyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminNotifyController controller = Get.put(AdminNotifyController());

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: Get.width * 0.9,
        height: Get.height * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Row(
              children: [
                const Icon(Icons.notifications_active, color: Colors.blue, size: 28),
                const SizedBox(width: 10),
                const Text(
                  'إرسال إشعار للجميع',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // وصف الإشعار
            const Text(
              'سيتم إرسال هذا الإشعار لجميع مستخدمي التطبيق (الطلاب، المرضى، المشرفين)',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // حقل النص
            TextField(
              controller: controller.messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'اكتب محتوى الإشعار هنا...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                filled: true,
                fillColor: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // أزرار الإجراء
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.sendNotification,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'إرسال',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}