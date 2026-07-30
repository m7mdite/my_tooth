// models/public_models/notification_model.dart
import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String body;
  final String type;
  final DateTime receivedAt;
  final Map<String, dynamic>? payload;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.receivedAt,
    this.payload,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? 'إشعار جديد',
      body: json['body'] ?? '',
      type: json['type'] ?? 'general',
      receivedAt:
          DateTime.parse(json['receivedAt'] ?? DateTime.now().toIso8601String()),
      payload: json['payload'],
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'receivedAt': receivedAt.toIso8601String(),
      'payload': payload,
      'isRead': isRead,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    DateTime? receivedAt,
    Map<String, dynamic>? payload,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      receivedAt: receivedAt ?? this.receivedAt,
      payload: payload ?? this.payload,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [id, title, body, type, receivedAt, isRead];
}
