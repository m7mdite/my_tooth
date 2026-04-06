import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/admin_controller/admin_users_controller.dart';
import '../../../utils/app_constants/status_request.dart';

class ViewStudentsPage extends StatelessWidget {
  final AdminUsersControllerImpl controller = Get.put(AdminUsersControllerImpl());
   ViewStudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("عرض الطلاب")),
      body: GetBuilder<AdminUsersControllerImpl>(
        init: AdminUsersControllerImpl(),
        initState: (_) => Get.find<AdminUsersControllerImpl>().getAllStudents(),
        builder: (controller) {
          if (controller.statusRequest == StatusRequest.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (controller.students.isEmpty) {
            return Center(child: Text("لا يوجد طلاب"));
          }
          return ListView.builder(
            itemCount: controller.students.length,
            itemBuilder: (context, index) {
              var student  = controller.students[index];
              return Container(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  iconColor: Colors.blue,
                  horizontalTitleGap: 20,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  trailing: Icon(Icons.person),
                  leading:  student.profilePhoto != null && student.profilePhoto!.url != null
                    ? Container(
                      height: 50,
                      width: 50,
                      child: Image.network(student.profilePhoto!.url!, fit: BoxFit.cover))
                    : Icon(Icons.person),
                  textColor: Colors.blue,
                  title: Text(
                    "${student.firstName ?? ''} ${student.lastName ?? ''}".trim().isEmpty
                      ? "No Name"
                      : "${student.firstName ?? ''} ${student.lastName ?? ''}"),
                  subtitle: Row(
                    children: [
                      Text("Email: ${student.universityNumber ?? 'No Email'}"),
                      SizedBox(width: 10),
                      Text("Bio: ${student.bio ?? 'No Bio'}"),
                    ],
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}
