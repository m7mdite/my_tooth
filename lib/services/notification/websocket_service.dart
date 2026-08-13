// services/notification/websocket_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../controllers/conversations_controllers/chat_controller.dart';
import '../../controllers/conversations_controllers/conversations_controller.dart';
import '../../controllers/notifications_controllers/notification_controller.dart';
import '../../models/public_models/notification_model.dart';
import 'websocket_events.dart';

/// عنوان سيرفر الـ Socket.IO.
const String _kSocketBaseUrl = 'http://localhost:5000';

class WebSocketService extends GetxService {
  static WebSocketService get to => Get.find();
  int _initAttempts = 0;
  bool _isLoggedOut = false; 


  // late IO.Socket _socket;
io.Socket? _socket;
  final RxString connectionStatus = 'غير متصل'.obs;
  final RxBool isConnected = false.obs;

  String? _userId;

  final FlutterLocalNotificationsPlugin _notificationPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationController? _notificationController;

  int _notificationCounter = 0;

  @override
  void onInit() {
    super.onInit();
    _initController();
  }

  // ---------------------------------------------------------------------
  // ربط NotificationController
  // (قد يُسجَّل بعد هذا الـ service حسب ترتيب Get.put في main.dart،
  // فبنعيد المحاولة لحد ما يصير جاهز).
  // ---------------------------------------------------------------------
  // void _initController() {
  //   if (Get.isRegistered<NotificationController>()) {
  //     _notificationController = Get.find<NotificationController>();
  //     debugPrint('✅ NotificationController جاهز');
  //   } else {
  //     debugPrint('⚠️ NotificationController غير مسجل بعد، إعادة محاولة...');
  //     Future.delayed(const Duration(milliseconds: 500), _initController);
  //   }
  // }
  void _initController() {
  if (Get.isRegistered<NotificationController>()) {
    _notificationController = Get.find<NotificationController>();
    debugPrint('✅ NotificationController جاهز');
  } else if (_initAttempts < 10) { // ✅ حد أقصى
    _initAttempts++;
    Future.delayed(const Duration(milliseconds: 500), _initController);
  } else {
    debugPrint('❌ فشل إيجاد NotificationController بعد 10 محاولات');
  }
}

  Future<bool> _ensureController() async {
    int attempts = 0;
    while (_notificationController == null && attempts < 5) {
      if (Get.isRegistered<NotificationController>()) {
        _notificationController = Get.find<NotificationController>();
        break;
      }
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }
    return _notificationController != null;
  }

  int _getNextNotificationId() {
    _notificationCounter++;
    if (_notificationCounter >= 2147483647) {
      _notificationCounter = 1;
    }
    return _notificationCounter;
  }

  // ---------------------------------------------------------------------
  // إعداد الإشعارات المحلية (permission + plugin + channel)
  // ---------------------------------------------------------------------
  Future<void> initializeNotifications() async {
    await _requestNotificationPermission();
    await _initializeNotificationPlugin();
    await _createNotificationChannel();
  }

