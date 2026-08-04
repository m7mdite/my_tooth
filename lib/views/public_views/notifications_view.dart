// views/notifications_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/notifications_controllers/notification_controller.dart';
import '../../models/public_models/notification_model.dart';
import '../../utils/app_constants/colors_constant.dart';
import '../widgets/custom_app_bar.dart';

class NotificationsView extends GetView<NotificationController> {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "الإشعارات",
        actions: [
          Obx(() => Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_active),
                onPressed: () {},
              ),
              if (controller.unreadCount.value > 0)
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${controller.unreadCount.value}',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          )),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'mark_all_read':
                  controller.markAllAsRead();
                  break;
                case 'delete_all':
                  _showDeleteAllDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_all_read',
                child: Text('تحديد الكل كمقروء'),
              ),
              const PopupMenuItem(
                value: 'delete_all',
                child: Text('حذف الكل'),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.notifications.isEmpty) {
          return _buildEmptyState();
        }
        
        return _buildNotificationsList();
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('الإشعارات'),
      actions: [
        Obx(() => Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_active),
              onPressed: () {},
            ),
            if (controller.unreadCount.value > 0)
              Positioned(
                right: 5,
                top: 5,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${controller.unreadCount.value}',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        )),
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'mark_all_read':
                controller.markAllAsRead();
                break;
              case 'delete_all':
                _showDeleteAllDialog();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'mark_all_read',
              child: Text('تحديد الكل كمقروء'),
            ),
            const PopupMenuItem(
              value: 'delete_all',
              child: Text('حذف الكل'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد إشعارات',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'سيتم عرض الإشعارات الجديدة هنا',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: controller.notifications.length,
      itemBuilder: (context, index) {
        final notification = controller.notifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => controller.deleteNotification(notification.id),
      background: Container(
        color: AppColors.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: AppColors.white),
      ),
      child: InkWell(
        onTap: () => controller.markAsRead(notification.id),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: notification.isRead ? AppColors.white : AppColors.primary50,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationIcon(notification.type),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontWeight: notification.isRead 
                                    ? FontWeight.normal 
                                    : FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(
                            _formatTime(notification.receivedAt),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.body,
                        style: TextStyle(
                          fontSize: 14,
                          color: notification.isRead 
                              ? AppColors.grey[700] 
                              : AppColors.grey[900],
                        ),
                      ),
                      if (!notification.isRead)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration:  BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(String type) {
    IconData iconData;
    Color color;
    
    switch (type) {
      case 'requestAccepted':
        iconData = Icons.check_circle;
        color = AppColors.success;
        break;
      case 'VerifyAccepted':
        iconData = Icons.verified;
        color = AppColors.primary;
        break;
      default:
        iconData = Icons.notifications;
        color = AppColors.warning;
    }
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(iconData, color: color, size: 24),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  void _showDeleteAllDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('حذف الكل'),
        content: const Text('هل أنت متأكد من حذف جميع الإشعارات؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteAllNotifications();
              Get.back();
            },
            child: const Text('حذف', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}