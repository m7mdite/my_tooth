import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controllers/admin_request_controller.dart';
import '../../../utils/app_constants/colors_constant.dart';
import '../../../utils/app_constants/status_request.dart';
import '../../widgets/custom_app_bar.dart';

class ViewCategorysPage extends StatelessWidget {
  final AdminRequestControllerImpl controller = Get.find<AdminRequestControllerImpl>();

  ViewCategorysPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "عرض الفئات",
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.getAllCategory(),
        child: GetBuilder<AdminRequestControllerImpl>(
          builder: (controller) {
            if (controller.statusRequest == StatusRequest.loading &&
                controller.categorys.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.categorys.isEmpty) {
              return const Center(child: Text("لا توجد فئات"));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: controller.categorys.length,
              separatorBuilder: (context, index) {
                return const Divider(
                  color: AppColors.primary,
                  endIndent: 50,
                  indent: 50,
                  thickness: 1,
                );
              },
              itemBuilder: (context, index) {
                final category = controller.categorys[index];
                final categoryName = category['category'] ?? "اسم غير متوفر";
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    // leading: CircleAvatar(
                    //   backgroundColor: AppColors.primary,
                    //   child: Text(
                    //     "${index + 1}",
                    //     style: const TextStyle(color: AppColors.white),
                    //   ),
                    // ),
                    title: Text(
                      categoryName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      onPressed: () => _confirmDelete(category['_id'] ?? category['id']!),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _confirmDelete(String id) {
    Get.dialog(
      AlertDialog(
        title: const Text("تأكيد الحذف"),
        content: const Text("هل أنت متأكد من حذف هذه الفئة؟"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("إلغاء")),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteCategory(id);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text("حذف"),
          ),
        ],
      ),
    );
  }
}