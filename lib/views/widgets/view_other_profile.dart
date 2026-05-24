import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:gr_flutter/controllers/all/public_controller.dart';
import 'package:gr_flutter/controllers/conversations_controller.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';

import '../../models/profile_model.dart';
import 'report_user_dialog.dart';

class ViewOtherProfile extends StatelessWidget {
  final ProfileModel? profile;
  final ConversationsController conversationsController =
      Get.put(ConversationsController());
  ViewOtherProfile({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("ملف المستخدم"),
      //   centerTitle: true,
      // ),
      body: GetBuilder<PublicController>(builder: (_) {
        return ListView(
          children: [
            SizedBox(
              height: 5,
            ),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(5),
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blue, blurRadius: 20, spreadRadius: 1)
                  ],
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                      image: AssetImage(
                        AppConstants.defaultBackgroundImage,
                      ),
                      fit: BoxFit.cover),
                  border: Border.all(
                    color: Colors.white,
                    strokeAlign: 5,
                    width: 2,
                  ),
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${profile!.firstName} ${profile!.lastName}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Icon(Icons.verified, color: Colors.blue, size: 20),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    conversationsController.openConversation(profile!.user);
                  },
                  label: Text("مراسلة"),
                  icon: Icon(Icons.message),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    iconColor: Colors.white,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    side: BorderSide(
                        color: Colors.blueAccent, width: 2, strokeAlign: 3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(1, 10),
                        topRight: Radius.elliptical(10, 1),
                        bottomLeft: Radius.elliptical(10, 1),
                        bottomRight: Radius.elliptical(1, 10),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.snackbar("ماكو", "gsh lh [i.]");
                    Get.dialog(
                      ReportUserDialog(reportedUserId: profile!.user),
                      barrierDismissible: false,
                    );
                  },
                  label: Text("إبلاغ"),
                  icon: Icon(Icons.report),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    iconColor: Colors.white,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    side: BorderSide(
                        color: Colors.redAccent, width: 2, strokeAlign: 3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(1, 10),
                        topRight: Radius.elliptical(10, 1),
                        bottomLeft: Radius.elliptical(10, 1),
                        bottomRight: Radius.elliptical(1, 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 1,
              margin: EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // ==============================================================

            if (profile!.role == "student") ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.school, color: Colors.blueAccent, size: 16),
                      Text(
                        "السنة: ",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        profile!.category!.category!.substring(0, 1) == "4"
                            ? "الرابعة"
                            : profile!.category!.category!.substring(0, 1) ==
                                    "5"
                                ? "الخامسة"
                                : "غير محدد",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 15,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.group, color: Colors.blueAccent, size: 16),
                      Text(
                        "الفئة: ",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        " ${profile!.category!.category!.substring(2)} ",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 1,
                margin: EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
            if (profile!.role == "patient") ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.outlet_rounded,
                          color: Colors.blueAccent, size: 16),
                      Text(
                        "العمر: ",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        " ${profile!.age ?? 'غير محدد'} ",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 15,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sports_gymnastics_outlined,
                          color: Colors.blueAccent, size: 16),
                      Text(
                        "الجنس: ",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        " ${profile!.gender ?? 'غير محدد'} ",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(1, 10),
                  topRight: Radius.elliptical(10, 1),
                  bottomLeft: Radius.elliptical(10, 1),
                  bottomRight: Radius.elliptical(1, 10),
                ),
                border: Border.all(
                    color: Colors.blueAccent, width: 1, strokeAlign: 3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${profile!.bio ?? 'لا يوجد نبذة'}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text("نبذة عني",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        );
      }),
    );
  }
}
