// controllers/notifications_controllers/notification_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/public_models/notification_model.dart';
import '../../utils/app_constants/colors_constant.dart';

class NotificationController extends GetxController {
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;

  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadNotifications();
  }

  void _loadNotifications() {
    final savedNotifications = _storage.read<List>('notifications') ?? [];
    notifications.value = savedNotifications
        .map((json) => NotificationModel.fromJson(json))
        .toList()
      ..sort((a, b) => b.receivedAt.compareTo(a.receivedAt));

    _updateUnreadCount();
  }

  void addNotification(NotificationModel notification) {
    notifications.insert(0, notification);
    _saveNotifications();
    _updateUnreadCount();

    // إظهار Snackbar للإشعار الفوري
    Get.snackbar(
      notification.title,
      notification.body,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(10),
      backgroundColor: Get.theme.primaryColor.withValues(alpha: 0.9),
      colorText: AppColors.white,
    );
  }

  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !notifications[index].isRead) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      _saveNotifications();
      _updateUnreadCount();
    }
  }

  void markAllAsRead() {
    for (var i = 0; i < notifications.length; i++) {
      if (!notifications[i].isRead) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
    }
    _saveNotifications();
    _updateUnreadCount();
  }

  void deleteNotification(String notificationId) {
    notifications.removeWhere((n) => n.id == notificationId);
    _saveNotifications();
    _updateUnreadCount();
  }

  void deleteAllNotifications() {
    notifications.clear();
    _saveNotifications();
    _updateUnreadCount();
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  void _saveNotifications() {
    _storage.write(
      'notifications',
      notifications.map((n) => n.toJson()).toList(),
    );
  }

  /// التنقل حسب نوع الإشعار عند الضغط عليه.
  ///
  /// ✅ ملاحظة: هذه الدالة كان فيها باگ حقيقي بالنسخة القديمة — الـ case
  /// الخاص بـ 'updatecasetype' ما كان منتهي بـ break، وهذا أصلاً خطأ
  /// compile-time في Dart (أي case غير فاضي لازم ينتهي بـ break/return/إلخ).
  /// تم تصحيحه هون.
  void navigateToNotification(Map<String, dynamic> payload) {
    debugPrint('📍 navigateToNotification: $payload');

    switch (payload['type']) {
      case 'requestAccepted':
        Get.toNamed('/appointment-details', arguments: payload);
        break;

      case 'VerifyAccepted':
        Get.toNamed('/profile');
        break;

      case 'updatecasetype':
        Get.toNamed('/notifications');
        break;

      default:
        Get.toNamed('/notifications');
    }
  }
}
