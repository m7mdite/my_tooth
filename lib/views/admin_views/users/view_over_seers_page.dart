import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controllers/admin_users_controller.dart';
import '../../../utils/app_constants/colors_constant.dart';
import '../../../utils/app_constants/status_request.dart';
import '../../widgets/custom_app_bar.dart';

class ViewOverSeersPage extends StatelessWidget {
  final AdminUsersControllerImpl controller =
      Get.find<AdminUsersControllerImpl>();

  ViewOverSeersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "المشرفين",
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.getAllOverSeers(),
        child: GetBuilder<AdminUsersControllerImpl>(
          builder: (controller) {
            if (controller.statusRequest == StatusRequest.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.overSeers.isEmpty) {
              return const Center(child: Text("لا يوجد مشرفين"));
            }
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 12,
                color: AppColors.primary,
                endIndent: 50,
                indent: 50,
              ),
              padding: const EdgeInsets.all(12),
              itemCount: controller.overSeers.length,
              itemBuilder: (context, index) {
                final overSeer = controller.overSeers[index];
                return Card(
                  // margin: const EdgeInsets.only(bottom: 12),
                  // elevation: 3,
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(16),
                  // ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text(
                        (overSeer.firstName?.isNotEmpty ?? false)
                            ? overSeer.firstName![0].toUpperCase()
                            : "?",
                        style: const TextStyle(color: AppColors.white),
                      ),
                    ),
                    title: Text(
                      "${overSeer.firstName ?? ''} ${overSeer.fatherName ?? ''} ${overSeer.lastName ?? ''}"
                          .trim(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("البريد: ${overSeer.email ?? 'غير متوفر'}"),
                        if (overSeer.bio != null && overSeer.bio!.isNotEmpty)
                          Text("نبذة: ${overSeer.bio}"),
                        if (overSeer.category != null)
                          Text(
                              "الفئة: ${overSeer.category!.category ?? 'غير متوفر'}"),
                        if (overSeer.gender != null)
                          Text("الجنس: ${overSeer.gender ?? 'غير متوفر'}"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                      onPressed: () => _confirmDelete(overSeer.user!),
                    ),
                    // isThreeLine: true,
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
        content: const Text("هل أنت متأكد من حذف هذا المشرف؟"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("إلغاء")),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteOverSeer(id);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text("حذف"),
          ),
        ],
      ),
    );
  }
}
