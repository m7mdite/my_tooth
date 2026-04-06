import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/patient_controller/home_patient_controller.dart';

import '../../widgets/container_images_home_inbording.dart';

class PatientHomeScreen extends StatelessWidget {
  final HomePatientControllerImp controller = Get.put(HomePatientControllerImp());
  
  PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("images/images_asnan/a73e4065-5ddb-48a0-abdb-07db5334d9e9.jpeg"),fit: BoxFit.cover,colorFilter: ColorFilter.linearToSrgbGamma())
      ),
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
