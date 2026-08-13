import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../views/public_views/home_dashboard_screen.dart';
import '../../views/public_views/posts/feed_screen.dart';
import '../../views/public_views/settings/unified_setting_screen.dart';
import '../../views/student_views/student_requests_screen.dart';

abstract class MainStudentController extends GetxController {}

class MainStudentControllerImp extends MainStudentController {
  String titleAppBar = "";

void refreshData() {
  // يمكنك تنفيذ منطق التحديث العام (مثل تحديث كل الصفحات الفرعية)
  Get.snackbar('تحديث', 'تم تحديث البيانات', snackPosition: SnackPosition.BOTTOM);
}
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
      "page": StudentRequestsScreen()
    },
    {
      "title": "المنشورات",
      "icon": Icons.post_add_sharp,
      "page": FeedScreen()
    },
    {
      "title": "الملف الشخصي",
      "icon": Icons.account_circle,
      "page": UnifiedSettingScreen()
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