class ProfileOverseerModel {
  bool? isVerified;
  String? sId;
  String? email;
  String? user;
  String? firstName;
  String? fatherName;
  String? lastName;
  String? bio;
  ProfilePhoto? profilePhoto;

  ProfileOverseerModel(
      {this.isVerified,
      this.email,
      this.sId,
      this.user,
      this.firstName,
      this.fatherName,
      this.lastName,
      this.bio,
      this.profilePhoto});

  ProfileOverseerModel.fromJson(Map<String, dynamic> json) {
    isVerified = json['is_verified'];
    sId = json['_id'];
    email = json['email'];
    user = json['user'];
    firstName = json['first_name'];
    fatherName = json['father_name'];
    lastName = json['last_name'];
    bio = json['bio'];
    profilePhoto = json['profile_photo'] != null
        ? ProfilePhoto.fromJson(json['profile_photo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_verified'] = isVerified;
    data['_id'] = sId;
    data['user'] = user;
    data['first_name'] = firstName;
    data['father_name'] = fatherName;
    data['last_name'] = lastName;
    data['bio'] = bio;
    if (profilePhoto != null) {
      data['profile_photo'] = profilePhoto!.toJson();
    }
    return data;
  }
}

class ProfilePhoto {
  Null publicId;
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