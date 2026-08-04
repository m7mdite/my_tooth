import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/overseer_controllers/main_overseer_controller.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';

import '../../../utils/app_constants/colors_constant.dart';
import '../../widgets/bottom_navigation_bar_icon.dart';

class MainScreenOverseer extends StatelessWidget {
  // final MainOverseerControllerImp controller = Get.put(MainOverseerControllerImp());
  final controller = Get.find<MainOverseerControllerImp>();

      // Get.find<MainOverseerControllerImp>();
  MainScreenOverseer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar(title: controller.titleAppBar,),
      bottomNavigationBar: GetBuilder(
        init: controller,
        builder: (_) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.white,
                  AppColors.white54,
                  AppColors.primaryLightAccent,
                  // const Color.fromARGB(147, 233, 30, 98),
                  AppColors.primaryAccent,
                  // AppColors.pinkAccent,
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
      body: GetBuilder<MainOverseerControllerImp>(
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
