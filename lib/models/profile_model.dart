import 'package:gr_flutter/models/admin/course_model.dart';

class ProfileModel {
  //  String id;
  String user;
  String firstName;
  String lastName;
  String fatherName;
  String role;
  String? universityNumber;
  String? bio;
  String? phoneNumber;
  String? gender;
  int? age;
  ProfilePhoto? profilePhoto; // صورة
  Category? category; // تخصص الطالب

  ProfileModel(
      {this.profilePhoto,
      this.phoneNumber,
      this.gender,
      this.age,
      required this.bio,
      // required this.id,
      required this.user,
      required this.firstName,
      required this.lastName,
      required this.fatherName,
      required this.role,
      this.universityNumber,
      this.category});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      profilePhoto: ProfilePhoto.fromJson(json['profile_photo'] ?? {}),
      phoneNumber: json['phone_number'],
      gender: json['gender'],
      age: json['age'],
      bio: json['bio'] ?? '',
      role: json['role'] ?? 'patient',
      firstName: json['first_name'] ?? 'first_name',
      lastName: json['last_name'] ?? 'last_name',
      fatherName: json['father_name'] ?? 'father_name',
      // id: json['_id'],
      user: json['user'],
      universityNumber: json['university_number'],
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile_photo': profilePhoto?.toJson(),
      'phone_number': phoneNumber,
      'gender': gender,
      'age': age,
      "role": role,
      'first_name': firstName,
      'last_name': lastName,
      'bio': bio,
      'university_number': universityNumber,
      'category': category?.toJson(),
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

class Category {
  String? id;
  String? category;

  Category({
    this.id,
    this.category,
  });
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
    };
  }
}
