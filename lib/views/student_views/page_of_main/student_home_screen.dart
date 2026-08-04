import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/student_controllers/student_home_controller.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import 'package:gr_flutter/views/public_views/conversations_screen.dart';
import 'package:gr_flutter/views/public_views/settings/unified_profile_screen.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';

import '../../../controllers/public_controllers/unified_setting_controller.dart';
import '../../../utils/app_constants/colors_constant.dart';
import '../../public_views/notifications_view.dart';
import '../../widgets/container_images_home_inbording.dart';
import '../../widgets/custom_icon_app_bar.dart';
import '../../widgets/custom_photo_app_bar.dart';

class StudentHomeScreen extends StatelessWidget {
  final StudentHomeControllerImp controller =
      Get.put(StudentHomeControllerImp());
  final UnifiedSettingController settingController =
      Get.find<UnifiedSettingController>();

  StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
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
                  AppConstants.defaultBackgroundImage,
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.linearToSrgbGamma())),
        child: ListView(
          children: [
            GetBuilder<StudentHomeControllerImp>(
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
                    color: AppColors.white,
                    // borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.primary, width: 1, strokeAlign: 15),
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
                      FaIcon(
                        FontAwesomeIcons.userDoctor,
                        color: AppColors.primary,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        "إسأل خبير ...",
                        style: TextStyle(color: AppColors.primary, fontSize: 16),
                      )
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
