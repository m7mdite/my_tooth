// // lib/screens/notifications_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import '../../controllers/websocket_controller.dart';

// class NotificationsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final WebSocketController wsController = Get.find<WebSocketController>();
    
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('الإشعارات'),
//         actions: [
//           if (wsController.notifications.isNotEmpty)
//             IconButton(
//               icon: Icon(Icons.delete_sweep),
//               onPressed: () {
//                 Get.defaultDialog(
//                   title: 'مسح الكل',
//                   middleText: 'هل تريد مسح جميع الإشعارات؟',
//                   textConfirm: 'نعم',
//                   textCancel: 'لا',
//                   confirmTextColor: Colors.white,
//                   onConfirm: () {
//                     wsController.clearAllNotifications();
//                     Get.back();
//                   },
//                 );
//               },
//             ),
//         ],
//       ),
//       body: Obx(() {
//         if (wsController.notifications.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.notifications_off, size: 80, color: Colors.grey),
//                 SizedBox(height: 16),
//                 Text('لا توجد إشعارات جديدة'),
//               ],
//             ),
//           );
//         }
        
//         return ListView.builder(
//           itemCount: wsController.notifications.length,
//           itemBuilder: (context, index) {
//             final notification = wsController.notifications[index];
            
//             return Card(
//               margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               color: notification['read'] == true ? Colors.grey[100] : Colors.white,
//               child: ListTile(
//                 leading: CircleAvatar(
//                   backgroundColor: Colors.green,
//                   child: Icon(Icons.medical_services, color: Colors.white),
//                 ),
//                 title: Text(
//                   notification['message'] ?? 'إشعار جديد',
//                   style: TextStyle(
//                     fontWeight: notification['read'] == true 
//                         ? FontWeight.normal 
//                         : FontWeight.bold,
//                   ),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('${notification['date']} - ${notification['hour']}'),
//                     Text(notification['location'] ?? ''),
//                   ],
//                 ),
//                 trailing: PopupMenuButton(
//                   itemBuilder: (context) => [
//                     PopupMenuItem(
//                       child: Text('تعليم كمقروء'),
//                       value: 'mark',
//                     ),
//                     PopupMenuItem(
//                       child: Text('حذف'),
//                       value: 'delete',
//                     ),
//                   ],
//                   onSelected: (value) {
//                     if (value == 'mark') {
//                       wsController.markAsRead(notification['id']);
//                     } else if (value == 'delete') {
//                       wsController.deleteNotification(notification['id']);
//                     }
//                   },
//                 ),
//                 onTap: () {
//                   // عرض تفاصيل الإشعار
//                   Get.defaultDialog(
//                     title: 'تفاصيل الموعد',
//                     content: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Text(notification['message'] ?? ''),
//                           SizedBox(height: 16),
//                           Text('📅 التاريخ: ${notification['date']}'),
//                           Text('⏰ الوقت: ${notification['hour']}'),
//                           Text('📍 المكان: ${notification['location']}'),
//                           Text('🕒 وقت الاستلام: ${notification['timestamp']}'),
//                         ],
//                       ),
//                     ),
//                     textConfirm: 'حفظ',
//                     textCancel: 'إغلاق',
//                     onConfirm: () {
//                       wsController.markAsRead(notification['id']);
//                       Get.back();
//                     },
//                   );
//                 },
//               ),
//             );
//           },
//         );
//       }),
//       floatingActionButton: Obx(() => FloatingActionButton(
//         child: Icon(
//           wsController.isConnected 
//               ? Icons.wifi 
//               : Icons.wifi_off,
//         ),
//         onPressed: () {
//           if (!wsController.isConnected) {
//             // إعادة الاتصال
//             final userData = GetStorage().read('userData');
//             if (userData != null) {
//               wsController.connect(userData['id'], userData['token']);
//             }
//           }
//         },
//       )),
//     );
//   }
// }