import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/services/functions/handling_data.dart';
import 'package:gr_flutter/utils/app_constants/status_request.dart';

import '../models/dashboard_model.dart';
import '../services/remote/dashboard_remote.dart';


class HomeDashboardController extends GetxController {
  final DashboardRemote remote = DashboardRemote(Get.find());
  Rx<DashboardModel?> dashboard = Rx<DashboardModel?>(null);
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;
  RxBool isLoading = false.obs;

  RxInt currentAdvIndex = 0.obs;
  late PageController advPageController;
  Timer? _advAutoScrollTimer;

  @override
  void onInit() {
    super.onInit();
    advPageController = PageController(viewportFraction: 0.85);
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    isLoading.value = true;
    statusRequest.value = StatusRequest.loading;
    final response = await remote.getDashboard();
    statusRequest.value = handlingData(response);
    if (statusRequest.value == StatusRequest.success) {
      dashboard.value = DashboardModel.fromJson(response['data']);
      _startAdvAutoScroll();
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل تحميل البيانات');
    }
    isLoading.value = false;
  }

  void _startAdvAutoScroll() {
    _advAutoScrollTimer?.cancel();
    final advs = dashboard.value?.adv?.data ?? [];
    if (advs.isEmpty) return;

    _advAutoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (advPageController.hasClients) {
        final next = (currentAdvIndex.value + 1) % advs.length;
        advPageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        currentAdvIndex.value = next;
      }
    });
  }

  void onAdvPageChanged(int index) {
    currentAdvIndex.value = index;
  }

  @override
  void onClose() {
    _advAutoScrollTimer?.cancel();
    advPageController.dispose();
    super.onClose();
  }
}