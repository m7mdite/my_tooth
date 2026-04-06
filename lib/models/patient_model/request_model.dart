// class RequestModel {
//   String? sId;
//   String? user;
//   int? painSeverity;
//   String? painTime;
//   String? toothLocation;
//   String? gender;
//   String? status;
//   String? caseType;
//   String? age;
//   String? notes;
//   Photo? photo;
//   bool? isRegnant;
//   DateTime? createdAt;
//   DateTime? updatedAt;

//   RequestModel( {
//      this.sId,
//      this.user,
//      this.painSeverity,
//      this.painTime,
//    this.toothLocation,
//      this.gender,
//     this.status,
//      this.caseType,
//      this.age,
//     this.photo, 
//     this.notes, 
//     this.isRegnant, 
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory  RequestModel.fromJson(Map<String, dynamic> json) {
//     return RequestModel(
//       isRegnant: json['is_regnant'] ?? false,
//       age: json['age'] ?? '',
//       notes: json['notes'] ?? '',
//       user: json['user'],
//       painSeverity: json['pain_severity'] ?? 0,
//       painTime: json['pain_time'] ?? '',
//       toothLocation: json['tooth_location'] ?? '',
//       gender: json['gender'] ?? '',
//       photo: Photo.fromJson(json['photo'] ?? {}),
//       status: json['status'] ?? '',
//       caseType: json['case_type'] ?? '',
//       createdAt:
//           DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
//       updatedAt:
//           DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    
//     // createdAt : json['createdAt'],
//     // updatedAt : json['updatedAt'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};

//     // التحقق من كل حقل وإضافته فقط إذا كانت قيمته غير null
//     // if (sId != null && sId!.isNotEmpty) {
//     //   data['_id'] = sId;
//     // }

//     // if (user != null && user!.isNotEmpty) {
//     //   data['user'] = user;
//     // }
//     if (isRegnant != null && gender == 'female') {
//       data['is_pregnant'] = isRegnant;
//     }
//     if (painSeverity != null) {
//       data['pain_severity'] = painSeverity;
//     }
//     if (notes != null && notes!.isNotEmpty) {
//       data['notes'] = notes;
//     }
//     if (painTime != null && painTime!.isNotEmpty) {
//       data['pain_time'] = painTime;
//     }

//     if (toothLocation != null && toothLocation!.isNotEmpty) {
//       data['tooth_location'] = toothLocation;
//     }

//     if (gender != null && gender!.isNotEmpty) {
//       data['gender'] = gender;
//     }

//     if (status != null && status!.isNotEmpty) {
//       data['status'] = status;
//     }

//     if (caseType != null && caseType!.isNotEmpty) {
//       data['case_type'] = caseType;
//     }

//     if (age != null && age!.isNotEmpty) {
//       data['age'] = age;
//     }

//     if (photo != null) {
//       data['photo'] = photo!.toJson();
//     }

//     // if (createdAt != null) {
//     //   data['createdAt'] = createdAt;
//     // }

//     // if (updatedAt != null) {
//     //   data['updatedAt'] = updatedAt;
//     // }

//     return data;
//   }
// }

// class Photo {
//   Null? publicId;
//   String? url;

//   Photo({this.publicId, this.url});

//   Photo.fromJson(Map<String, dynamic> json) {
//     publicId = json['publicId'];
//     url = json['url'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['publicId'] = this.publicId;
//     data['url'] = this.url;
//     return data;
//   }
// }
