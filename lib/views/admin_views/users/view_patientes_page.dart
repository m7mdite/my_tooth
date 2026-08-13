import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controllers/admin_users_controller.dart';
import '../../../utils/app_constants/colors_constant.dart';
import '../../../utils/app_constants/status_request.dart';
import '../../widgets/custom_app_bar.dart';

class ViewPatientesPage extends StatelessWidget {
  final AdminUsersControllerImpl controller = Get.find<AdminUsersControllerImpl>();

  ViewPatientesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "المرضى",
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.getAllPatientes(),
        child: GetBuilder<AdminUsersControllerImpl>(
          builder: (controller) {
            if (controller.statusRequest == StatusRequest.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.patients.isEmpty) {
              return const Center(child: Text("لا يوجد مرضى"));
            }
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 12,
                color: AppColors.primary,
                endIndent: 50,
                indent: 50,
              ),
              padding: const EdgeInsets.all(12),
              itemCount: controller.patients.length,
              itemBuilder: (context, index) {
                final patient = controller.patients[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      backgroundImage: (patient.profilePhoto != null &&
                              patient.profilePhoto!.url != null &&
                              patient.profilePhoto!.url!.isNotEmpty)
                          ? NetworkImage(patient.profilePhoto!.url!)
                          : null,
                      child: (patient.profilePhoto == null ||
                              patient.profilePhoto!.url == null ||
                              patient.profilePhoto!.url!.isEmpty)
                          ? Text(
                              patient.firstName?.isNotEmpty == true
                                  ? patient.firstName![0].toUpperCase()
                                  : "?",
                              style: const TextStyle(color: AppColors.white),
                            )
                          : null,
                    ),
                    title: Text(
                      "${patient.firstName ?? ''} ${patient.fatherName ?? ''} ${patient.lastName ?? ''}"
                          .trim(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        if (patient.phoneNumber != null && patient.phoneNumber!.isNotEmpty)
                          Text("رقم الهاتف: ${patient.phoneNumber}"),
                        if (patient.gender != null && patient.gender!.isNotEmpty)
                          Text("الجنس: ${patient.gender == 'male' ? 'ذكر' : 'أنثى'}"),
                        if (patient.countCasesFinishds != null)
                          Text("عدد الحالات المنتهية: ${patient.countCasesFinishds}"),
                        if (patient.countCasesInProcess != null)
                          Text("عدد الحالات قيد التنفيذ: ${patient.countCasesInProcess}"),
                        if (patient.email != null && patient.email!.isNotEmpty)
                          Text("البريد الإلكتروني: ${patient.email}"),
                        if (patient.bio != null && patient.bio!.isNotEmpty)
                          Text("نبذة: ${patient.bio}"),
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