  Future<void> _requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> _initializeNotificationPlugin() async {
    if (Platform.isWindows) {
      debugPrint('⚠️ الإشعارات غير مدعومة على Windows، تم التخطي.');
      return;
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );
  }

  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'الإشعارات الهامة',
      description: 'إشعارات قبول العلاج والمواعيد',
      importance: Importance.high,
      playSound: true,
    );

    await _notificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _handleNotificationTap(NotificationResponse response) {
    final payloadRaw = response.payload;
    if (payloadRaw == null) return;

    try {
      final payload = jsonDecode(payloadRaw) as Map<String, dynamic>;
      _notificationController?.navigateToNotification(payload);
    } catch (e) {
      debugPrint('❌ تعذر قراءة payload الإشعار: $e');
    }
  }

  Future<void> _showSystemNotification(NotificationModel notification) async {
    if (Platform.isWindows) return;

    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'الإشعارات الهامة',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      channelShowBadge: true,
    );

    const iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    final notificationId = _getNextNotificationId();
    debugPrint('📢 عرض إشعار برقم: $notificationId');

    await _notificationPlugin.show(
      notificationId,
      notification.title,
      notification.body,
      notificationDetails,
      payload: jsonEncode(notification.payload),
    );
  }

  void _saveToLocalStorage(Map<String, dynamic> data) {
    try {
      final box = GetStorage();
      final notifications = box.read<List>('notifications') ?? [];
      notifications.add({
        ...data,
        'receivedAt': DateTime.now().toIso8601String(),
        'type': data['type'] ?? 'unknown',
      });
      box.write('notifications', notifications);
      debugPrint('✅ تم حفظ الإشعار محلياً');
    } catch (e) {
      debugPrint('❌ خطأ أثناء الحفظ المحلي: $e');
    }
  }

  // ---------------------------------------------------------------------
  // الاتصال
  // ---------------------------------------------------------------------
  // Future<void> connect(String userId) async {
  //   _isLoggedOut = false;
  //   _userId = userId;
  //   await initializeNotifications();
  //   await _ensureController();

  //   try {
  //     // ✅ ملاحظة: extraHeaders غير موثوق دائماً مع transport 'websocket' فقط
  //     // (لا تُرسَل على كل المنصات، خصوصاً الويب والموبايل). تمرير userId
  //     // عبر query أضمن ويوصل فعلياً بالـ handshake.
  //     _socket = IO.io(
  //       _kSocketBaseUrl,
  //       IO.OptionBuilder()
  //           .setTransports(['websocket'])
  //           .setQuery({'userId': userId})
  //           .disableAutoConnect()
  //           .build(),
  //     );

  //     _registerEventHandlers();
  //     _socket!.connect();
  //   } catch (e) {
  //     debugPrint('❌ خطأ بالاتصال: $e');
  //     connectionStatus.value = 'خطأ في الاتصال';
  //   }
  // }
  Future<void> connect(String userId) async {
  _isLoggedOut = false;
  _userId = userId;
  
  // ✅ إذا في socket قديم، اسكره أولاً
  if (_socket != null) {
    _socket!.disconnect();
    _socket!.dispose();
    _socket = null;
  }
  
  await initializeNotifications();
  await _ensureController();

  try {
    _socket = io.io(
      _kSocketBaseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'userId': userId})
          .disableAutoConnect()
          .build(),
    );
    _registerEventHandlers();
    _socket!.connect(); // ✅ null-safe
  } catch (e) {
    debugPrint('❌ خطأ بالاتصال: $e');
    connectionStatus.value = 'خطأ في الاتصال';
  }
}

  void _registerEventHandlers() {
    _socket!
      ..on(SocketEvents.connect, _handleConnect)
      ..on(SocketEvents.disconnect, _handleDisconnect)
      ..on(SocketEvents.error, _handleError)
      ..on(SocketEvents.notify, _handleNotify)
      ..on(SocketEvents.requestAccepted, _handleRequestAccepted)
      ..on(SocketEvents.verifyAccepted, _handleVerifyAccepted)
      ..on(SocketEvents.studentSelectedOverseer,
          _handleStudentSelectedOverseer)
      ..on(SocketEvents.updateCaseType, _handleUpdateCaseType)
      ..on(SocketEvents.sendMessage, _handleNewMessage);
  }

  void _handleConnect(dynamic _) {
    debugPrint('✅ تم الاتصال بالسوكيت');
    isConnected.value = true;
    connectionStatus.value = 'متصل';
    _socket!.emit(SocketEvents.registerPatient, _userId);
  }

  void _handleDisconnect(dynamic _) {
    debugPrint('❌ تم قطع الاتصال');
    isConnected.value = false;
    connectionStatus.value = 'غير متصل';
    _attemptReconnect();
  }

  void _handleError(dynamic error) {
    debugPrint('⚠️ خطأ بالسوكيت: $error');
    connectionStatus.value = 'خطأ في الاتصال';
  }

  // void _attemptReconnect() {
  //   Future.delayed(const Duration(seconds: 5), () {
  //     if (!isConnected.value && _userId != null) {
  //       connect(_userId!);
  //     }
  //   });
  // }
  void _attemptReconnect() {
  Future.delayed(const Duration(seconds: 5), () {
    if (!isConnected.value && _userId != null && !_isLoggedOut) { // ✅
      connect(_userId!);
    }
  });
}

  /// إشعار عام (يجي من notifyAll بالباك عبر حدث 'notify').
  /// ✅ صار يمر بنفس مسار باقي الإشعارات: إشعار نظام حقيقي (يظهر
  /// بالبرداية + صوت) + إضافة لصفحة الإشعارات، بدل Snackbar داخلي بس
  /// كان بيختفي إذا التطبيق مو مفتوح بالفورغراوند.
  Future<void> _handleNotify(dynamic data) async {
    final title = data['title'] ?? 'إشعار جديد';
  final body = data['body'] ?? 'لديك إشعار جديد';

    await _handleAndPersist(
      data: data,
      type: SocketEvents.notify,
      title:title?? '📢 إشعار جديد',
      body: body??"",
    );
  }

  // ---------------------------------------------------------------------
  // أحداث تُبنى منها NotificationModel وتُعرض كإشعار نظام + تُضاف للـ Controller
  // ---------------------------------------------------------------------
  Future<void> _handleRequestAccepted(dynamic data) async {
    debugPrint('📩 requestAccepted: $data');
    await _handleAndPersist(
      data: data,
      type: SocketEvents.requestAccepted,
      title: '✅ تم قبول طلب العلاج',
      body: (data is Map ? data['message'] : null) ??
          'تم قبول طلب العلاج الخاص بك',
      payload: {
        'date': data['date'],
        'hour': data['hour'],
        'location': data['location'],
        'doctorId': data['doctorId'],
        'doctorName': data['doctorName'],
      },
    );
  }

  Future<void> _handleVerifyAccepted(dynamic data) async {
    debugPrint('📩 VerifyAccepted: $data');
    await _handleAndPersist(
      data: data,
      type: SocketEvents.verifyAccepted,
      title: '✅ تم توثيق حسابك',
      body: (data is Map ? data['message'] : null) ??
          'تم توثيق حسابك وتحديث بياناتك بنجاح',
      payload: data is Map ? Map<String, dynamic>.from(data) : null,
    );
  }

  Future<void> _handleStudentSelectedOverseer(dynamic data) async {
    debugPrint('📩 studentSelectedOverseer: $data');
    final notificationData = (data is Map ? (data['data'] ?? data) : data);

    await _handleAndPersist(
      data: data,
      type: SocketEvents.studentSelectedOverseer,
      title: '🎓 تم اختيارك كمشرف',
      body: (data is Map ? data['message'] : null) ??
          'تم اختيارك كمشرف على حالة علاجية جديدة',
      payload: {
        'studentId': notificationData['studentId'],
        'studentName': notificationData['studentName'],
        'requestId': notificationData['requestId'],
        'caseType': notificationData['caseType'],
        'courseName': notificationData['courseName'],
        'patientName': notificationData['patientName'],
        'patientId': notificationData['patientId'],
        'date': notificationData['date'],
        'hour': notificationData['hour'],
        'location': notificationData['location'],
        'acceptedAt': notificationData['acceptedAt'],
      },
    );
  }

  Future<void> _handleUpdateCaseType(dynamic data) async {
    debugPrint('📩 updatecasetype: $data');
    await _handleAndPersist(
      data: data,
      type: SocketEvents.updateCaseType,
      title: 'تحديث نوع الحالة',
      body: (data is Map ? data['message'] : null) ?? 'تم تحديث نوع الحالة',
    );
  }

  Future<void> _handleNewMessage(dynamic data) async {
    debugPrint('📩 send_message: $data');

    try {
      final isControllerReady = await _ensureController();
      if (!isControllerReady) {
        debugPrint('❌ NotificationController غير متاح');
        return;
      }

      if (Get.isRegistered<ConversationsController>()) {
        Get.find<ConversationsController>().refreshConversations();
      }

      if (Get.isRegistered<ChatController>() && data is Map) {
        // ChatController نفسها بتقرر إذا الرسالة تخص المحادثة المفتوحة حالياً
        Get.find<ChatController>().handleIncomingMessage(data);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ خطأ في _handleNewMessage: $e');
      debugPrint('$stackTrace');
      if (data is Map<String, dynamic>) _saveToLocalStorage(data);
    }
  }

  /// دالة موحّدة تبني NotificationModel، تعرض إشعار نظام، وتضيفه
  /// للـ NotificationController — أو تحفظه محلياً كخطة بديلة عند أي فشل.
  /// هاي الدالة بتلخص المنطق المكرر اللي كان بكل handler لحاله.
  Future<void> _handleAndPersist({
    required dynamic data,
    required String type,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    try {
      final isControllerReady = await _ensureController();
      if (!isControllerReady) {
        debugPrint('❌ NotificationController غير متاح، سيتم الحفظ محلياً');
        if (data is Map<String, dynamic>) _saveToLocalStorage(data);
        return;
      }

      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        type: type,
        receivedAt: DateTime.now(),
        payload: payload,
      );

      await _showSystemNotification(notification);
      _notificationController!.addNotification(notification);
      debugPrint('✅ إشعار [$type] أُضيف للـ Controller');
    } catch (e, stackTrace) {
      debugPrint('❌ خطأ في معالجة الحدث [$type]: $e');
      debugPrint('$stackTrace');
      if (data is Map<String, dynamic>) _saveToLocalStorage(data);
    }
  }

  // ---------------------------------------------------------------------
  // void disconnect() {
  //   _socket.dispose();
  //   isConnected.value = false;
  //   connectionStatus.value = 'غير متصل';
  // }
//   void disconnect() {
//   if (isConnected.value) {  // ✅ بس disconnet إذا فعلاً متصل
//     _socket.disconnect(); // ✅ أولاً disconnect نظيف
//     _socket.dispose(); 
//   }
//   isConnected.value = false;
//   connectionStatus.value = 'غير متصل';
// }
// Future<void> disconnect() async {
//   if (isConnected.value) {
//     _socket.disconnect();
//     await Future.delayed(const Duration(milliseconds: 500)); // ✅ وقت للـ packet يوصل
//     _socket.dispose();
//   }
//   isConnected.value = false;
//   connectionStatus.value = 'غير متصل';
// }
// Future<void> disconnect() async {
//   _isLoggedOut = true;  // ✅ وقف الـ reconnect
//   _userId = null;       // ✅ امسح الـ userId
//   if (isConnected.value) {
//     _socket.disconnect();
//     await Future.delayed(const Duration(milliseconds: 500));
//     _socket.dispose();
//   }
//   isConnected.value = false;
//   connectionStatus.value = 'غير متصل';
// }
Future<void> disconnect() async {
  _isLoggedOut = true;
  _userId = null;
  if (isConnected.value && _socket != null) { // ✅ null check
    _socket!.disconnect();
    await Future.delayed(const Duration(milliseconds: 500));
    _socket!.dispose();
    _socket = null; // ✅ امسحه بعد dispose
  }
  isConnected.value = false;
  connectionStatus.value = 'غير متصل';
}
  // @override
  // void onClose() {
  //   disconnect();
  //   super.onClose();
  // }
  @override
void onClose() {
  // لا تستخدم await هون، بس نادي disconnect بدون انتظار
  _isLoggedOut = true;
  _userId = null;
  if (_socket != null) {
    _socket!.disconnect();
    _socket!.dispose();
    _socket = null;
  }
  isConnected.value = false;
  super.onClose();
}
}
































































