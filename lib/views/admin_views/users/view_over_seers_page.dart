import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/admin_controller/admin_users_controller.dart';
import '../../../utils/app_constants/status_request.dart';

class ViewOverSeersPage extends StatelessWidget {
  final AdminUsersControllerImpl controller = Get.put(AdminUsersControllerImpl());
   ViewOverSeersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("عرض المشرفين")),
      body: GetBuilder<AdminUsersControllerImpl>(
        init: AdminUsersControllerImpl(),
        initState: (_) => Get.find<AdminUsersControllerImpl>().getAllOverSeers(),
        builder: (controller) {
          if (controller.statusRequest == StatusRequest.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (controller.overSeers.isEmpty) {
            return Center(child: Text("لا يوجد مشرفين"));
          }
          return ListView.builder(
            itemCount: controller.overSeers.length,
            itemBuilder: (context, index) {
              var overSeer = controller.overSeers[index];
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
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  textColor: Colors.blue,
                  title: Text(
                    "${overSeer.firstName ?? ''} ${overSeer.lastName ?? ''}".trim().isEmpty
                      ? "No Name"
                      : "${overSeer.firstName ?? ''} ${overSeer.lastName ?? ''}"),
                  subtitle: Row(
                    children: [
                      Text("Email: ${overSeer.isVerified ?? 'No Email'}"),
                      SizedBox(width: 10),
                      Text("Bio: ${overSeer.bio ?? 'No Bio'}"),
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
