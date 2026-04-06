import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/student_views/page_of_main/student_home_screen.dart';

import '../../views/student_views/page_of_main/student_ads_screen.dart';
import '../../views/student_views/page_of_main/student_profile_screen.dart';
import '../../views/student_views/page_of_main/student_requests_screen.dart';

abstract class MainStudentController extends GetxController {}

class MainStudentControllerImp extends MainStudentController {
  String titleAppBar = "";


  PageController pageController = PageController(initialPage: 0);
  
  // قائمة الصفحات مع بياناتها
  final List<Map<String, dynamic>> listPage = [
    {
      "title": "الصفحة الرئيسية",
      "icon": Icons.home,
      "page": StudentHomeScreen()
    },
    {
      "title": "الطلبات",
      "icon": Icons.history_edu_sharp,
      "page": StudentRequestsScreen()
    },
    {
      "title": "الاعلانات",
      "icon": Icons.note_alt,
      "page": StudentAdsScreen()
    },
    {
      "title": "الملف الشخصي",
      "icon": Icons.account_circle,
      "page": StudentProfileScreen()
    },
  ];

  // var titleAppBar = "".obs;
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
}