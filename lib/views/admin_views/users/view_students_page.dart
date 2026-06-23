import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controllers/admin_users_controller.dart';
import '../../../utils/app_constants/status_request.dart';

class ViewStudentsPage extends StatelessWidget {
  final AdminUsersControllerImpl controller = Get.find<AdminUsersControllerImpl>();

  ViewStudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الطلاب"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.getAllStudents(),
          ),
        ],
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
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: controller.students.length,
              itemBuilder: (context, index) {
                final student = controller.students[index];
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
                      backgroundImage: (student.profilePhoto != null &&
                              student.profilePhoto!.url != null &&
                              student.profilePhoto!.url!.isNotEmpty)
                          ? NetworkImage( "${student.profilePhoto!.url!}")
                          : null,
                      child: (student.profilePhoto == null ||
                              student.profilePhoto!.url == null ||
                              student.profilePhoto!.url!.isEmpty)
                          ? Text(
                              student.firstName?.isNotEmpty == true
                                  ? student.firstName![0].toUpperCase()
                                  : "?",
                              style: const TextStyle(color: Colors.white),
                            )
                          : null,
                    ),
                    title: Text(
                      "${student.firstName ?? ''} ${student.fatherName ?? ''} ${student.lastName ?? ''}".trim(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("الرقم الجامعي: ${student.universityNumber ?? 'غير متوفر'}"),
                        if (student.bio != null && student.bio!.isNotEmpty)
                          Text("نبذة: ${student.bio}"),
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