import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/api_link.dart';

import '../../../controllers/admin_controller/admin_users_controller.dart';
import '../../../utils/app_constants/status_request.dart';

class ViewPatientesPage extends StatelessWidget {
  final AdminUsersControllerImpl controller = Get.put(AdminUsersControllerImpl());
   ViewPatientesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("عرض المرضى")),
      body: GetBuilder<AdminUsersControllerImpl>(
        init: AdminUsersControllerImpl(),
        initState: (_) => Get.find<AdminUsersControllerImpl>().getAllPatientes(),
        builder: (controller) {
          if (controller.statusRequest == StatusRequest.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (controller.patients.isEmpty) {
            return Center(child: Text("لا يوجد مرضى"));
          }
          return ListView.builder(
            itemCount: controller.patients.length,
            itemBuilder: (context, index) {
              var patient  = controller.patients[index];
              return Container(
                margin: EdgeInsets.all(10),
                
                child: ListTile(
                  iconColor: Colors.blue,
                  horizontalTitleGap: 10,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  trailing: Icon(Icons.person),
                  leading:  patient.profilePhoto != null && patient.profilePhoto!.url != null
                    ? Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage("http://localhost:5000/${patient.profilePhoto!.url!}"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                      // child: Image.network("http://localhost:5000/${patient.profilePhoto!.url!}", fit: BoxFit.cover))
                    : Icon(Icons.person),
                  textColor: Colors.blue,
                  title: Text(
                    "${patient.firstName ?? ''} ${patient.lastName ?? ''}".trim().isEmpty
                      ? "No Name"
                      : "${patient.firstName ?? ''} ${patient.lastName ?? ''}"),
                  subtitle: Row(
                    children: [
                      Text("Email: ${patient.isVerified ?? 'No Email'}"),
                      SizedBox(width: 10),
                      Text("Bio: ${patient.bio ?? 'No Bio'}"),
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
