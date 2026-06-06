class CommentModel {
  String id;
  String content;
  int likesCount;
  DateTime createdAt;
  CommentUser user;

  CommentModel({
    required this.id,
    required this.content,
    required this.likesCount,
    required this.createdAt,
    required this.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      likesCount: json['likes_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      user: CommentUser.fromJson(json['user'] ?? {}),
    );
  }
}

class CommentUser {
  final String id;
  final String fullName;
  final String? profilePhoto;
  final bool isVerified;

  CommentUser({
    required this.id,
    required this.fullName,
    this.profilePhoto,
    required this.isVerified,
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      id: json['_id'] ?? '',
      fullName: json['full_name'] ?? '',
      profilePhoto: json['profile_photo'] != null ? json['profile_photo']['url'] : null,
      isVerified: json['is_verified'] ?? false,
    );
  }
}


// class CommentModel {
//   final String id;
//   final String postId;
//   final String userId;
//   final String userRole;
//   final String content;
//   final DateTime createdAt;
//   final UserInfo userInfo; // سنضيف معلومات المستخدم لاحقاً

//   CommentModel({
//     required this.id,
//     required this.postId,
//     required this.userId,
//     required this.userRole,
//     required this.content,
//     required this.createdAt,
//     required this.userInfo,
//   });

//   factory CommentModel.fromJson(Map<String, dynamic> json) {
//     return CommentModel(
//       id: json['_id'] ?? '',
//       postId: json['post'] ?? '',
//       userId: json['user'] ?? '',
//       userRole: json['userRole'] ?? '',
//       content: json['content'] ?? '',
//       createdAt: DateTime.parse(json['createdAt']),
//       userInfo: UserInfo.fromJson(json['userInfo'] ?? {}),
//     );
//   }
// }

// class UserInfo {
//   final String fullName;
//   final String? profilePhoto;

//   UserInfo({required this.fullName, this.profilePhoto});

//   factory UserInfo.fromJson(Map<String, dynamic> json) {
//     return UserInfo(
//       fullName: json['full_name'] ?? '',
//       profilePhoto: json['profile_photo'] != null ? json['profile_photo']['url'] : null,
//     );
//   }
// }