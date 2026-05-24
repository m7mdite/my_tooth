class MessageModel {
  final String id;
  // final String conversationId;
  final String sender;
  final String content;
  final String messageType; // 'text' or 'file'
  final bool isRead;
  final DateTime createdAt;
  final bool isFromMe;

  MessageModel({
    required this.id,
    // required this.conversationId,
    required this.sender,
    required this.content,
    required this.messageType,
    required this.isRead,
    required this.createdAt,
    required this.isFromMe,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? json['id'],
      // conversationId: json['conversationId'],
      sender: json['sender'],
      content: json['content'] ?? '',
      messageType: json['message_type'] ?? 'text',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      isFromMe: json['is_from_me']?? true
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    // 'conversationId': conversationId,
    'sender': sender,
    'content': content,
    'message_type': messageType,
    'isRead': isRead,
    'createdAt': createdAt.toIso8601String(),
  };
}