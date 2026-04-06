// // lib/screens/home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:gr_flutter/services/websocket_service1.dart';
// import '../../services/websocket_service.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   HomeScreenState createState() => HomeScreenState();
// }

// class HomeScreenState extends State<HomeScreen> {
//   final WebSocketService1 wsService = Get.find<WebSocketService1>();
//   final box = GetStorage();
  
//   @override
//   void initState() {
//     super.initState();
//     _initWebSocket();
//   }
  
//   void _initWebSocket() async {
//     // انتظر ثانية لضمان تحميل التطبيق
//     await Future.delayed(Duration(seconds: 1));
    
//     // جلب بيانات المستخدم من التخزين المحلي
//     final userData = box.read('userData');
    
//     if (userData != null && userData['id'] != null) {
//       // الاتصال بالسيرفر
//       await wsService.connect(
//         '69a0a5a83efd4238ec8fac1d'
//         // userData['id'].toString(),
//         // userData['token'] ?? '',
//       );
//     } else {
//       print('⚠️ No user data found for WebSocket connection');
//     }
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('عيادة الأسنان'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Obx(() => Chip(
//               label: Text(
//                 wsService.isConnected.value 
//                     ? 'الاتصال نشط ✅' 
//                     : 'الاتصال غير نشط ❌',
//               ),
//               backgroundColor: wsService.isConnected.value 
//                   ? Colors.green.withOpacity(0.2) 
//                   : Colors.red.withOpacity(0.2),
//             )),
//             SizedBox(height: 20),
//             Text('انتظر إشعارات قبول العلاج...'),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // اختبار استقبال إشعار
//                 Get.dialog(
//                   AlertDialog(
//                     title: Text('إشعار تجريبي'),
//                     content: Text('تم قبول حالتك من قبل الطالب أحمد يوسف'),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Get.back(),
//                         child: Text('موافق'),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//               child: Text('اختبار إشعار'),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Obx(() => FloatingActionButton(
//         onPressed: wsService.isConnected.value
//             ? null
//             : () => _initWebSocket(),
//         backgroundColor: wsService.isConnected.value 
//             ? Colors.green 
//             : Colors.orange,
//         child: Icon(
//           wsService.isConnected.value 
//               ? Icons.wifi 
//               : Icons.wifi_off,
//         ),
//       )),
//     );
//   }
  
//   @override
//   void dispose() {
//     super.dispose();
//   }
// }