// // services/notification/websocket_service.dart
// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// import '../../controllers/conversations_controllers/chat_controller.dart';
// import '../../controllers/conversations_controllers/conversations_controller.dart';
// import '../../controllers/notifications_controllers/notification_controller.dart';
// import '../../models/public_models/notification_model.dart';
// import 'websocket_events.dart';

// /// عنوان سيرفر الـ Socket.IO.
// /// TODO: انقلها لملف إعدادات/env منفصل (dev / staging / prod) قبل الإصدار.
// const String _kSocketBaseUrl = 'http://localhost:5000';

// /// اسم ملف الصوت المخصص بدون امتداد (لازم يطابق اسم الملف بـ
// /// android/app/src/main/res/raw/ وملف iOS المضاف لمشروع Xcode).
// const String _kDentalSoundName = 'dental_sound';

// /// ✅ channel جديد بـ id مختلف لأن أندرويد ما بيسمح بتغيير صوت channel
// /// قديم بأثر رجعي عند المستخدمين اللي عندهم التطبيق مثبت أصلاً.
// const String _kNotificationChannelId = 'dental_notification_channel';

// class WebSocketService extends GetxService {
//   static WebSocketService get to => Get.find();

//   late IO.Socket _socket;

//   final RxString connectionStatus = 'غير متصل'.obs;
//   final RxBool isConnected = false.obs;

