class PostModel {
  String? sId;
  String? content;
  bool? isForMe;
  List<Images>? images;
  int? countLikes;
  int? countDislikes;
  int? countComments;
  String? createdAt;
  String? publisherRole;
  Publisher? publisher;

  PostModel(
      {this.sId,
      this.content,
      this.isForMe,
      this.images,
      this.countLikes,
      this.countDislikes,
      this.countComments,
      this.createdAt,
      this.publisherRole,
      this.publisher});

  PostModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = json['content'];
    isForMe = json['is_for_me'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add( Images.fromJson(v));
      });
    }
    countLikes = json['count_likes'];
    countDislikes = json['count_dislikes'];
    countComments = json['count_comments'];
    createdAt = json['created_at'];
    publisherRole = json['publisher_role'];
    publisher = json['publisher'] != null
        ?  Publisher.fromJson(json['publisher'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['content'] = content;
    data['is_for_me'] = isForMe;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['count_likes'] = countLikes;
    data['count_dislikes'] = countDislikes;
    data['count_comments'] = countComments;
    data['created_at'] = createdAt;
    data['publisher_role'] = publisherRole;
    if (publisher != null) {
      data['publisher'] = publisher!.toJson();
    }
    return data;
  }
}

class Images {
  String? url;
  String? publicId;
  String? sId;

  Images({this.url, this.publicId, this.sId});

  Images.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    publicId = json['publicId'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['publicId'] = publicId;
    data['_id'] = sId;
    return data;
  }
}

class Publisher {
  String? sId;
  String? fullName;
  String? profilePhoto;
  String? gender;
  bool? isVerified;

  Publisher(
      {this.sId,
      this.fullName,
      this.profilePhoto,
      this.gender,
      this.isVerified});

  Publisher.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['full_name'];
    profilePhoto = json['profile_photo'];
    gender = json['gender'];
    isVerified = json['is_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['_id'] = sId;
    data['full_name'] = fullName;
    data['profile_photo'] = profilePhoto;
    data['gender'] = gender;
    data['is_verified'] = isVerified;
    return data;
  }
}




// class PostModel {
//    String id;
//    String content;
//    List<Image>? images;
//    int likesCount;
//    int dislikesCount;
//    int commentsCount;
//    String createdAt;
//    String publisherRole;
//    Publisher publisher;

//   PostModel({
//     required this.id,
//     required this.content,
//     required this.images,
//     required this.likesCount,
//     required this.dislikesCount,
//     required this.commentsCount,
//     required this.createdAt,
//     required this.publisherRole,
//     required this.publisher,
//   });

//   factory PostModel.fromJson(Map<String, dynamic> json) {
//     return PostModel(
//       id: json['_id'] ?? '',
//       content: json['content'] ?? '',
//       if (json['images'] != null) {
//       images = <Image>[];
//       json['images'].forEach((v) {
//         images!.add(new Images.fromJson(v));
//       });
//     }
//       likesCount: json['count_likes'] ?? 10,
//       dislikesCount: json['count_dislikes'] ?? 0,
//       commentsCount: json['count_comments'] ?? 0,
//       createdAt: json['createdAt'] ?? '',
//       publisherRole: json['publisher_role'] ?? '',
//       publisher: Publisher.fromJson(json['publisher'] ?? {}),
//     );
//   }
// }

// class Publisher {
//   final String fullName;
//   final String? profilePhoto;
//   final String? gender;
//   final bool isVerified;

//   Publisher({
//     required this.fullName,
//     this.profilePhoto,
//     this.gender,
//     required this.isVerified,
//   });

//   factory Publisher.fromJson(Map<String, dynamic> json) {
//     return Publisher(
//       fullName: json['full_name'] ?? '',
//       profilePhoto: json['profile_photo'] != null ? json['profile_photo']['url'] : null,
//       gender: json['gender'],
//       isVerified: json['is_verified'] ?? false,
//     );
//   }
// }
// class Image {
//   String? url;
//   String? publicId;
//   String? sId;

//   Image({this.url, this.publicId, this.sId});

//   Image.fromJson(Map<String, dynamic> json) {
//     url = json['url'];
//     publicId = json['publicId'];
//     sId = json['_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['url'] = url;
//     data['publicId'] = publicId;
//     data['_id'] = sId;
//     return data;
//   }
// }