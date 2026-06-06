class PostModel {
   String id;
   String content;
   List<String> images;
   int likesCount;
   int dislikesCount;
   int commentsCount;
   String createdAt;
   String publisherRole;
   Publisher publisher;

  PostModel({
    required this.id,
    required this.content,
    required this.images,
    required this.likesCount,
    required this.dislikesCount,
    required this.commentsCount,
    required this.createdAt,
    required this.publisherRole,
    required this.publisher,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      likesCount: json['count_likes'] ?? 10,
      dislikesCount: json['count_dislikes'] ?? 0,
      commentsCount: json['count_comments'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      publisherRole: json['publisher_role'] ?? '',
      publisher: Publisher.fromJson(json['publisher'] ?? {}),
    );
  }
}

class Publisher {
  final String fullName;
  final String? profilePhoto;
  final String? gender;
  final bool isVerified;

  Publisher({
    required this.fullName,
    this.profilePhoto,
    this.gender,
    required this.isVerified,
  });

  factory Publisher.fromJson(Map<String, dynamic> json) {
    return Publisher(
      fullName: json['full_name'] ?? '',
      profilePhoto: json['profile_photo'] != null ? json['profile_photo']['url'] : null,
      gender: json['gender'],
      isVerified: json['is_verified'] ?? false,
    );
  }
}