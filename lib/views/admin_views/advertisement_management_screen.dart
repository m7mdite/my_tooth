import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/admin_controllers/admin_home_controller.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/app_constants/app_images_constant.dart';
import '../../utils/app_constants/colors_constant.dart';

class AdvertisementManagementScreen extends StatelessWidget {
  final AdminHomeController controller = Get.put(AdminHomeController());
  final ImagePicker picker = ImagePicker();

  AdvertisementManagementScreen({super.key});

  Future<void> _showAddDialog() async {
    final TextEditingController contentController = TextEditingController();
    File? selectedImage;

    await Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'إضافة إعلان جديد',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: contentController,
                  style: TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'محتوى الإعلان',
                    hintStyle: TextStyle(color: AppColors.textSecondary),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.borderColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primary),
                    ),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 16),
                if (selectedImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(selectedImage!,
                        height: 100, fit: BoxFit.cover),
                  )
                else
                  Text(
                    'لم يتم اختيار صورة',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                SizedBox(height: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                  ),
                  onPressed: () async {
                    final XFile? picked =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (picked != null) {
                      setState(() => selectedImage = File(picked.path));
                    }
                  },
                  icon: Icon(Icons.image),
                  label: Text('اختيار صورة'),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('إلغاء',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                ),
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                        if (selectedImage == null) {
                          Get.snackbar('تنبيه', 'الرجاء اختيار صورة');
                          return;
                        }
                        await controller.createAdvertisement(
                          contentController.text,
                          selectedImage!,
                        );
                      },
                child: controller.isLoading.value
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Text('إضافة'),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'إدارة الإعلانات',
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: AppColors.white),
            onPressed: _showAddDialog,
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          controller.onInit();
        },
        child: Obx(() {
          if (controller.isLoading.value && controller.advertisements.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (controller.advertisements.isEmpty) {
            // حالة فاضية: نستخدم خلفية الثيم من AppImages بدل نص عادي بس
            return Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.8,
                    child: Image.asset(
                      AppImages.authBackground,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'لا توجد إعلانات حالياً',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: controller.advertisements.length,
            itemBuilder: (context, index) {
              final adv = controller.advertisements[index];
              return Card(
                color: AppColors.cardColor,
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: AppColors.borderColor, width: 0.6),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: adv.image!.url!.isNotEmpty
                        ? Image.network(adv.image!.url!,
                            width: 60, height: 60, fit: BoxFit.cover)
                        : Icon(Icons.image,
                            size: 60, color: AppColors.textSecondary),
                  ),
                  title: Text(
                    adv.content!,
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  subtitle: Text(
                    'تاريخ الإضافة: ${adv.createdAt}',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: AppColors.error),
                    onPressed: () => _confirmDelete(adv.sId!),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  void _confirmDelete(String id) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'تأكيد الحذف',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'هل أنت متأكد من حذف هذا الإعلان؟',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('إلغاء',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              controller.deleteAdvertisement(id);
              Get.back();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text('حذف'),
          ),
        ],
      ),
    );
  }
}