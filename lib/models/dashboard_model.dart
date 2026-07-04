class DashboardModel {
  Requests? requests;
  Users? users;
  TopPosts? topPosts;
  AdvStats? adv;

  DashboardModel({this.requests, this.users, this.topPosts, this.adv});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    requests = json['requests'] != null ? Requests.fromJson(json['requests']) : null;
    users = json['users'] != null ? Users.fromJson(json['users']) : null;
    topPosts = json['top_posts'] != null ? TopPosts.fromJson(json['top_posts']) : null;
    adv = json['adv'] != null ? AdvStats.fromJson(json['adv']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (requests != null) data['requests'] = requests!.toJson();
    if (users != null) data['users'] = users!.toJson();
    if (topPosts != null) data['top_posts'] = topPosts!.toJson();
    if (adv != null) data['adv'] = adv!.toJson();
    return data;
  }
}

// ===== الإحصائيات =====
class Requests {
  int? pending;
  int? processing;
  int? finished;
  int? total;

  Requests({this.pending, this.processing, this.finished, this.total});

  Requests.fromJson(Map<String, dynamic> json) {
    pending = json['pending'];
    processing = json['processing'];
    finished = json['finished'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pending'] = pending;
    data['processing'] = processing;
    data['finished'] = finished;
    data['total'] = total;
    return data;
  }
}

class Users {
  int? countUsers;
  int? countStudents;
  int? countPatients;
  int? countOverseers;

  Users({this.countUsers, this.countStudents, this.countPatients, this.countOverseers});

  Users.fromJson(Map<String, dynamic> json) {
    countUsers = json['count_users'];
    countStudents = json['count_students'];
    countPatients = json['count_patients'];
    countOverseers = json['count_overseers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count_users'] = countUsers;
    data['count_students'] = countStudents;
    data['count_patients'] = countPatients;
    data['count_overseers'] = countOverseers;
    return data;
  }
}

// ===== البوستات =====
class TopPosts {
  int? count;
  List<DataPost>? data;

  TopPosts({this.count, this.data});

  TopPosts.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = <DataPost>[];
      json['data'].forEach((v) {
        data!.add(DataPost.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataPost {
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

  DataPost({
    this.sId,
    this.content,
    this.isForMe,
    this.images,
    this.countLikes,
    this.countDislikes,
    this.countComments,
    this.createdAt,
    this.publisherRole,
    this.publisher,
  });

  DataPost.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = json['content'];
    isForMe = json['is_for_me'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    countLikes = json['count_likes'];
    countDislikes = json['count_dislikes'];
    countComments = json['count_comments'];
    createdAt = json['created_at'];
    publisherRole = json['publisher_role'];
    publisher = json['publisher'] != null ? Publisher.fromJson(json['publisher']) : null;
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

  Publisher({this.sId, this.fullName, this.profilePhoto, this.gender, this.isVerified});

  Publisher.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['full_name'];
    profilePhoto = json['profile_photo'];
    gender = json['gender'];
    isVerified = json['is_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['full_name'] = fullName;
    data['profile_photo'] = profilePhoto;
    data['gender'] = gender;
    data['is_verified'] = isVerified;
    return data;
  }
}

// ===== الإعلانات =====
class AdvStats {
  int? count;
  List<AdvItem>? data;

  AdvStats({this.count, this.data});

  AdvStats.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = <AdvItem>[];
      json['data'].forEach((v) {
        data!.add(AdvItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AdvItem {
  String? sId;
  String? content;
  AdvImage? image;
  String? createdAt;
  String? updatedAt;

  AdvItem({this.sId, this.content, this.image, this.createdAt, this.updatedAt});

  AdvItem.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = json['content'];
    image = json['image'] != null ? AdvImage.fromJson(json['image']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['content'] = content;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class AdvImage {
  String? url;

  AdvImage({this.url});

  AdvImage.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    return data;
  }
}