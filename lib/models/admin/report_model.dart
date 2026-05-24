class ReportModel {
  String? sId;
  String? reason;
  String? type;
  String? status;
  String? adminNote;
  DateTime? reviewedAt;
  String? reviewedBy;
  String? createdAt;
  Reporter? reporter;
  Reported? reported;

  ReportModel(
      {this.sId,
      this.reason,
      this.type,
      this.status,
      this.adminNote,
      this.reviewedAt,
      this.reviewedBy,
      this.createdAt,
      this.reporter,
      this.reported});

  ReportModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    reason = json['reason'];
    type = json['type'];
    status = json['status'];
    adminNote = json['admin_note'];
    reviewedAt = json['reviewed_at'];
    reviewedBy = json['reviewed_by'];
    createdAt = json['created_at'];
    reporter = json['reporter'] != null
        ? Reporter.fromJson(json['reporter'])
        : null;
    reported = json['reported'] != null
        ? Reported.fromJson(json['reported'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reason'] = reason;
    data['type'] = type;
    data['status'] = status;
    data['admin_note'] = adminNote;
    data['reviewed_at'] = reviewedAt;
    data['reviewed_by'] = reviewedBy;
    data['created_at'] = createdAt;
    if (reporter != null) {
      data['reporter'] = reporter!.toJson();
    }
    if (reported != null) {
      data['reported'] = reported!.toJson();
    }
    return data;
  }
}

class Reporter {
  String? fullName;

  Reporter({this.fullName});

  Reporter.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    return data;
  }
}

class Reported {
  String? sId;
  String? user;
  String? firstName;
  String? fatherName;
  String? lastName;
  String? bio;
  ProfilePhoto? profilePhoto;
  String? gender;
  int? iV;

  Reported(
      {this.sId,
      this.user,
      this.firstName,
      this.fatherName,
      this.lastName,
      this.bio,
      this.profilePhoto,
      this.gender,
      this.iV});

  Reported.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    firstName = json['first_name'];
    fatherName = json['father_name'];
    lastName = json['last_name'];
    bio = json['bio'];
    profilePhoto = json['profile_photo'] != null
        ? ProfilePhoto.fromJson(json['profile_photo'])
        : null;
    gender = json['gender'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user'] = user;
    data['first_name'] = firstName;
    data['father_name'] = fatherName;
    data['last_name'] = lastName;
    data['bio'] = bio;
    if (profilePhoto != null) {
      data['profile_photo'] = profilePhoto!.toJson();
    }
    data['gender'] = gender;
    data['__v'] = iV;
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






 // models/report_model.dart
// class ReportModel {
//    String id;
//    String reason;
//    String type;          // مثل "مضايقة", "محتوى غير لائق", "سبب آخر"
//    String status;        // "pending", "reviewed", "resolved"
//    String? adminNote;
//    DateTime? reviewedAt;
//    String? reviewedBy;
//    DateTime createdAt;
//    Reporter reporter;
//    Reported reported;

//   ReportModel({
//     required this.id,
//     required this.reason,
//     required this.type,
//     required this.status,
//     this.adminNote,
//     this.reviewedAt,
//     this.reviewedBy,
//     required this.createdAt,
//     required this.reporter,
//     required this.reported,
//   });

//   factory ReportModel.fromJson(Map<String, dynamic> json) {
//     return ReportModel(
//       id: json['_id'] ?? json['id'],
//       reason: json['reason'] ?? '',
//       type: json['type'] ?? '',
//       status: json['status'] ?? 'pending',
//       adminNote: json['admin_note'],
//       reviewedAt: json['reviewed_at'] != null ? DateTime.parse(json['reviewed_at']) : null,
//       reviewedBy: json['reviewed_by'],
//       createdAt: DateTime.parse(json['created_at']),
//       reporter: Reporter.fromJson(json['reporter'] ?? {}),
//       reported: Reported.fromJson(json['reported'] ?? {}),
//     );
//   }
// }

// class Reporter {
//   final String fullName;

//   Reporter({required this.fullName});

//   factory Reporter.fromJson(Map<String, dynamic> json) {
//     return Reporter(fullName: json['full_name'] ?? 'غير معروف');
//   }
// }

// class Reported {
//   final String id;
//   final String user;
//   final String firstName;
//   final String fatherName;
//   final String lastName;
//   final String bio;
//   final ProfilePhoto? profilePhoto;
//   final String? gender;
//   final bool? isVerified;

//   Reported({
//     required this.id,
//     required this.user,
//     required this.firstName,
//     required this.fatherName,
//     required this.lastName,
//     required this.bio,
//     this.profilePhoto,
//     this.gender,
//     this.isVerified,
//   });

//   factory Reported.fromJson(Map<String, dynamic> json) {
//     return Reported(
//       id: json['_id'] ?? '',
//       user: json['user'] ?? '',
//       firstName: json['first_name'] ?? '',
//       fatherName: json['father_name'] ?? '',
//       lastName: json['last_name'] ?? '',
//       bio: json['bio'] ?? '',
//       profilePhoto: json['profile_photo'] != null ? ProfilePhoto.fromJson(json['profile_photo']) : null,
//       gender: json['gender'],
//       isVerified: json['is_verified'],
//     );
//   }
// }

// class ProfilePhoto {
//   final String? publicId;
//   final String url;

//   ProfilePhoto({this.publicId, required this.url});

//   factory ProfilePhoto.fromJson(Map<String, dynamic> json) {
//     return ProfilePhoto(
//       publicId: json['publicId'],
//       url: json['url'] ?? '',
//     );
//   }
// }