//   String? _userId;

//   final FlutterLocalNotificationsPlugin _notificationPlugin =
//       FlutterLocalNotificationsPlugin();

//   NotificationController? _notificationController;

//   int _notificationCounter = 0;

//   @override
//   void onInit() {
//     super.onInit();
//     _initController();
//   }

//   // ---------------------------------------------------------------------
//   // ربط NotificationController
//   // (قد يُسجَّل بعد هذا الـ service حسب ترتيب Get.put في main.dart،
//   // فبنعيد المحاولة لحد ما يصير جاهز).
//   // ---------------------------------------------------------------------
//   void _initController() {
//     if (Get.isRegistered<NotificationController>()) {
//       _notificationController = Get.find<NotificationController>();
//       debugPrint('✅ NotificationController جاهز');
//     } else {
//       debugPrint('⚠️ NotificationController غير مسجل بعد، إعادة محاولة...');
//       Future.delayed(const Duration(milliseconds: 500), _initController);
//     }
//   }

//   Future<bool> _ensureController() async {
//     int attempts = 0;
//     while (_notificationController == null && attempts < 5) {
//       if (Get.isRegistered<NotificationController>()) {
//         _notificationController = Get.find<NotificationController>();
//         break;
//       }
//       await Future.delayed(const Duration(milliseconds: 100));
//       attempts++;
//     }
//     return _notificationController != null;
//   }

