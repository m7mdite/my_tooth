// lib/models/admin/lesson_model.dart
class LessonModel {
  String? sId;
  String? time;          // "الأحد-08:00"
  String? hall;
  CourseInfo? course;
  CategoryInfo? category;
  List<OverseerInfo>? overseers;

  LessonModel({
    this.sId,
    this.time,
    this.hall,
    this.course,
    this.category,
    this.overseers,
  });

  LessonModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    time = json['time'];
    hall = json['hall'];

    if (json['course'] != null && json['course'] is Map<String, dynamic>) {
      course = CourseInfo.fromJson(json['course']);
    }

    if (json['category'] != null && json['category'] is Map<String, dynamic>) {
      category = CategoryInfo.fromJson(json['category']);
    }

    if (json['overseers'] != null) {
      overseers = (json['overseers'] as List)
          .map((e) => OverseerInfo.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['time'] = time;
    data['hall'] = hall;
    if (course != null) data['course'] = course!.toJson();
    if (category != null) data['category'] = category!.toJson();
    if (overseers != null) {
      data['overseers'] = overseers!.map((e) => e.toJson()).toList();
    }
    return data;
  }

  // ========== دوال مساعدة ==========
  String get day {
    if (time == null || time!.isEmpty || time == '-') return '';
    if (time!.contains('-')) {
      return time!.split('-')[0];
    }
    return time!;
  }

  String get period {
    if (time == null || time!.isEmpty || time == '-') return '';
    if (time!.contains('-')) {
      return time!.split('-')[1];
    }
    return time!;
  }

  String get overseersNames {
    if (overseers == null || overseers!.isEmpty) return 'لا يوجد';
    return overseers!
        .map((o) => '${o.firstName ?? ''} ${o.fatherName ?? ''} ${o.lastName ?? ''}'.trim())
        .join('، ');
  }

  String get shortOverseers {
    if (overseers == null || overseers!.isEmpty) return 'لا يوجد';
    return overseers!.map((o) => o.firstName ?? '').join('، ');
  }
}

// ======================== CourseInfo ========================
class CourseInfo {
  String? sId;
  String? courseName;
  CourseInfo({this.sId, this.courseName});
  CourseInfo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    courseName = json['course_name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['course_name'] = courseName;
    return data;
  }
}

// ======================== CategoryInfo ========================
class CategoryInfo {
  String? sId;
  String? category;
  CategoryInfo({this.sId, this.category});
  CategoryInfo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    category = json['category'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['category'] = category;
    return data;
  }
}

// ======================== OverseerInfo ========================
class OverseerInfo {
  String? sId;
  String? user;
  String? firstName;
  String? fatherName;
  String? lastName;
  String? bio;
  bool? isVerified;
  ProfilePhoto? profilePhoto;

  OverseerInfo({
    this.sId,
    this.user,
    this.firstName,
    this.fatherName,
    this.lastName,
    this.bio,
    this.isVerified,
    this.profilePhoto,
  });

  OverseerInfo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    firstName = json['first_name'];
    fatherName = json['father_name'];
    lastName = json['last_name'];
    bio = json['bio'];
    isVerified = json['is_verified'];
    if (json['profile_photo'] != null) {
      profilePhoto = ProfilePhoto.fromJson(json['profile_photo']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    data['first_name'] = firstName;
    data['father_name'] = fatherName;
    data['last_name'] = lastName;
    data['bio'] = bio;
    data['is_verified'] = isVerified;
    if (profilePhoto != null) data['profile_photo'] = profilePhoto!.toJson();
    return data;
  }
}

class ProfilePhoto {
  String? url;
  ProfilePhoto({this.url});
  ProfilePhoto.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    return data;
  }
}