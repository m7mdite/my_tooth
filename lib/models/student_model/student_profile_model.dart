// كلاس البروفايل الرئيسي
class StudentProfileModel {
  String? id;
  String? userId;
  String? universityNumber;
  String? firstName;
  String? fatherName;
  String? lastName;
  String? bio;
  ProfilePhoto? profilePhoto;
  String? gender;
  int? v;

  StudentProfileModel({
    this.id,
    this.userId,
    this.universityNumber,
    this.firstName,
    this.fatherName,
    this.lastName,
    this.bio,
    this.profilePhoto,
    this.gender,
    this.v,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      id: json['_id'] as String?,
      userId: json['user'] as String?,
      universityNumber: json['university_number'] as String?,
      firstName: json['first_name'] as String?,
      fatherName: json['father_name'] as String?,
      lastName: json['last_name'] as String?,
      bio: json['bio'] as String?,
      profilePhoto: json['profile_photo'] != null
          ? ProfilePhoto.fromJson(json['profile_photo'] as Map<String, dynamic>)
          : null,
      gender: json['gender'] as String?,
      v: json['__v'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'university_number': universityNumber,
      'first_name': firstName,
      'father_name': fatherName,
      'last_name': lastName,
      'bio': bio,
      'profile_photo': profilePhoto?.toJson(),
      'gender': gender,
      '__v': v,
    };
  }

  // الحصول على الاسم الكامل
  String get fullName {
    return [
      firstName,
      fatherName,
      lastName,
    ].where((name) => name != null && name.isNotEmpty).join(' ');
  }
}

// كلاس صورة البروفايل
class ProfilePhoto {
  String? publicId;
  String? url;

  ProfilePhoto({
    this.publicId,
    this.url,
  });

  factory ProfilePhoto.fromJson(Map<String, dynamic> json) {
    return ProfilePhoto(
      publicId: json['publicId'] as String?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'publicId': publicId,
      'url': url,
    };
  }
}