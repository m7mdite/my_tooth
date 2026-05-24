// services/websocket_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gr_flutter/controllers/chat_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../controllers/conversations_controller.dart';
import '../controllers/notification_controller.dart';
import '../models/notification_model.dart';

class WebSocketService extends GetxService {
  static WebSocketService get to => Get.find();

  late IO.Socket _socket;
  final RxString connectionStatus = 'غير متصل'.obs;
  final RxBool isConnected = false.obs;

  String? _userId;
  final FlutterLocalNotificationsPlugin _notificationPlugin =
      FlutterLocalNotificationsPlugin();

  // ✅ تغيير من late إلى nullable مع getter
  NotificationController? _notificationController;
  NotificationController get notificationController {
    _notificationController ??= Get.find<NotificationController>();
    return _notificationController!;
  }

  int _notificationCounter = 0;

  @override
  void onInit() {
    super.onInit();
    // ✅ محاولة الحصول على الـ Controller فوراً
    _initController();
  }

  void _initController() {
    try {
      if (Get.isRegistered<NotificationController>()) {
        _notificationController = Get.find<NotificationController>();
        debugPrint('✅ NotificationController initialized successfully');
      } else {
        debugPrint('⚠️ NotificationController not registered yet, will retry');
        // إعادة المحاولة بعد تأخير
        Future.delayed(const Duration(milliseconds: 500), () {
          _initController();
        });
      }
    } catch (e) {
      debugPrint('❌ Error getting NotificationController: $e');
    }
  }

  // ✅ دالة مساعدة للتأكد من وجود الـ Controller
  Future<bool> _ensureController() async {
    int attempts = 0;
    while (_notificationController == null && attempts < 5) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
      if (Get.isRegistered<NotificationController>()) {
        _notificationController = Get.find<NotificationController>();
        break;
      }
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
  // أضف هذه الدالة الجديدة في class WebSocketService1

  Future<void> _handleStudentSelectedOverseer(dynamic data) async {
    debugPrint('📩 studentSelectedOverseer: $data');

    try {
      final isControllerReady = await _ensureController();

      if (!isControllerReady) {
        debugPrint('❌ NotificationController not available');
        _saveToLocalStorage(data);
        return;
      }

      // استخراج البيانات من الإشعار
      final notificationData = data['data'] ?? data;

      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '🎓 تم اختيارك كمشرف',
        body: data['message'] ?? 'تم اختيارك كمشرف على حالة علاجية جديدة',
        type: 'studentSelectedOverseer',
        receivedAt: DateTime.now(),
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

      // عرض الإشعار في النظام
      await _showSystemNotification(notification);

      // إضافة الإشعار إلى المتحكم
      if (_notificationController != null) {
        _notificationController!.addNotification(notification);
        debugPrint('✅ Overseer notification added to controller');
      } else {
        _saveToLocalStorage(data);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error in _handleStudentSelectedOverseer: $e');
      debugPrint('Stack trace: $stackTrace');
      _saveToLocalStorage(data);
    }
  }

  Future<void> _showSystemNotification(NotificationModel notification) async {
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

    int notificationId = _getNextNotificationId();
    debugPrint('📢 Showing notification with ID: $notificationId');

    await _notificationPlugin.show(
      notificationId,
      notification.title,
      notification.body,
      notificationDetails,
      payload: jsonEncode(notification.payload),
    );
  }

  Future<void> _handleVerifyAccepted(dynamic data) async {
    debugPrint('📩 VerifyAccepted: $data');

    try {
      // ✅ التأكد من وجود الـ Controller قبل الاستخدام
      final isControllerReady = await _ensureController();

      if (!isControllerReady) {
        debugPrint(
            '❌ NotificationController not available, saving notification locally');
        // حفظ الإشعار مؤقتاً في storage
        _saveToLocalStorage(data);
        return;
      }

      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '✅ تم توثيق حسابك',
        body: data['message'] ?? 'تم توثيق حسابك وتحديث بياناتك بنجاح',
        type: 'VerifyAccepted',
        receivedAt: DateTime.now(),
        payload: data,
      );

      // عرض الإشعار في النظام
      await _showSystemNotification(notification);

      // ✅ استخدام notificationController مع التحقق
      if (_notificationController != null) {
        _notificationController!.addNotification(notification);
        debugPrint('✅ Notification added to controller');
      } else {
        debugPrint('⚠️ Controller still null, saving to local storage');
        _saveToLocalStorage(data);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error in _handleVerifyAccepted: $e');
      debugPrint('Stack trace: $stackTrace');
      // حفظ الإشعار في storage كحل بديل
      _saveToLocalStorage(data);
    }
  }

  Future<void> _handleRequestAccepted(dynamic data) async {
    debugPrint('📩 requestAccepted: $data');

    try {
      final isControllerReady = await _ensureController();

      if (!isControllerReady) {
        debugPrint('❌ NotificationController not available');
        _saveToLocalStorage(data);
        return;
      }

      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '✅ تم قبول طلب العلاج',
        body: data['message'] ?? 'تم قبول طلب العلاج الخاص بك',
        type: 'requestAccepted',
        receivedAt: DateTime.now(),
        payload: {
          'date': data['date'],
          'hour': data['hour'],
          'location': data['location'],
          'doctorId': data['doctorId'],
          'doctorName': data['doctorName'],
        },
      );

      await _showSystemNotification(notification);

      if (_notificationController != null) {
        _notificationController!.addNotification(notification);
      } else {
        _saveToLocalStorage(data);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error in _handleRequestAccepted: $e');
      debugPrint('Stack trace: $stackTrace');
      _saveToLocalStorage(data);
    }
  }

  Future<void> _handleUpdatecasetype(dynamic data) async {
    debugPrint('📩 updatecasetype: $data');

    try {
      final isControllerReady = await _ensureController();

      if (!isControllerReady) {
        debugPrint('❌ NotificationController not available');
        _saveToLocalStorage(data);
        return;
      }

      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '✅ ',
        body: data['message'] ?? ' hhhh',
        type: 'updatecasetype',
        receivedAt: DateTime.now(),
        // payload: {
        //   'date': data['date'],
        //   'hour': data['hour'],
        //   'location': data['location'],
        //   'doctorId': data['doctorId'],
        //   'doctorName': data['doctorName'],
        // },
      );

      await _showSystemNotification(notification);

      if (_notificationController != null) {
        _notificationController!.addNotification(notification);
      } else {
        _saveToLocalStorage(data);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error in _handleRequestAccepted: $e');
      debugPrint('Stack trace: $stackTrace');
      _saveToLocalStorage(data);
    }
  }

  Future<void> _handleNewMessagee(dynamic data) async {
    debugPrint('📩 updatecasetype: $data');

    try {
      final isControllerReady = await _ensureController();

      if (!isControllerReady) {
        debugPrint('❌ NotificationController not available');
        _saveToLocalStorage(data);
        return;
      }

      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '✅ ',
        body: data['message'] ?? ' hhhh',
        type: 'send_message',
        receivedAt: DateTime.now(),
        // payload: {
        //   'date': data['date'],
        //   'hour': data['hour'],
        //   'location': data['location'],
        //   'doctorId': data['doctorId'],
        //   'doctorName': data['doctorName'],
        // },
      );

      await _showSystemNotification(notification);

      if (_notificationController != null) {
        _notificationController!.addNotification(notification);
      } else {
        _saveToLocalStorage(data);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error in _handleRequestAccepted: $e');
      debugPrint('Stack trace: $stackTrace');
      _saveToLocalStorage(data);
    }
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
      debugPrint('✅ Notification saved to local storage');
    } catch (e) {
      debugPrint('❌ Error saving to local storage: $e');
    }
  }

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
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    // const windowsSettings = WindowsInitializationSettings(
    //   appName: 'gr_flutter',
    //   appUserModelId: 'com.yourcompany.gr_flutter',
    // );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      // windows: windowsSettings,
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
    if (response.payload != null) {
      final payload = jsonDecode(response.payload!);
      if (_notificationController != null) {
        _notificationController!.navigateToNotification(payload);
      }
    }
  }

