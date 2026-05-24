// class RequestSendModel {
//    int painSeverity; //شدة الالم
//    String painTime; //وقت الالم
//    String toothLocation; // موقع السن
//    String gender; // الجنس
//    Photo? photo; // صورة
//    String age; // العمر
//    bool? isPregnant; // حامل
//    String caseType; //نوع المعالجة
//    MoreDetails? moreDetails; // تفاصيل إضافية

//   RequestSendModel({
//     required this.age,
//     this.isPregnant,
//     required this.painSeverity,
//     required this.painTime,
//     required this.toothLocation,
//     required this.gender,
//     this.photo,
//     required this.caseType,
//       this.moreDetails,
//   });

//   factory RequestSendModel.fromJson(Map<String, dynamic> json) {
//     return RequestSendModel(
//       isPregnant: json['is_pregnant'] ?? false,
//       age: json['age'] ,
//       painSeverity: json['pain_severity'] ?? 0,
//       painTime: json['pain_time'] ?? '',
//       toothLocation: json['tooth_location'] ?? '',
//       gender: json['gender'] ?? '',
//       photo: Photo.fromJson(json['photo'] ?? {}),
//       caseType: json['case_type'] ?? '',
//       moreDetails:MoreDetails.fromJson(json['more_details']?? {}) 
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'pain_severity': painSeverity,
//       'pain_time': painTime,
//       'tooth_location': toothLocation,
//       'gender': gender,
//       if(gender=="female")'is_pregnant': isPregnant,
//       'age':age,
//       // if(photo!=null) 'photo': photo!.toJson(),
//       'case_type': caseType,
//       if(moreDetails!=null) 'more_details': moreDetails!.toJson(),
//     };
//   }

//   @override
//   String toString() {
//     return toothLocation;
//   }
// }

class AcceptRequestModel {
   String? date;
   String? hour;
   String? location;

  AcceptRequestModel({
     this.date,
     this.hour,
     this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'hour': hour,
      'location': location,
    };
  }
}

// class RequestReceiveModel {
//   final String? id;
//   final String? user;
//   final int painSeverity; //شدة الالم
//   final String painTime; //وقت الالم
//   final String toothLocation; // موقع السن
//   final String gender; // الجنس
//   final Photo? photo; // صورة
//   final String age; // العمر
//   final String? status; // حالة الطلب
//   final bool? isRegnant; // حامل
//   // final String caseType; //نوع المعالجة
//   final MoreDetails? moreDetails;
  // final DateTime createdAt;
//   final DateTime updatedAt;

//   RequestReceiveModel( {
//     this.id,
//     this.user,
//     required this.age,
//     this.isRegnant,
//     required this.painSeverity,
//     required this.painTime,
//     required this.toothLocation,
//     required this.gender,
//     this.photo,
//     this.status,
//     this.moreDetails,
//     // required this.caseType,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory RequestReceiveModel.fromJson(Map<String, dynamic> json) {
//     return RequestReceiveModel(
//       isRegnant: json['is_regnant'] ?? false,
//       age: json['age'] ?? '',
//       id: json['_id'],
//       user: json['user'],
//       painSeverity: json['pain_severity'] ?? 0,
//       painTime: json['pain_time'] ?? '',
//       toothLocation: json['tooth_location'] ?? '',
//       gender: json['gender'] ?? '',
//       photo: Photo.fromJson(json['photo'] ?? {}),
//       moreDetails: MoreDetails.fromJson(json['more_details'] ?? {}),
//       status: json['status'] ?? '',
//       // caseType: json['case_type'] ?? {},
//       createdAt:
//           DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
//       updatedAt:
//           DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'pain_severity': painSeverity,
//       '_id': id,
//       'user': user,
//       'pain_time': painTime,
//       'tooth_location': toothLocation,
//       'gender': gender,
//       'photo': photo?.toJson(),
//       'more_details': moreDetails?.toJson(),
//       'status': status,
//       // 'case_type': caseType,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//     };
//   }

//   @override
//   String toString() {
//     return id!;
//   }
// }

// class Photo {
//   final String? publicId;
//   final String? url;

//   Photo({
//     this.publicId,
//     required this.url,
//   });

//   factory Photo.fromJson(Map<String, dynamic> json) {
//     return Photo(
//       publicId: json['publicId'],
//       url: json['url'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'publicId': publicId,
//       'url': url,
//     };
//   }
// }
// class MoreDetails {
//    String? medicines;
//    String? chronicDiseases;
//    bool? previousTreatment;
//       String? notes; // ملاحظات


//   MoreDetails({
//     this.medicines,
//     this.chronicDiseases,
//     this.previousTreatment,
//     this.notes,
//   });

//   factory MoreDetails.fromJson(Map<String, dynamic> json) {
//     return MoreDetails(
//        medicines: json['medicines'],
//       chronicDiseases: json['chronic_diseases'],
//       previousTreatment: json['previous_treatment'],
//       notes: json['notes'],
//     );
//   }

//   Map<String, dynamic> toJson() {
    
//     return {
      
//       if (medicines != null) 'medicines': medicines,
//       if (chronicDiseases != null) 'chronic_diseases': chronicDiseases,
//       if (previousTreatment != null) 'previous_treatment': previousTreatment,
//       if (notes != null) 'notes': notes,
//     };
//   }
// }
