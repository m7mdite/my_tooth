import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/patient_controller/main_patient_controller.dart';
import '../../controllers/student_controller/main_student_controller.dart';
import '../widgets/app_bar/app_bar_tooth_patient.dart';
import '../widgets/app_bar/app_bar_tooth_student.dart';
import '../widgets/bottom_navigation_bar_icon.dart';

class MainScreenStudent extends StatelessWidget {
  final MainStudentControllerImp controller = Get.put(  MainStudentControllerImp());
      // Get.find<MainStudentControllerImp>();
  MainScreenStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarToothStudent(title: controller.titleAppBar,),
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
      body: GetBuilder<MainStudentControllerImp>(
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
