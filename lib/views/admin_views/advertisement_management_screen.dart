import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/admin_controllers/admin_home_controller.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';

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
        title: Text('إضافة إعلان جديد'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(hintText: 'محتوى الإعلان'),
                  maxLines: 2,
                ),
                SizedBox(height: 16),
                if (selectedImage != null)
                  Image.file(selectedImage!, height: 100, fit: BoxFit.cover)
                else
                  Text('لم يتم اختيار صورة'),
                SizedBox(height: 8),
                ElevatedButton.icon(
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
          TextButton(onPressed: () => Get.back(), child: Text('إلغاء')),
          Obx(() => ElevatedButton(
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
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Text('إضافة'),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'إدارة الإعلانات',
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddDialog,
          ),
        ],
      ),

      
      body: RefreshIndicator(
        onRefresh: () async {
          controller.onInit();
        },
        child: Obx(() {
          if (controller.isLoading.value && controller.advertisements.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          if (controller.advertisements.isEmpty) {
            return Center(child: Text('لا توجد إعلانات حالياً'));
          }
          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: controller.advertisements.length,
            itemBuilder: (context, index) {
              final adv = controller.advertisements[index];
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: adv.image!.url!.isNotEmpty
                      ? Image.network(adv.image!.url!,
                          width: 60, height: 60, fit: BoxFit.cover)
                      : Icon(Icons.image, size: 60),
                  title: Text(adv.content!),
                  subtitle: Text('تاريخ الإضافة: ${adv.createdAt}'),
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
        title: Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف هذا الإعلان؟'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('إلغاء')),
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
