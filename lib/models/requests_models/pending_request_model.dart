// class TreatmentRequestModel {
//   String? sId;                 // يقابل _id في الخرج
//   PatientModel? patient;       // كائن المريض
//   CaseType? caseType;          // case_type
//   Course? courseInfo;          // course_info
//   RequestionModel? requestion; // كائن Requestion

//   TreatmentRequestModel({
//     this.sId,
//     this.patient,
//     this.caseType,
//     this.courseInfo,
//     this.requestion,
//   });

//   TreatmentRequestModel.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     patient = json['patient'] != null ? PatientModel.fromJson(json['patient']) : null;
//     caseType = json['case_type'] != null ? CaseType.fromJson(json['case_type']) : null;
//     courseInfo = json['course_info'] != null ? Course.fromJson(json['course_info']) : null;
//     requestion = json['Requestion'] != null ? RequestionModel.fromJson(json['Requestion']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (caseType != null) data['case_type'] = caseType!.toJson();
//     if (requestion!.painSeverity != null) data['pain_severity'] = requestion!.painSeverity;
//     if (requestion!.painTime != null) data['pain_time'] = requestion!.painTime;
//     if (requestion!.toothLocation != null) data['tooth_location'] = requestion!.toothLocation;
//     if (requestion!.gender != null) data['gender'] = requestion!.gender;
//     if (requestion!.isPregnant != null && requestion!.gender == "female") data['is_pregnant'] = requestion!.isPregnant;
//     if (requestion!.moreDetails != null) data['more_details'] = requestion!.moreDetails!.toJson();
//     if (requestion!.age != null) data['age'] = requestion!.age;
//     if (requestion!.photo != null) data['photo'] = requestion!.photo!.toJson();

//     return data;
//   }
// }

// // كائن المريض
// class PatientModel {
//   String? user;
//   String? firstName;
//   String? fatherName;
//   String? lastName;

//   PatientModel({this.user, this.firstName, this.fatherName, this.lastName});

//   PatientModel.fromJson(Map<String, dynamic> json) {
//     user = json['user'];
//     firstName = json['first_name'];
//     fatherName = json['father_name'];
//     lastName = json['last_name'];
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'user': user,
//       'first_name': firstName,
//       'father_name': fatherName,
//       'last_name': lastName,
//     };
//   }
// }

// // كائن Requestion (يحتوي على كل بيانات الطلب)
// class RequestionModel {
//   int? painSeverity;
//   String? painTime;
//   String? toothLocation;
//   String? gender;
//   bool? isPregnant;
//   MoreDetails? moreDetails;
//   String? age;
//   Photo? photo;
//   String? createdAt;
//   String? updatedAt;

//   RequestionModel({
//     this.painSeverity,
//     this.painTime,
//     this.toothLocation,
//     this.gender,
//     this.isPregnant,
//     this.moreDetails,
//     this.age,
//     this.photo,
//     this.createdAt,
//     this.updatedAt,
//   });

//   RequestionModel.fromJson(Map<String, dynamic> json) {
//     painSeverity = json['pain_severity'];
//     painTime = json['pain_time'];
//     toothLocation = json['tooth_location'];
//     gender = json['gender'];
//     isPregnant = json['is_pregnant'];
//     moreDetails = json['more_details'] != null ? MoreDetails.fromJson(json['more_details']) : null;
//     age = json['age'];
//     photo = json['photo'] != null ? Photo.fromJson(json['photo']) : null;
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['pain_severity'] = painSeverity;
//     data['pain_time'] = painTime;
//     data['tooth_location'] = toothLocation;
//     data['gender'] = gender;
//     // فقط إذا كان الجنس أنثى نضيف الحقل (كما في المنطق الأصلي)
//     if (gender != null && gender == "female") {
//       data['is_pregnant'] = isPregnant;
//     }
//     if (moreDetails != null) data['more_details'] = moreDetails!.toJson();
//     data['age'] = age;
//     if (photo != null) data['photo'] = photo!.toJson();
//     return data;
//   }
// }

// // الكلاسات المساعدة الأخرى (CaseType, Course, MoreDetails, Photo) تبقى كما هي
// // ولكن سأعيد كتابتها لتكون متوافقة مع الهيكل الجديد.

// class CaseType {
//   String? sId;
//   String? caseType;

//   CaseType({this.sId, this.caseType});

//   CaseType.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     caseType = json['case_type'];
//   }

//   String toJson() {
//     return sId ?? '';
//   }
// }

// class Course {
//   String? sId;
//   String? courseName;

//   Course({this.sId, this.courseName});

//   Course.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     courseName = json['course_name'];
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': sId,
//       'course_name': courseName,
//     };
//   }
// }

// // MoreDetails و Photo كما هما دون تعديل جوهري
// class MoreDetails {
//   String? medicines;
//   String? chronicDiseases;
//   bool? previousTreatment;
//   String? notes;

//   MoreDetails({this.medicines, this.chronicDiseases, this.previousTreatment, this.notes});

//   MoreDetails.fromJson(Map<String, dynamic> json) {
//     medicines = json['medicines'];
//     chronicDiseases = json['chronic_diseases'];
//     previousTreatment = json['previous_treatment'];
//     notes = json['notes'];
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'medicines': medicines,
//       'chronic_diseases': chronicDiseases,
//       'previous_treatment': previousTreatment,
//       'notes': notes,
//     };
//   }
// }

// class Photo {
//   String? publicId;
//   String? url;

//   Photo({this.publicId, this.url});

//   Photo.fromJson(Map<String, dynamic> json) {
//     publicId = json['publicId'];
//     url = json['url'];
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'publicId': publicId,
//       'url': url,
//     };
//   }
// }