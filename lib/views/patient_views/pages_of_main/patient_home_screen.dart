import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/patient_controller/home_patient_controller.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';

import '../../../controllers/public_controllers/unified_setting_controller.dart';
import '../../public_views/conversations_screen.dart';
import '../../public_views/notifications_view.dart';
import '../../public_views/settings/unified_profile_screen.dart';
import '../../widgets/container_images_home_inbording.dart';
import '../../widgets/custom_icon_app_bar.dart';
import '../../widgets/custom_photo_app_bar.dart';

class PatientHomeScreen extends StatelessWidget {
  final HomePatientControllerImp controller =
      Get.put(HomePatientControllerImp());
  final UnifiedSettingController settingController =   Get.find<UnifiedSettingController>();


  PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(
        title: "الصفحة الرئيسية",
        actions: [
          CustomIconAppBar(
              iconData: Icons.chat,
              onTap: () {
                Get.to(() => ConversationsScreen());
              }),
          CustomIconAppBar(
            iconData: Icons.notifications,
            onTap: () {
              Get.to(() => NotificationsView());
            },
            reverseColors: true,
          ),
        ],
        automaticallyImplyLeading: false,
        leading: Obx(() {
          final pic = settingController.profilePicture.value;
          return InkWell(
            onTap: () {
              // هنا يمكنك إضافة وظيفة عند الضغط على الصورة الشخصية
              Get.to(() => UnifiedProfileScreen());
            },
            child: CustomPhotoAppBar(pic: pic),
          );
        }),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    "images/images_asnan/a73e4065-5ddb-48a0-abdb-07db5334d9e9.jpeg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.linearToSrgbGamma())),
        child: ListView(
          children: [
            SizedBox(height: 20),
            GetBuilder<HomePatientControllerImp>(
              builder: (controller) {
                return SizedBox(
                  height: Get.width * 0.6,
                  width: Get.width * 0.4,
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: (value) {
                      controller.currentPage = value;
                      controller.update();
                    },
                    itemCount: controller.listImages.length,
                    itemBuilder: (context, index) {
                      return ContainerImagesHomeInbording(
                        image: controller.listImages[index],
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  
                  controller.toAiChatPage();
                },
                child: Container(
                  // height: 50,
                  // width: 150,
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue, width: 1,strokeAlign: 15),
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(100, 10),
                  bottomLeft: Radius.elliptical(10, 100),
                  topRight: Radius.elliptical(10, 100),
                  bottomRight: Radius.elliptical(100, 10),
                ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      
                      FaIcon(FontAwesomeIcons.userDoctor,color: Colors.blue,),
                      SizedBox(width: 30,),
                      Text("إسأل حكيم ...",style: TextStyle(color: Colors.blue,fontSize: 18),)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


