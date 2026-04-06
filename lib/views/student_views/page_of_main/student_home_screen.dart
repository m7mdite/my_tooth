import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/student_controller/student_home_controller.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';

import '../../widgets/container_images_home_inbording.dart';

class StudentHomeScreen extends StatelessWidget {
  final StudentHomeControllerImp controller = Get.put(StudentHomeControllerImp());

   StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    return ContainerImagesHomeInbording(image: controller.listImages[index],);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
