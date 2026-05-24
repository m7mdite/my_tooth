// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:gr_flutter/services/shared/auth_service.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class WebSocketService extends GetxService {
//   late IO.Socket socket;
//   final RxString status = 'غير متصل'.obs;
//   final RxBool isConnected = false.obs;
//   AuthService authService =AuthService();
//   // ✅ إضافة البلجن
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   String? _userId;
//   String? _token;

//   // ✅ 1. تهيئة الإشعارات المحلية + طلب الإذن
//   Future<void> initNotifications() async {
//     // طلب إذن الإشعارات (Android 13+)
//     await Permission.notification.isDenied.then((value) {
//       if (value) Permission.notification.request();
//     });

//     // إعدادات Android
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     // إعدادات iOS (اختياري)
//     const DarwinInitializationSettings iosSettings =
//         DarwinInitializationSettings();
//         const DarwinInitializationSettings macosSettings =
//           DarwinInitializationSettings();
//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//       // macOS: macosSettings,
//       // windows: WindowsInitializationSettings(appName: "gr_flutter", appUserModelId: "com.yourcompany.gr_flutter", guid: '{12345678-1234-1234-1234-123456789012}')
//     );
//     const WindowsInitializationSettings windowsSettings =
//         WindowsInitializationSettings(
//       appName: 'gr_flutter',  appUserModelId: 'com.yourcompany.gr_flutter', guid: '{12345678-1234-1234-1234-123456789012}',
//     );
//     // ✅ إضافة إعدادات Windows
//       // const WindowsInitializationSettings windowsSettings =
//       //     WindowsInitializationSettings(
//       //   appName: 'تطبيق العلاج',
//       // );

//     // تهيئة البلجن
//     await flutterLocalNotificationsPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (details) async {
//         // ✅ عند الضغط على الإشعار والتطبيق مفتوح
//         debugPrint('🔔 Notification tapped: ${details.payload}');
//         // TODO: التنقل للصفحة المناسبة بناءً على الـ payload
//       },
//     );

//     // إنشاء القناة (Android)
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'الإشعارات الهامة', // name
//       description: 'هذه القناة تستقبل إشعارات قبول العلاج والمواعيد',
//       importance: Importance.high,
//       playSound: true,
//     );

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     debugPrint('✅ Notification plugin initialized');
//   }

//   // ✅ 2. دالة مساعدة لعرض الإشعار في التريفة
//   Future<void> _showSystemNotification({
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       'high_importance_channel',
//       'الإشعارات الهامة',
//       channelDescription: 'هذه القناة تستقبل إشعارات قبول العلاج والمواعيد',
//       importance: Importance.high,
//       priority: Priority.high,
//       playSound: true,
//       showWhen: true,
//     );

//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await flutterLocalNotificationsPlugin.show(
//       DateTime.now().millisecondsSinceEpoch.remainder(100000), // id فريد
//       title,
//       body,
//       notificationDetails,
//       payload: payload,
//     );
//   }

//   // ✅ 3. الاتصال بالسيرفر (معدل)
//   Future<void> connect(String userId) async {
//     _userId = userId;
//     // _token = token;

//     // تهيئة الإشعارات قبل أي شيء
//     await initNotifications();

//     try {
//       socket = IO.io('http://localhost:5000', <String, dynamic>{
//         'transports': ['websocket'],
//         'autoConnect': true,
//         'extraHeaders': {
//           'userId': userId,
//           // 'token': token,
//         },
//       });

//       socket.on('connect', (_) {
//         Get.snackbar("ues", "connect");
//         debugPrint('✅ Socket connected');
//         isConnected.value = true;
//         status.value = 'متصل';
//         socket.emit('registerPatient', userId);
//       });

//       // ✅ هنا التحويل من AlertDialog إلى System Notification
//       socket.on('requestAccepted', (data) async {
//         debugPrint('📩 requestAccepted: $data');

//         final message = data['message'] ?? 'تم قبول طلب العلاج الخاص بك';
//         final date = data['date'] ?? 'غير محدد';
//         final hour = data['hour'] ?? 'غير محدد';
//         final location = data['location'] ?? 'غير محدد';
//         final doctorName = data['doctorName'] ?? 'الطبيب';

//         // ✅ عرض الإشعار في تريفة الجهاز
//         await _showSystemNotification(
//           title: '✅ تم قبول طلب العلاج',
//           // body: 'الدكتور: $doctorName - $date $hour',
//           body: message,
//           payload: jsonEncode({
//             'type': 'requestAccepted',
//             'date': date,
//             'hour': hour,
//             'location': location,
//             'doctorId': data['doctorId'],
//           }),
//         );

//         // حفظ في التخزين المحلي
//         _saveToLocalStorage(data);
//       });
//       socket.on('VerifyAccepted', (data) async {
//         debugPrint('📩 VerifyAccepted: $data');

//         final message = data['message'] ?? "تم توثيق حسابك";
//         // final date = data['date'] ?? 'غير محدد';
//         // final hour = data['hour'] ?? 'غير محدد';
//         // final location = data['location'] ?? 'غير محدد';
//         // final doctorName = data['doctorName'] ?? 'الطبيب';

//         // ✅ عرض الإشعار في تريفة الجهاز
//         await _showSystemNotification(
//           title: "تم توثيق حسابك",
//           // body: 'الدكتور: $doctorName - $date $hour',
//           body: message,
//           payload: jsonEncode({
//             'type': 'VerifyAccepted',
//             // 'date': date,
//             // 'hour': hour,
//             // 'location': location,
//             // 'doctorId': data['doctorId'],
//           }),
//         );

//         // حفظ في التخزين المحلي
//         _saveToLocalStorage(data);
//       });

//       socket.on('disconnect', (_) {
//         debugPrint('❌ Disconnected');
//         isConnected.value = false;
//         status.value = 'غير متصل';
//         _attemptReconnect();
//       });

//       socket.connect();
//     } catch (e) {
//       debugPrint('❌ Connection error: $e');
//     }
//   }

//   void _saveToLocalStorage(Map<String, dynamic> data) {
//     final box = GetStorage();
//     final notifications = box.read<List>('notifications') ?? [];
//     notifications.add({
//       ...data,
//       'receivedAt': DateTime.now().toIso8601String(),
//     });
//     box.write('notifications', notifications);
//   }

//   void _attemptReconnect() {
//     Future.delayed(const Duration(seconds: 5), () {
//       if (!isConnected.value && _userId != null && _token != null) {
//         connect(_userId!);
//       }
//     });
//   }

//   void disconnect() {
//     socket.dispose();
//     isConnected.value = false;
//     status.value = 'غير متصل';
//   }

//   @override
//   void onClose() {
//     disconnect();
//     super.onClose();
//   }
// }