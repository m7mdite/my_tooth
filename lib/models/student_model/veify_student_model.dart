class VeifyStudentModel {
  String? sId;
  String? document;
  StudentProfile? studentProfile;
  String? user;
  String? createdAt;
  String? updatedAt;
  int? iV;

  VeifyStudentModel(
      {this.sId,
      this.document,
      this.studentProfile,
      this.user,
      this.createdAt,
      this.updatedAt,
      this.iV});

  VeifyStudentModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    document = json['document'];
    studentProfile = json['student_profile'] != null
        ? new StudentProfile.fromJson(json['student_profile'])
        : null;
    user = json['user'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['document'] = document;
    if (studentProfile != null) {
      data['student_profile'] = studentProfile!.toJson();
    }
    data['user'] = user;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class StudentProfile {
  String? sId;
  String? user;
  String? universityNumber;
  String? firstName;
  String? fatherName;
  String? lastName;
  ProfilePhoto? profilePhoto;

  StudentProfile(
      {this.sId,
      this.user,
      this.universityNumber,
      this.firstName,
      this.fatherName,
      this.lastName,
      this.profilePhoto});

  StudentProfile.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    universityNumber = json['university_number'];
    firstName = json['first_name'];
    fatherName = json['father_name'];
    lastName = json['last_name'];
    profilePhoto = json['profile_photo'] != null
        ? new ProfilePhoto.fromJson(json['profile_photo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    data['university_number'] = universityNumber;
    data['first_name'] = firstName;
    data['father_name'] = fatherName;
    data['last_name'] = lastName;
    if (profilePhoto != null) {
      data['profile_photo'] = profilePhoto!.toJson();
    }
    return data;
  }
}

class ProfilePhoto {
  String? publicId;
  String? url;

  ProfilePhoto({this.publicId, this.url});

  ProfilePhoto.fromJson(Map<String, dynamic> json) {
    publicId = json['publicId'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['publicId'] = publicId;
    data['url'] = url;
    return data;
  }
}