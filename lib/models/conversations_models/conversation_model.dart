class ConversationModel {
  final String conversationId;
  final String lastMessage;
  final OtherPartyModel otherParty;
  // final DateTime updatedAt;

  ConversationModel({
    required this.conversationId,
    required this.lastMessage,
    required this.otherParty,
    // required this.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      conversationId: json['conversationId'],
      lastMessage: json['last_message'] ?? '',
      otherParty: OtherPartyModel.fromJson(json['otherPartyProfile']),
      // updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'conversationId': conversationId,
    'last_message': lastMessage,
    'otherParty': otherParty.toJson(),
    // 'updatedAt': updatedAt.toIso8601String(),
  };
}

class OtherPartyModel {
  final String userId;
  final String fullName;
  final Map<String, dynamic>? profilePhoto;
  final String role; // 'student', 'patient', 'overseer', 'admin'

  OtherPartyModel({
    required this.userId,
    required this.fullName,
    this.profilePhoto,
    required this.role,
  });

  factory OtherPartyModel.fromJson(Map<String, dynamic> json) {
    return OtherPartyModel(
      userId: json['userId'],
      fullName: json['full_name'] ?? 'مستخدم',
      profilePhoto: json['profile_photo'],
      role: json['role'] ?? 'unknown',
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'full_name': fullName,
    'profile_photo': profilePhoto,
    'role': role,
  };
}