import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/admin_controller/admin_users_controller.dart';
import '../../../utils/app_constants/status_request.dart';
import '../submit_verify_student.dart';

class ViewVerifyStudentsPage extends StatelessWidget {
  final AdminUsersControllerImpl controller = Get.put(AdminUsersControllerImpl());
   ViewVerifyStudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("عرض الطلاب المحققين")),
      body: GetBuilder<AdminUsersControllerImpl>(
        init: AdminUsersControllerImpl(),
        initState: (_) => Get.find<AdminUsersControllerImpl>().getAllVerifyStudents(),
        builder: (controller) {
          if (controller.statusRequest == StatusRequest.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (controller.verifyStudents.isEmpty) {
            return Center(child: Text("لا يوجد طلاب للتوثيق"));
          }
          return ListView.builder(
            itemCount: controller.verifyStudents.length,
            itemBuilder: (context, index) {
              var student = controller.verifyStudents[index];
              return InkWell(
                onTap: () {
                  Get.dialog(Center(child: SubmitVerifyStudent(studentModel: student,)));
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  
                  child: ListTile(
                    iconColor: Colors.blue,
                    horizontalTitleGap: 10,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    trailing: Icon(Icons.person),
                    leading:  student.document != null 
                      ? Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage("http://localhost:5000/${student.document}"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                        // child: Image.network("http://localhost:5000/${student.profilePhoto!.url!}", fit: BoxFit.cover))
                      : Icon(Icons.person),
                    textColor: Colors.blue,
                    title: Text(
                      "${student.studentProfile?.firstName ?? ''} ${student.studentProfile?.lastName ?? ''}".trim().isEmpty
                        ? "No Name"
                        : "${student.studentProfile?.firstName ?? ''} ${student.studentProfile?.fatherName ?? ''} ${student.studentProfile?.lastName ?? ''}"),
                    subtitle: Row(
                      children: [
                        Text("Email: ${student.studentProfile?.universityNumber ?? 'No Email'}"),
                        
                      ],
                    ),
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
