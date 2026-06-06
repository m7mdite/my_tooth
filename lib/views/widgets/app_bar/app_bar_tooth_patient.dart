import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/patient_controller/main_patient_controller.dart';
import '../../conversations_screen.dart';

class AppBarToothPatient extends StatelessWidget
    implements PreferredSizeWidget {
  final MainPatientControllerImp controller =
      Get.find<MainPatientControllerImp>();
  final String title;
  AppBarToothPatient({
    super.key,
    this.title = "",
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () {
            Get.toNamed("/notifications");
          },
          icon: const Icon(Icons.notifications_active ,color: Colors.white,),
        ),
        IconButton(
          onPressed: () {
            Get.to(() => ConversationsScreen());
          },
          icon: const Icon(Icons.chat_outlined ,color: Colors.black,),
        ),
      ],
      elevation: 6,
      shadowColor: Colors.black,
      title: GetBuilder<MainPatientControllerImp>(builder: (_) {
        return Text(
          controller.bottomNavItems[controller.selectedPage]["title"],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
          ),
        );
      }),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue,
              // Colors.pink,
              Colors.blueAccent,
              Colors.lightBlueAccent,
              // const Color.fromARGB(136, 255, 64, 128),
              Colors.white,
              Colors.white,
              // Colors.lightBlueAccent,
              // Colors.blueAccent
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
