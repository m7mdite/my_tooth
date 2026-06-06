import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/conversations_screen.dart';
import 'package:gr_flutter/views/patient_views/pages_of_main/patient_home_screen.dart';
import 'package:gr_flutter/views/patient_views/pages_of_main/patient_setting_screen.dart';
import 'package:gr_flutter/views/patient_views/pages_of_main/patient_request_screen.dart';
import 'package:gr_flutter/views/posts/feed_screen.dart';

abstract class MainPatientController extends GetxController {}

class MainPatientControllerImp extends MainPatientController {
  PageController pageController = PageController(initialPage: 0);
    String titleAppBar = "";

  // قائمة الصفحات مع بياناتها
  final List<Map<String, dynamic>> listPage = [
    {
      "title": "الصفحة الرئيسية",
      "icon": Icons.home,
      "page": PatientHomeScreen()
    },
    {
      "title": "الطلبات",
      "icon": Icons.history_edu_sharp,
      "page": PatientRequestScreen()
    },
    {
      "title": "المنشورات",
      "icon": Icons.post_add_sharp,
      "page": FeedScreen()
    },
    {
      "title": "الملف الشخصي",
      "icon": Icons.account_circle,
      "page": PatientSettingScreen()
    },
  ];

  int selectedPage = 0;
  
  // دالة مساعدة للحصول على عناصر الـ BottomNavigationBar
  List<Map<String, dynamic>> get bottomNavItems {
    return listPage.map((item) => {
      "title": item["title"],
      "icon": item["icon"],
    }).toList();
  }
  
  toPage(int index) {
        titleAppBar = listPage[index]["title"];

    pageController.animateToPage(index,
        curve: Curves.easeIn, duration: const Duration(milliseconds: 100));
  }

  getPage() {
    return listPage[selectedPage];
  }

  onPageChanged(int index) {
    selectedPage = index;
    update();
  }
  @override
  void onClose() {
    pageController.dispose();
    
    super.onClose();
  }
}