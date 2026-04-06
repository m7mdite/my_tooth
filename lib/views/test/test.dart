// // مثال للاستخدام في صفحة
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../services/websocket_service.dart';

// class PatientPage extends StatelessWidget {
//   final WebSocketService webSocketService = Get.find<WebSocketService>();

//    PatientPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('واجهة المريض - Socket.IO')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Obx(() => Text('الحالة: ${webSocketService.status.value}')),
//             SizedBox(height: 20),
//             Obx(() => Text('آخر رسالة: ${webSocketService.status.value}')),
//             SizedBox(height: 20),
//             Obx(() => Text('متصل: ${webSocketService.isConnected.value}')),
//           ],
//         ),
//       ),
//     );
//   }
// }