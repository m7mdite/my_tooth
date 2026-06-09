import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/patient_controller/main_patient_controller.dart';
import '../../widgets/bottom_navigation_bar_icon.dart';
import '../../widgets/custom_app_bar.dart';

class MainScreenPatient extends StatelessWidget {
  final MainPatientControllerImp controller = Get.put(  MainPatientControllerImp());
      // Get.find<MainPatientControllerImp>();
  MainScreenPatient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: CustomAppBar(
  title: controller.titleAppBar,
  // actions: [Icon(Icons.add_ic_call)],
  // يمكن تمرير actions إضافية هنا إذا لزم الأمر
),
      bottomNavigationBar: GetBuilder(
        init: controller,
        builder: (_) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.white54,
                  Colors.lightBlueAccent,
                  // const Color.fromARGB(147, 233, 30, 98),
                  Colors.blueAccent,
                  // Colors.pinkAccent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: controller.bottomNavItems.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> item = entry.value;
                
                return BottomNavigationBarIcon(
                  text: item["title"],
                  icon: item["icon"],
                  selected: controller.selectedPage == index,
                  onPressed: () {
                    controller.toPage(index);
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
      body: GetBuilder<MainPatientControllerImp>(
        builder: (_) {
          return PageView.builder(
            controller: controller.pageController,
            onPageChanged: (value) {
              controller.onPageChanged(value);
            },
            itemCount: controller.listPage.length,
            itemBuilder: (context,index){
            return controller.listPage[index]["page"];
          },);
        },
      ),
    );
  }
}
