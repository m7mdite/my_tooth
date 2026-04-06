// // lib/screens/splash_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:gr_flutter/views/auth/login.dart';
// import 'package:gr_flutter/views/student_views/home_screen_student.dart';
// import '../../controllers/websocket_controller.dart';
// // import 'controllers/auth_controller.dart'; // إذا كان لديك controller للمصادقة

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final WebSocketController wsController = Get.find<WebSocketController>();
//     // final AuthController authController = Get.find<AuthController>(); // إذا كنت تستخدمه
    
//     Future.delayed(Duration(seconds: 2), () {
//       // الحصول على بيانات المستخدم
//       final userData = GetStorage().read('userData');
      
//       if (userData != null && userData['id'] != null && userData['token'] != null) {
//         // الاتصال بـ WebSocket
//         wsController.connect(userData['id'], userData['token']);
        
//         // التوجه للشاشة الرئيسية
//         Get.offAll(() => HomeScreenStudent());
//       } else {
//         // إذا لم يكن هناك مستخدم مسجل
//         Get.offAll(() => Login());
//       }
//     });
    
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(),
//             SizedBox(height: 20),
//             Text('جاري التحميل...'),
//           ],
//         ),
//       ),
//     );
//   }
// }