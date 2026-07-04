import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/admin_views/page_of_main/admin_home_screen.dart';
import 'package:gr_flutter/views/admin_views/page_of_main/admin_request_screen.dart';
import 'package:gr_flutter/views/admin_views/page_of_main/admin_users_screen.dart';
import 'package:gr_flutter/views/public_views/posts/feed_screen.dart';

import '../../views/home_dashboard_screen.dart';

abstract class MainAdminController extends GetxController {}

class MainAdminControllerImp extends MainAdminController {
  String titleAppBar = "";


  PageController pageController = PageController(initialPage: 0);
  
  // قائمة الصفحات مع بياناتها
  final List<Map<String, dynamic>> listPage = [
    {
      "title": "الصفحة الرئيسية",
      "icon": Icons.home,
      "page": HomeDashboardScreen()
    },
    {
      "title": "الطلبات",
      "icon": Icons.history_edu_sharp,
      "page": AdminRequestScreen()
    },
    {
      "title": "المنشورات",
      "icon": Icons.note_alt,
      "page": FeedScreen()
    },
    {
      "title": "المستخدمين ",
      "icon": Icons.account_circle,
      "page": AdminUsersScreen()
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