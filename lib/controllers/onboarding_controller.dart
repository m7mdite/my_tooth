// controllers/onboarding_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/app_route.dart';

class OnboardingController extends GetxController {
  late PageController pageController;
  RxInt currentPage = 0.obs;

  @override
  void onInit() {
    pageController = PageController(viewportFraction: 0.9);
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void goToPage(int index) {
    currentPage.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  void nextPage() {
    if (currentPage.value < 3) {
      goToPage(currentPage.value + 1);
    } else {
      Get.offAllNamed(AppRroute.auth);
    }
  }

  void skip() {
    Get.offAllNamed(AppRroute.auth);
  }
}