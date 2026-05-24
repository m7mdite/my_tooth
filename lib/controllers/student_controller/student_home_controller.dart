import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class StudentHomeController extends GetxController {
  toAiChatPage();
}

class StudentHomeControllerImp extends StudentHomeController {

  List<String> listImages = [
    "A Dental Assistant is Working on a Dental Implant Model.jpeg",
    "44b285f8-cd06-45ae-a262-9ae11f6e6d55.jpeg",
    "aa3834e3-b727-425b-8556-6025c312cf46.jpeg"
  ];
  var currentPage = 0;
  late PageController pageController;
  Timer? _autoScrollTimer;
  @override
  void onInit() {
    // تهيئة الـ PageControllers مرة واحدة فقط
    pageController = PageController(viewportFraction: 0.8);

    _startAutoScroll();
    super.onInit();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (!pageController.hasClients) {
        return; // التأكد من أن الـ controller مرتبط
      }
      if (currentPage < 3) {
        // 0-3 لأن الفهرس يبدأ من 0
        currentPage++;
      } else {
        currentPage = 0;
      }
      pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 1800),
        curve: Curves.easeInOut,
      );
      update();
    });
  }

  @override
  void onClose() {
    _autoScrollTimer?.cancel();
    pageController.dispose();
    super.onClose();
  }
   @override
  toAiChatPage() {
    Get.toNamed("/aiChat", arguments: {
      "role": "student"
    });
  }
}
