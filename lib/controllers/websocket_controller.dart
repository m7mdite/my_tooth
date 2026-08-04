// lib/controllers/websocket_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart' as io;
import 'dart:convert';

import '../services/local_storge/local_user_storage.dart';
import '../utils/app_constants/colors_constant.dart';

class WebSocketController extends GetxController {
  WebSocketChannel? _channel;
  final RxBool _isConnected = false.obs;
  final RxList<Map<String, dynamic>> _notifications = <Map<String, dynamic>>[].obs;
  final localStorage = Get.find<LocalUserStorage>();
  bool get isConnected => _isConnected.value;
  List<Map<String, dynamic>> get notifications => _notifications;
  
  // توصيل WebSocket
  void connect() async{
    final String? id =  localStorage.getId();

    try {
      final url = 'https://localhost:5000';
      _channel = io.IOWebSocketChannel.connect(
        url,
        headers: {'patientId': '$id' },
      );
      // _channel = IOWebSocketChannel.connect(url,headers: {'patientId': '697466449212df271ffb850b'});
      _isConnected.value = true;
      
      // الاستماع للرسائل
      _channel!.stream.listen(
        (message) {
          _handleIncomingMessage(message);
        },
        onError: (error) {
          print('WebSocket error: $error');
          _isConnected.value = false;
          // إعادة المحاولة بعد 5 ثواني
          Future.delayed(Duration(seconds: 5), () {
            if (!_isConnected.value) reconnect();
          });
        },
        onDone: () {
          print('WebSocket disconnected');
          _isConnected.value = false;
        },
      );
      
      Get.snackbar('نجاح', 'تم الاتصال بالسيرفر',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print("$e");
      Get.snackbar('خطأ', 'فشل الاتصال بالسيرفر: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
  
  void _handleIncomingMessage(dynamic message) {
    try {
      final data = json.decode(message);
      print('Received message: $data');
      
      if (data['type'] == 'requestAccepted') {
        _handleRequestAccepted(data);
      }
      // يمكنك إضافة أنواع أخرى من الرسائل
    } catch (e) {
      print('Error parsing message: $e');
    }
  }
  
  void _handleRequestAccepted(Map<String, dynamic> data) {
    // إضافة الإشعار للقائمة
    final notification = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'message': data['message'],
      'date': data['date'],
      'hour': data['hour'],
      'location': data['location'],
      'type': 'requestAccepted',
      'read': false,
      'timestamp': DateTime.now().toString(),
    };
    
    _notifications.insert(0, notification);
    
    // إظهار إشعار فوري
    _showImmediateNotification(data);
    
    // تحديث الـ UI
    update();
  }
  
  void _showImmediateNotification(Map<String, dynamic> data) {
    Get.defaultDialog(
      title: 'تم قبول طلب العلاج 🎉',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(data['message']),
          SizedBox(height: 10),
          Text('التاريخ: ${data['date']}'),
          Text('الوقت: ${data['hour']}'),
          Text('المكان: ${data['location']}'),
        ],
      ),
      textConfirm: 'حفظ التفاصيل',
      textCancel: 'إغلاق',
      confirmTextColor: AppColors.white,
      onConfirm: () {
        Get.back();
        _saveNotificationDetails(data);
      },
      onCancel: () => Get.back(),
    );
  }
  
  void _saveNotificationDetails(Map<String, dynamic> data) {
    // حفظ في GetStorage أو قاعدة بيانات محلية
    final box = GetStorage();
    final savedNotifications = box.read('notifications') ?? [];
    savedNotifications.add(data);
    box.write('notifications', savedNotifications);
    
    Get.snackbar('تم الحفظ', 'تم حفظ تفاصيل الموعد',
        snackPosition: SnackPosition.BOTTOM);
  }
  
  // إعادة الاتصال
  void reconnect() {
    if (_channel != null) {
      _channel!.sink.close();
    }
    connect();
  }
  
  // إرسال رسالة
  void sendMessage(Map<String, dynamic> message) {
    if (_channel != null && _isConnected.value) {
      _channel!.sink.add(json.encode(message));
    } else {
      Get.snackbar('تحذير', 'الاتصال غير متوفر',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
  
  // تعليم الإشعار كمقروء
  void markAsRead(int notificationId) {
    final index = _notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      _notifications[index]['read'] = true;
      update();
    }
  }
  
  // حذف إشعار
  void deleteNotification(int notificationId) {
    _notifications.removeWhere((n) => n['id'] == notificationId);
    update();
  }
  
  // مسح جميع الإشعارات
  void clearAllNotifications() {
    _notifications.clear();
    update();
  }
  
  // فصل الاتصال
  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close();
      _isConnected.value = false;
    }
  }
  
  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}