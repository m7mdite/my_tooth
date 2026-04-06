class ProfileModel {
   String id;
   String user;
 String firstName;
   String lastName;
   String email;
   String? universityNumber;
   String? bio;
   String? phoneNumber;
   String? gender;
   int? age;
   ProfilePhoto? profilePhoto; // صورة


  ProfileModel({
    this.profilePhoto,
    this.phoneNumber,
    this.gender,
    this.age,
    required this.bio,
    required this.id,
    required this.user,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.universityNumber,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      profilePhoto: ProfilePhoto.fromJson(json['profile_photo'] ?? {}),
      phoneNumber: json['phone_number'],
      gender: json['gender'],
      age: json['age'],

      email: json['email'],
      firstName: json['first_name'] ?? 'first_name',
      lastName: json['last_name'] ?? 'last_name',
      id: json['_id'],
      user: json['user'], bio: json['bio'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile_photo': profilePhoto?.toJson(),
      'phone_number': phoneNumber,
      'gender': gender,
      'age': age,

      "email": email,
      'first_name': firstName,
      'last_name': lastName,
      'bio':bio,
      'university_number': universityNumber,
    };
  }

  @override
  String toString() {
    return "";
  }
}

class ProfilePhoto {
  final String? publicId;
  final String url;

  ProfilePhoto({
    this.publicId,
    required this.url,
  });

  factory ProfilePhoto.fromJson(Map<String, dynamic> json) {
    return ProfilePhoto(
      publicId: json['publicId'],
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'publicId': publicId,
      'url': url,
    };
  }
}