  Future<void> connect(String userId) async {
    _userId = userId;
    await initializeNotifications();

    // ✅ التأكد من وجود الـ Controller قبل الاتصال
    await _ensureController();

    try {
      _socket = IO.io('http://localhost:5000', {
        'transports': ['websocket'],
        'autoConnect': true,
        'extraHeaders': {'userId': userId},
      });

      _registerEventHandlers();
      _socket.connect();
    } catch (e) {
      debugPrint('❌ Connection error: $e');
      connectionStatus.value = 'خطأ في الاتصال';
    }
  }

  Future<void> _handleNewMessage(dynamic data) async {
    debugPrint('📩 New message received: $data');
    print('📩 New message received: $data');
    try {
      final isControllerReady = await _ensureController();

      if (!isControllerReady) {
        debugPrint('❌ NotificationController not available');
        // _saveToLocalStorage(data);
        return;
      }

      // إرسال الحدث إلى جميع المستمعين
      // _newMessageStreamController.add(data);
      // تحديث قائمة المحادثات إذا لزم الأمر
      if (Get.isRegistered<ConversationsController>()) {
        // Get.snackbar("title", "$data");
        print("${data}");
        Get.find<ConversationsController>().refreshConversations();
        Get.find<ChatController>().fetchMessages(data['content']['sender']);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error in _handleRequestAccepted: $e');
      debugPrint('Stack trace: $stackTrace');
      _saveToLocalStorage(data);
    }
  }

  void _registerEventHandlers() {
    _socket.on('connect', _handleConnect);
    _socket.on('requestAccepted', _handleRequestAccepted);
    _socket.on('VerifyAccepted', _handleVerifyAccepted);
    _socket.on('studentSelectedOverseer', _handleStudentSelectedOverseer);
    _socket.on('disconnect', _handleDisconnect);
    _socket.on('error', _handleError);
    _socket.on('updatecasetype', _handleUpdatecasetype);
    _socket.on('send_message', _handleNewMessage);
  }

  final _newMessageStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get onNewMessage =>
      _newMessageStreamController.stream;

  void _handleConnect(dynamic data) {
    debugPrint('✅ Socket connected');
    isConnected.value = true;
    connectionStatus.value = 'متصل';
    _socket.emit('registerPatient', _userId);
  }

  void _handleDisconnect(dynamic data) {
    debugPrint('❌ Disconnected');
    isConnected.value = false;
    connectionStatus.value = 'غير متصل';
    _attemptReconnect();
  }

  void _handleError(dynamic error) {
    debugPrint('⚠️ Socket error: $error');
    connectionStatus.value = 'خطأ في الاتصال';
  }

  void _attemptReconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!isConnected.value && _userId != null) {
        connect(_userId!);
      }
    });
  }

  void disconnect() {
    _socket.dispose();
    isConnected.value = false;
    connectionStatus.value = 'غير متصل';
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