//   int _getNextNotificationId() {
//     _notificationCounter++;
//     if (_notificationCounter >= 2147483647) {
//       _notificationCounter = 1;
//     }
//     return _notificationCounter;
//   }

//   // ---------------------------------------------------------------------
//   // إعداد الإشعارات المحلية (permission + plugin + channel)
//   // ---------------------------------------------------------------------
//   Future<void> initializeNotifications() async {
//     await _requestNotificationPermission();
//     await _initializeNotificationPlugin();
//     await _createNotificationChannel();
//   }

//   Future<void> _requestNotificationPermission() async {
//     if (await Permission.notification.isDenied) {
//       await Permission.notification.request();
//     }
//   }

//   Future<void> _initializeNotificationPlugin() async {
//     if (Platform.isWindows) {
//       debugPrint('⚠️ الإشعارات غير مدعومة على Windows، تم التخطي.');
//       return;
//     }

//     const androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosSettings = DarwinInitializationSettings();
//     const initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );

//     await _notificationPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: _handleNotificationTap,
//     );
//   }

//   Future<void> _createNotificationChannel() async {
//     const channel = AndroidNotificationChannel(
//       _kNotificationChannelId,
//       'الإشعارات الهامة',
//       description: 'إشعارات قبول العلاج والمواعيد',
//       importance: Importance.high,
//       playSound: true,
//       sound: RawResourceAndroidNotificationSound(_kDentalSoundName),
//     );

//     await _notificationPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }

//   void _handleNotificationTap(NotificationResponse response) {
//     final payloadRaw = response.payload;
//     if (payloadRaw == null) return;

//     try {
//       final payload = jsonDecode(payloadRaw) as Map<String, dynamic>;
//       _notificationController?.navigateToNotification(payload);
//     } catch (e) {
//       debugPrint('❌ تعذر قراءة payload الإشعار: $e');
//     }
//   }

//   Future<void> _showSystemNotification(NotificationModel notification) async {
//     if (Platform.isWindows) return;

//     final androidDetails = AndroidNotificationDetails(
//       _kNotificationChannelId,
//       'الإشعارات الهامة',
//       importance: Importance.high,
//       priority: Priority.high,
//       playSound: true,
//       sound: const RawResourceAndroidNotificationSound(_kDentalSoundName),
//       channelShowBadge: true,
//     );

//     const iOSDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//       sound: '$_kDentalSoundName.caf',
//     );

//     final notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: iOSDetails,
//     );

//     final notificationId = _getNextNotificationId();
//     debugPrint('📢 عرض إشعار برقم: $notificationId');

//     await _notificationPlugin.show(
//       notificationId,
//       notification.title,
//       notification.body,
//       notificationDetails,
//       payload: jsonEncode(notification.payload),
//     );
//   }

//   void _saveToLocalStorage(Map<String, dynamic> data) {
//     try {
//       final box = GetStorage();
//       final notifications = box.read<List>('notifications') ?? [];
//       notifications.add({
//         ...data,
//         'receivedAt': DateTime.now().toIso8601String(),
//         'type': data['type'] ?? 'unknown',
//       });
//       box.write('notifications', notifications);
//       debugPrint('✅ تم حفظ الإشعار محلياً');
//     } catch (e) {
//       debugPrint('❌ خطأ أثناء الحفظ المحلي: $e');
//     }
//   }

