import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/student_controller/student_profile_controller.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';

import '../../widgets/default_container_profile.dart';

class StudentProfileScreen extends StatelessWidget {
  final StudentProfileControllerImp controller =
      Get.put(StudentProfileControllerImp());
  StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              AppConstants.defaultBackgroundImage,
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.linearToSrgbGamma()),
      ),
      child: ListView(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              padding: EdgeInsets.all(5),
              height: Get.width * 0.5,
              width: Get.width * 0.5,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.blue, blurRadius: 20, spreadRadius: 1)
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.authService.getFullName() ,
                style: TextStyle(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              Icon(
                Icons.star_half_rounded,
                color: Colors.blue,
              ),
            ],
          ),
          SizedBox(height: 30,),
          Center(
            child: DefaultContainerProfile(
              color: Colors.blue,
              title: "الملف الشخصي",
              icon: Icons.person_2_sharp,
              onTap: () {
                controller.toProfileInfo();
              },
            ),
          ),
          SizedBox(height: 30,),

          Center(
            child: DefaultContainerProfile(
              onTap: () {
                controller.toVerifypage();
              },
              color: Colors.blue,
              title: " طلب التوثيق ",
              icon: Icons.real_estate_agent_outlined,
            ),
          ),
          SizedBox(height: 30,),
          Center(
            child: DefaultContainerProfile(
              color: Colors.blue,
              title: " تغيير اللغة  ",
              icon: Icons.language_rounded,
            ),
          ),
          SizedBox(height: 30,),
          Center(
            child: DefaultContainerProfile(
              color: Colors.blue,
              title: " سياسة الخصوصية ",
              icon: Icons.privacy_tip_outlined,
            ),
          ),
          SizedBox(height: 30,),

          Center(
            child: DefaultContainerProfile(
              
              color: Colors.blue,
              title: " مراسلة الدعم ",
              icon: Icons.support_agent_outlined,
            ),
          ),
          SizedBox(height: 30,),

          Center(
            child: DefaultContainerProfile(
              onTap: () {
                controller.confirmLogOut();
              },
              color: Colors.blue,
              title: " تسجيل الخروج ",
              icon: Icons.logout_outlined,
            ),
          ),
          SizedBox(height: 30,),

          Container(
            
          ),
        ],
      ),
    );
  }
}
