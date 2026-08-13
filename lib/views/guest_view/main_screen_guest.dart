import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/guest_controllers/main_guest_controller.dart';
import '../../utils/app_constants/colors_constant.dart';
import '../widgets/bottom_navigation_bar_icon.dart';
import '../widgets/dialog/submit_dialog.dart';

class MainScreenGuest extends StatelessWidget {
  final MainGuestControllerImp controller = Get.put(  MainGuestControllerImp());
  MainScreenGuest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GetBuilder(
        init: controller,
        builder: (_) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryAccent,
                  AppColors.primaryLightAccent,
                  AppColors.white54,
                  AppColors.white,


                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: controller.bottomNavItems.asMap().entries.map((entry) {
                // int index = entry.key;
                Map<String, dynamic> item = entry.value;
                
                return BottomNavigationBarIcon(
                  text: item["title"],
                  icon: item["icon"],
                  selected: entry.key==0,
                  onPressed: () {
                  if(entry.key!=0){  Get.dialog(SubmitDialog(
                      title: "تنبيه",
                      question: "هذه الميزة متاحة فقط للمستخدمين المسجلين.",
                      agreeBottontitle: "تسجيل الدخول",
                      onTapSubmit: () {
                        Get.back(); // Close the dialog
                      },
                    ));
                  }}
                );
              }).toList(),
            ),
          );
        },
      ),
      body: GetBuilder<MainGuestControllerImp>(
        builder: (_) {
          return PageView.builder(
            // controller: controller.pageController,
            // onPageChanged: (value) {
              // controller.onPageChanged(value);
            // },
            itemCount: controller.listPage.length,
            itemBuilder: (context,index){
            return controller.listPage[index]["page"];
          },);
        },
      ),
    );
  }
}
