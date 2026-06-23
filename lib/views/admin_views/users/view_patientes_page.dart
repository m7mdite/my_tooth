import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controllers/admin_users_controller.dart';
import '../../../utils/app_constants/status_request.dart';

class ViewPatientesPage extends StatelessWidget {
  final AdminUsersControllerImpl controller = Get.find<AdminUsersControllerImpl>();

  ViewPatientesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("المرضى"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.getAllPatientes(),
          ),
        ],
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
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: controller.patients.length,
              itemBuilder: (context, index) {
                final patient = controller.patients[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      backgroundImage: (patient.profilePhoto != null &&
                              patient.profilePhoto!.url != null &&
                              patient.profilePhoto!.url!.isNotEmpty)
                          ? NetworkImage("${patient.profilePhoto!.url!}")
                          : null,
                      child: (patient.profilePhoto == null ||
                              patient.profilePhoto!.url == null ||
                              patient.profilePhoto!.url!.isEmpty)
                          ? Text(
                              patient.firstName?.isNotEmpty == true
                                  ? patient.firstName![0].toUpperCase()
                                  : "?",
                              style: const TextStyle(color: Colors.white),
                            )
                          : null,
                    ),
                    title: Text(
                      "${patient.firstName ?? ''} ${patient.fatherName ?? ''} ${patient.lastName ?? ''}".trim(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        // Text("البريد: ${patient.email ?? 'غير متوفر'}"),
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