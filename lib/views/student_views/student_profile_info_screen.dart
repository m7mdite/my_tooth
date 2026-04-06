import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/services/shared/auth_service.dart';

import '../../utils/app_constants/app_constants.dart';

class StudentProfileInfoScreen extends StatelessWidget {
  final AuthService authService = AuthService();
  StudentProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الملف الشخصي"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 30),
                padding: EdgeInsets.all(5),
                height: Get.width * 0.5,
                width: Get.width * 0.5,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blue, blurRadius: 20, spreadRadius: 1)
                  ],
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                      image: AssetImage(
                        authService.getProfilePhotoUrl() ??
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
            SizedBox(
              height: 10,
            ),
            Text(authService.getFullName() ?? "اسم غير متوفر",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center),
            Card.outlined(
              child: ListTile(
                minLeadingWidth: Get.width * 0.3,
                title: Text("الاسم الكامل"),
                subtitle: Text(
                  authService.getFullName(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