//   // ---------------------------------------------------------------------
//   // الاتصال
//   // ---------------------------------------------------------------------
//   Future<void> connect(String userId) async {
//     _userId = userId;
//     await initializeNotifications();
//     await _ensureController();

//     try {
//       // ✅ ملاحظة: extraHeaders غير موثوق دائماً مع transport 'websocket' فقط
//       // (لا تُرسَل على كل المنصات، خصوصاً الويب والموبايل). تمرير userId
//       // عبر query أضمن ويوصل فعلياً بالـ handshake.
//       _socket = IO.io(
//         _kSocketBaseUrl,
//         IO.OptionBuilder()
//             .setTransports(['websocket'])
//             .setQuery({'userId': userId})
//             .disableAutoConnect()
//             .build(),
//       );

//       _registerEventHandlers();
//       _socket.connect();
//     } catch (e) {
//       debugPrint('❌ خطأ بالاتصال: $e');
//       connectionStatus.value = 'خطأ في الاتصال';
//     }
//   }

//   void _registerEventHandlers() {
//     _socket
//       ..on(SocketEvents.connect, _handleConnect)
//       ..on(SocketEvents.disconnect, _handleDisconnect)
//       ..on(SocketEvents.error, _handleError)
//       ..on(SocketEvents.notify, _handleNotify)
//       ..on(SocketEvents.requestAccepted, _handleRequestAccepted)
//       ..on(SocketEvents.verifyAccepted, _handleVerifyAccepted)
//       ..on(SocketEvents.studentSelectedOverseer,
//           _handleStudentSelectedOverseer)
//       ..on(SocketEvents.updateCaseType, _handleUpdateCaseType)
//       ..on(SocketEvents.sendMessage, _handleNewMessage);
//   }

//   void _handleConnect(dynamic _) {
//     debugPrint('✅ تم الاتصال بالسوكيت');
//     isConnected.value = true;
//     connectionStatus.value = 'متصل';
//     _socket.emit(SocketEvents.registerPatient, _userId);
//   }

//   void _handleDisconnect(dynamic _) {
//     debugPrint('❌ تم قطع الاتصال');
//     isConnected.value = false;
//     connectionStatus.value = 'غير متصل';
//     _attemptReconnect();
//   }

//   void _handleError(dynamic error) {
//     debugPrint('⚠️ خطأ بالسوكيت: $error');
//     connectionStatus.value = 'خطأ في الاتصال';
//   }

//   void _attemptReconnect() {
//     Future.delayed(const Duration(seconds: 5), () {
//       if (!isConnected.value && _userId != null) {
//         connect(_userId!);
//       }
//     });
//   }

//   /// إشعار عام (يجي من notifyAll بالباك عبر حدث 'notify').
//   /// ✅ صار يمر بنفس مسار باقي الإشعارات: إشعار نظام حقيقي (يظهر
//   /// بالبرداية + صوت) + إضافة لصفحة الإشعارات، بدل Snackbar داخلي بس
//   /// كان بيختفي إذا التطبيق مو مفتوح بالفورغراوند.
//   Future<void> _handleNotify(dynamic data) async {
//     debugPrint('📩 notify: $data');
//     final message = (data is Map && data['message'] != null)
//         ? data['message'].toString()
//         : 'لديك إشعار جديد';

//     await _handleAndPersist(
//       data: data,
//       type: SocketEvents.notify,
//       title: '📢 إشعار جديد',
//       body: message,
//     );
//   }

//   // ---------------------------------------------------------------------
//   // أحداث تُبنى منها NotificationModel وتُعرض كإشعار نظام + تُضاف للـ Controller
//   // ---------------------------------------------------------------------
//   Future<void> _handleRequestAccepted(dynamic data) async {
//     debugPrint('📩 requestAccepted: $data');
//     await _handleAndPersist(
//       data: data,
//       type: SocketEvents.requestAccepted,
//       title: '✅ تم قبول طلب العلاج',
//       body: (data is Map ? data['message'] : null) ??
//           'تم قبول طلب العلاج الخاص بك',
//       payload: {
//         'date': data['date'],
//         'hour': data['hour'],
//         'location': data['location'],
//         'doctorId': data['doctorId'],
//         'doctorName': data['doctorName'],
//       },
//     );
//   }

