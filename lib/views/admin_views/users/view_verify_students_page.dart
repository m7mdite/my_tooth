import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/utils/app_constants/colors_constant.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';

import '../../../controllers/admin_controllers/admin_users_controller.dart';
import '../../../utils/app_constants/status_request.dart';
import '../submit_verify_student.dart';

class ViewVerifyStudentsPage extends StatelessWidget {
  final AdminUsersControllerImpl controller = Get.put(AdminUsersControllerImpl());
   ViewVerifyStudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(actions: [],title: "طلبات التوثيق",),
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
                    iconColor: AppColors.primary,
                    horizontalTitleGap: 10,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: AppColors.primary),
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
                            image: NetworkImage("${student.document}"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                        // child: Image.network("${student.profilePhoto!.url!}", fit: BoxFit.cover))
                      : Icon(Icons.person),
                    textColor: AppColors.primary,
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
