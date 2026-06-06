import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/conversations_screen.dart';

import '../../views/overseer_views/page_of_main/overseer_home_screen.dart';
import '../../views/overseer_views/page_of_main/overseer_setting_screen.dart';
import '../../views/overseer_views/page_of_main/overseer_request_screen.dart';
import '../../views/posts/feed_screen.dart';

abstract class MainOverseerController extends GetxController {}

class MainOverseerControllerImp extends MainOverseerController {
  @override
  void onInit() {
    super.onInit();
  }
  PageController pageController = PageController(initialPage: 0);
    String titleAppBar = "";

  // قائمة الصفحات مع بياناتها
  final List<Map<String, dynamic>> listPage = [
    {
      "title": "الصفحة الرئيسية",
      "icon": Icons.home,
      "page": OverseerHomeScreen()
    },
    {
      "title": "الطلبات",
      "icon": Icons.history_edu_sharp,
      "page": OverseerRequestScreen()
    },
    {
      "title": "المنشورات",
      "icon": Icons.post_add_sharp,
      "page": FeedScreen()
    },
    {
      "title": "الملف الشخصي",
      "icon": Icons.account_circle,
      "page": OverseerSettingScreen()
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
}