//   Future<void> _handleVerifyAccepted(dynamic data) async {
//     debugPrint('📩 VerifyAccepted: $data');
//     await _handleAndPersist(
//       data: data,
//       type: SocketEvents.verifyAccepted,
//       title: '✅ تم توثيق حسابك',
//       body: (data is Map ? data['message'] : null) ??
//           'تم توثيق حسابك وتحديث بياناتك بنجاح',
//       payload: data is Map ? Map<String, dynamic>.from(data) : null,
//     );
//   }

//   Future<void> _handleStudentSelectedOverseer(dynamic data) async {
//     debugPrint('📩 studentSelectedOverseer: $data');
//     final notificationData = (data is Map ? (data['data'] ?? data) : data);

//     await _handleAndPersist(
//       data: data,
//       type: SocketEvents.studentSelectedOverseer,
//       title: '🎓 تم اختيارك كمشرف',
//       body: (data is Map ? data['message'] : null) ??
//           'تم اختيارك كمشرف على حالة علاجية جديدة',
//       payload: {
//         'studentId': notificationData['studentId'],
//         'studentName': notificationData['studentName'],
//         'requestId': notificationData['requestId'],
//         'caseType': notificationData['caseType'],
//         'courseName': notificationData['courseName'],
//         'patientName': notificationData['patientName'],
//         'patientId': notificationData['patientId'],
//         'date': notificationData['date'],
//         'hour': notificationData['hour'],
//         'location': notificationData['location'],
//         'acceptedAt': notificationData['acceptedAt'],
//       },
//     );
//   }

//   Future<void> _handleUpdateCaseType(dynamic data) async {
//     debugPrint('📩 updatecasetype: $data');
//     await _handleAndPersist(
//       data: data,
//       type: SocketEvents.updateCaseType,
//       title: 'تحديث نوع الحالة',
//       body: (data is Map ? data['message'] : null) ?? 'تم تحديث نوع الحالة',
//     );
//   }

//   Future<void> _handleNewMessage(dynamic data) async {
//     debugPrint('📩 send_message: $data');

//     try {
//       final isControllerReady = await _ensureController();
//       if (!isControllerReady) {
//         debugPrint('❌ NotificationController غير متاح');
//         return;
//       }

//       if (Get.isRegistered<ConversationsController>()) {
//         Get.find<ConversationsController>().refreshConversations();
//       }

//       if (Get.isRegistered<ChatController>() && data is Map) {
//         // ChatController نفسها بتقرر إذا الرسالة تخص المحادثة المفتوحة حالياً
//         Get.find<ChatController>().handleIncomingMessage(data);
//       }
//     } catch (e, stackTrace) {
//       debugPrint('❌ خطأ في _handleNewMessage: $e');
//       debugPrint('$stackTrace');
//       if (data is Map<String, dynamic>) _saveToLocalStorage(data);
//     }
//   }

//   /// دالة موحّدة تبني NotificationModel، تعرض إشعار نظام، وتضيفه
//   /// للـ NotificationController — أو تحفظه محلياً كخطة بديلة عند أي فشل.
//   /// هاي الدالة بتلخص المنطق المكرر اللي كان بكل handler لحاله.
//   Future<void> _handleAndPersist({
//     required dynamic data,
//     required String type,
//     required String title,
//     required String body,
//     Map<String, dynamic>? payload,
//   }) async {
//     try {
//       final isControllerReady = await _ensureController();
//       if (!isControllerReady) {
//         debugPrint('❌ NotificationController غير متاح، سيتم الحفظ محلياً');
//         if (data is Map<String, dynamic>) _saveToLocalStorage(data);
//         return;
//       }

//       final notification = NotificationModel(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         title: title,
//         body: body,
//         type: type,
//         receivedAt: DateTime.now(),
//         payload: payload,
//       );

//       await _showSystemNotification(notification);
//       _notificationController!.addNotification(notification);
//       debugPrint('✅ إشعار [$type] أُضيف للـ Controller');
//     } catch (e, stackTrace) {
//       debugPrint('❌ خطأ في معالجة الحدث [$type]: $e');
//       debugPrint('$stackTrace');
//       if (data is Map<String, dynamic>) _saveToLocalStorage(data);
//     }
//   }

//   // ---------------------------------------------------------------------
//   void disconnect() {
//     _socket.dispose();
//     isConnected.value = false;
//     connectionStatus.value = 'غير متصل';
//   }

//   @override
//   void onClose() {
//     disconnect();
//     super.onClose();
//   }
// }
