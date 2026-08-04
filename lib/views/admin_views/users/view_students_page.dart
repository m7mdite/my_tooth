import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controllers/admin_users_controller.dart';
import '../../../utils/app_constants/colors_constant.dart';
import '../../../utils/app_constants/status_request.dart';
import '../../widgets/custom_app_bar.dart';

class ViewStudentsPage extends StatelessWidget {
  final AdminUsersControllerImpl controller =
      Get.find<AdminUsersControllerImpl>();

  ViewStudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "الطلاب",
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.getAllStudents(),
        child: GetBuilder<AdminUsersControllerImpl>(
          builder: (controller) {
            if (controller.statusRequest == StatusRequest.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.students.isEmpty) {
              return const Center(child: Text("لا يوجد طلاب"));
            }
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 12,
                color: AppColors.primary,
                endIndent: 50,
                indent: 50,
              ),
              padding: const EdgeInsets.all(12),
              itemCount: controller.students.length,
              itemBuilder: (context, index) {
                final student = controller.students[index];
                
                // استخراج السنة والفئة من الفئة
                String year = '';
                String classNum = '';
                if (student.category != null) {
                  final categoryStr = student.category!.category ?? '';
                  if (categoryStr.isNotEmpty) {
                    final parts = categoryStr.split('.');
                    year = parts.isNotEmpty ? parts[0] : '';
                    classNum = parts.length > 1 ? parts[1] : '';
                  }
                }
                
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      backgroundImage: (student.profilePhoto != null &&
                              student.profilePhoto!.url != null &&
                              student.profilePhoto!.url!.isNotEmpty)
                          ? NetworkImage("${student.profilePhoto!.url!}")
                          : null,
                      child: (student.profilePhoto == null ||
                              student.profilePhoto!.url == null ||
                              student.profilePhoto!.url!.isEmpty)
                          ? Text(
                              student.firstName?.isNotEmpty == true
                                  ? student.firstName![0].toUpperCase()
                                  : "?",
                              style: const TextStyle(color: AppColors.white),
                            )
                          : null,
                    ),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${student.firstName ?? ''} ${student.fatherName ?? ''} ${student.lastName ?? ''}"
                              .trim(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (student.isVerified == true)
                           Padding(
                            padding: EdgeInsets.only(left: 4.0),
                            child: Icon(Icons.verified, color: AppColors.primary, size: 16),
                          ),
                      ],
                    ),
                    trailing: classNum.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "السنة: $year",
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                "الفئة: $classNum",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          )
                        : null,
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                            "الرقم الجامعي: ${student.universityNumber ?? 'غير متوفر'}"),
                        if (student.bio != null && student.bio!.isNotEmpty)
                          Text("نبذة: ${student.bio}"),
                        // عرض السنة والفئة منفصلين
                        
                      ],
                    ),
                    isThreeLine: true,
                  ),
                  
                );
              },
            );
          },
        ),
      ),
    );
  }
}