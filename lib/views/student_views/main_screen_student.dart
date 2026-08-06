import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/student_controllers/main_student_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../utils/app_constants/colors_constant.dart';
import '../widgets/bottom_navigation_bar_icon.dart';

class MainScreenStudent extends StatelessWidget {
  final MainStudentControllerImp controller =
      Get.put(MainStudentControllerImp());

  MainScreenStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: AppColors.background, // ✅
          bottomNavigationBar: GetBuilder<MainStudentControllerImp>(
            builder: (_) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryAccent,       // ✅ يتغير حسب الثيم
                      AppColors.primaryLightAccent,  // ✅
                      AppColors.surface.withOpacity(0.9), // ✅ بدل white70
                      AppColors.surface,             // ✅ بدل white
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: controller.bottomNavItems
                      .asMap()
                      .entries
                      .map((entry) {
                    final int index = entry.key;
                    final Map<String, dynamic> item = entry.value;
                    return BottomNavigationBarIcon(
                      text: item["title"],
                      icon: item["icon"],
                      selected: controller.selectedPage == index,
                      onPressed: () => controller.toPage(index),
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
                onPageChanged: controller.onPageChanged,
                itemCount: controller.listPage.length,
                itemBuilder: (context, index) {
                  return controller.listPage[index]["page"];
                },
              );
            },
          ),
        );
      },
    );
  }
}