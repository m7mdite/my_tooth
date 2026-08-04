import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/admin_controllers/admin_notify_controller.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';

import '../../utils/app_constants/colors_constant.dart';

class AdminNotifyDialog extends StatelessWidget {
  const AdminNotifyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminNotifyController controller = Get.put(AdminNotifyController());

    return Center(
      child: Material(
        color: AppColors.transparent,
        child: Container(
          width: Get.width * 0.85,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppColors.transparent,
            border: Border.all(width: 3.5, color: AppColors.white),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.elliptical(100, 10),
              bottomLeft: Radius.elliptical(10, 100),
              topRight: Radius.elliptical(10, 100),
              bottomRight: Radius.elliptical(100, 10),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppConstants.defaultBackgroundImage),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.linearToSrgbGamma(),
                opacity: 0.8,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ===== العنوان =====
                  const Text(
                    'إرسال إشعار للجميع',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black87, // ✅ لون غامق
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16, top: 10),
                    height: 2,
                    color: AppColors.white,
                    width: 200,
                  ),

                  // ===== اختيار الأدوار =====
                  const Text(
                    'اختر الأدوار المستهدفة:',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.black54, // ✅ لون غامق
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // أزرار اختيار الأدوار
                  Obx(
                    () => Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.availableRoles.map((role) {
                        final isSelected = controller.isRoleSelected(role['value']);
                        return FilterChip(
                          label: Text(role['label']),
                          selected: isSelected,
                          onSelected: (_) => controller.toggleRole(role['value']),
                          avatar: Icon(
                            role['icon'],
                            size: 16,
                            color: isSelected ? AppColors.white : AppColors.grey.shade600,
                          ),
                          backgroundColor: AppColors.grey.shade100,
                          selectedColor: AppColors.primary700,
                          checkmarkColor: AppColors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.white : AppColors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: isSelected ? AppColors.primary : AppColors.grey300,
                              width: 1.5,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ===== حقل العنوان =====
                  TextField(
                    controller: controller.titleController,
                    style: const TextStyle(color: AppColors.black87),
                    decoration: InputDecoration(
                      hintText: 'عنوان الإشعار...',
                      hintStyle: TextStyle(color: AppColors.grey.shade500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.grey300),
                      ),
                      filled: true,
                      fillColor: AppColors.white.withOpacity(0.85),
                      prefixIcon: Icon(Icons.title, color: AppColors.grey.shade600),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ===== حقل المحتوى =====
                  TextField(
                    controller: controller.bodyController,
                    maxLines: 3,
                    style: const TextStyle(color: AppColors.black87),
                    decoration: InputDecoration(
                      hintText: 'محتوى الإشعار...',
                      hintStyle: TextStyle(color: AppColors.grey.shade500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.grey300),
                      ),
                      filled: true,
                      fillColor: AppColors.white.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ===== رسالة الخطأ (إن وجدت) =====
                  Obx(
                    () => controller.selectedRoles.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              '⚠️ يرجى اختيار دور واحد على الأقل',
                              style: TextStyle(
                                color: AppColors.error.shade700,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  // ===== الخط الفاصل =====
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 12),
                    height: 2,
                    color: AppColors.white,
                    width: 200,
                  ),

                  // ===== أزرار الإجراء =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // زر الإلغاء
                      InkWell(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(width: 1.5, color: AppColors.error),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.elliptical(100, 10),
                              bottomLeft: Radius.elliptical(10, 100),
                              topRight: Radius.elliptical(10, 100),
                              bottomRight: Radius.elliptical(100, 10),
                            ),
                          ),
                          child: const Text(
                            'إلغاء',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ),
                      ),

                      // زر الإرسال
                      Obx(
                        () => InkWell(
                          onTap: controller.isLoading.value
                              ? null
                              : controller.sendNotification,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(width: 1.5, color: AppColors.success),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.elliptical(100, 10),
                                bottomLeft: Radius.elliptical(10, 100),
                                topRight: Radius.elliptical(10, 100),
                                bottomRight: Radius.elliptical(100, 10),
                              ),
                            ),
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.success,
                                    ),
                                  )
                                : const Text(
                                    'إرسال',
                                    style: TextStyle(color: AppColors.success),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}