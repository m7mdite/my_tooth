class TreatmentRequestModel {
  // خصائص من TreatmentRequestProcessingSModel
  String? sId;
  Patient? patient;
  String? status;
  Requestion? requestion;
  Patient? overseer;
  Patient? student;
  String? dateOfAccepting;
  CaseType? caseType;
  List<StageEvaluation>? stageEvaluations;
  CourseInfo? courseInfo;
  
  // خصائص إضافية من PendingRequestModel
  Course? courseInfoAlt; // بديل courseInfo من PendingRequestModel
  String? caseTypeId; // لتخزين caseType كـ String فقط عند الحاجة

  TreatmentRequestModel({
    this.sId,
    this.patient,
    this.status,
    this.requestion,
    this.overseer,
    this.student,
    this.dateOfAccepting,
    this.caseType,
    this.stageEvaluations,
    this.courseInfo,
    this.courseInfoAlt,
    this.caseTypeId,
  });

  // Constructor لـ TreatmentRequestProcessingSModel
  TreatmentRequestModel.fromProcessingJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json.containsKey('patient')) {
      patient = Patient.fromJson(json['patient'] as Map<String, dynamic>);
    }
    status = json['status'];
    requestion = json['Requestion'] != null
        ? Requestion.fromJson(json['Requestion'])
        : null;
    overseer = json['overseer'] != null 
        ? Patient.fromJson(json['overseer']) 
        : null;
    student = json['student'] != null 
        ? Patient.fromJson(json['student']) 
        : null;
    dateOfAccepting = json['date_of_accepting'];
    caseType = json['case_type'] != null 
        ? CaseType.fromJson(json['case_type']) 
        : null;
    if (json['stage_evaluations'] != null) {
      stageEvaluations = <StageEvaluation>[];
      json['stage_evaluations'].forEach((v) {
        stageEvaluations!.add(StageEvaluation.fromJson(v));
      });
    }
    courseInfo = json['course_info'] != null
        ? CourseInfo.fromJson(json['course_info'])
        : null;
  }

  // Constructor لـ PendingRequestModel
  TreatmentRequestModel.fromPendingJson(Map<String, dynamic> json) {
    sId = json['_id'];
    patient = json['patient'] != null 
        ? Patient.fromJson(json['patient']) 
        : null;
    caseType = json['case_type'] != null 
        ? CaseType.fromJson(json['case_type']) 
        : null;
    courseInfoAlt = json['course_info'] != null 
        ? Course.fromJson(json['course_info']) 
        : null;
    requestion = json['Requestion'] != null 
        ? Requestion.fromJson(json['Requestion']) 
        : null;
    
    // إذا كان caseType موجود كـ String فقط في بعض الحالات
    if (json['case_type'] is String) {
      caseTypeId = json['case_type'];
    }
  }

  // toJson موحد مع دعم كلا النوعين
  Map<String, dynamic> toJson({bool isProcessing = true}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    
    if (isProcessing) {
      // toJson لـ TreatmentRequestProcessingSModel
      data['_id'] = sId;
      if (patient != null) data['patient'] = patient!.toJson();
      if (requestion != null) data['Requestion'] = requestion!.toJson();
      if (overseer != null) data['overseer'] = overseer!.toJson();
      data['date_of_accepting'] = dateOfAccepting;
      if (caseType != null) data['case_type'] = caseType!.toJson();
      if (stageEvaluations != null) {
        data['stage_evaluations'] = stageEvaluations!.map((v) => v.toJson()).toList();
      }
      if (courseInfo != null) data['course_info'] = courseInfo!.toJson();
    } else {
      // toJson لـ PendingRequestModel
      if (caseType != null) data['case_type'] = caseType!.toJson();
      if (requestion != null) {
        if (requestion!.painSeverity != null) {
          data['pain_severity'] = requestion!.painSeverity;
        }
        if (requestion!.painTime != null) {
          data['pain_time'] = requestion!.painTime;
        }
        if (requestion!.toothLocation != null) {
          data['tooth_location'] = requestion!.toothLocation;
        }
        if (requestion!.gender != null) {
          data['gender'] = requestion!.gender;
        }
        if (requestion!.gender == "female" && requestion!.isPregnant != null) {
          data['is_pregnant'] = requestion!.isPregnant;
        }
        if (requestion!.moreDetails != null) {
          data['more_details'] = requestion!.moreDetails!.toJson();
        }
        if (requestion!.age != null) {
          data['age'] = requestion!.age;
        }
        if (requestion!.photo != null) {
          data['photo'] = requestion!.photo!.toJson();
        }
      }
    }
    
    return data;
  }

  // Getters للوصول السهل للبيانات
  String? getPatientFullName() {
    if (patient != null) {
      return '${patient!.firstName ?? ''} ${patient!.fatherName ?? ''} ${patient!.lastName ?? ''}'.trim();
    }
    return null;
  }

  String? getCaseTypeName() {
    return caseType?.caseType ?? caseTypeId;
  }

  String? getCourseName() {
    return courseInfo?.courseName ?? courseInfoAlt?.courseName;
  }

  String? getCourseId() {
    return courseInfo?.sId ?? courseInfoAlt?.sId;
  }
}

// الكلاسات المساعدة المطلوبة (CaseType, Course, Patient, Requestion, MoreDetails, Photo, StageEvaluation, CourseInfo)

class Patient {
  String? user;
  String? firstName;
  String? fatherName;
  String? lastName;

  Patient({this.user, this.firstName, this.fatherName, this.lastName});

  Patient.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    firstName = json['first_name'];
    fatherName = json['father_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'first_name': firstName,
      'father_name': fatherName,
      'last_name': lastName,
    };
  }
}

class Requestion {
  int? painSeverity;
  String? painTime;
  String? toothLocation;
  String? gender;
  bool? isPregnant;
  MoreDetails? moreDetails;
  String? age;
  Photo? photo;
  String? createdAt;
  String? updatedAt;

  Requestion({
    this.painSeverity,
    this.painTime,
    this.toothLocation,
    this.gender,
    this.isPregnant,
    this.moreDetails,
    this.age,
    this.photo,
    this.createdAt,
    this.updatedAt,
  });

  Requestion.fromJson(Map<String, dynamic> json) {
    painSeverity = json['pain_severity'];
    painTime = json['pain_time'];
    toothLocation = json['tooth_location'];
    gender = json['gender'];
    isPregnant = json['is_pregnant'];
    moreDetails = json['more_details'] != null 
        ? MoreDetails.fromJson(json['more_details']) 
        : null;
    age = json['age'];
    photo = json['photo'] != null 
        ? Photo.fromJson(json['photo']) 
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pain_severity'] = painSeverity;
    data['pain_time'] = painTime;
    data['tooth_location'] = toothLocation;
    data['gender'] = gender;
    if (gender == "female") data['is_pregnant'] = isPregnant;
    if (moreDetails != null) data['more_details'] = moreDetails!.toJson();
    data['age'] = age;
    if (photo != null) data['photo'] = photo!.toJson();
    return data;
  }
}

class MoreDetails {
  String? medicines;
  String? chronicDiseases;
  bool? previousTreatment;
  String? notes;

  MoreDetails({
    this.medicines,
    this.chronicDiseases,
    this.previousTreatment,
    this.notes
  });

  MoreDetails.fromJson(Map<String, dynamic> json) {
    medicines = json['medicines'];
    chronicDiseases = json['chronic_diseases'];
    previousTreatment = json['previous_treatment'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    return {
      'medicines': medicines,
      'chronic_diseases': chronicDiseases,
      'previous_treatment': previousTreatment,
      'notes': notes,
    };
  }
}

class Photo {
  String? publicId;
  String? url;

  Photo({this.publicId, this.url});

  Photo.fromJson(Map<String, dynamic> json) {
    publicId = json['publicId'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    return {
      'publicId': publicId,
      'url': url,
    };
  }
}

class CaseType {
  String? sId;
  String? caseType;

  CaseType({this.sId, this.caseType});

  CaseType.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    caseType = json['case_type'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'case_type': caseType,
    };
  }
}

class CourseInfo {
  String? sId;
  String? courseName;

  CourseInfo({this.sId, this.courseName});

  CourseInfo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    courseName = json['course_name'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'course_name': courseName,
    };
  }
}

class Course {
  String? sId;
  String? courseName;

  Course({this.sId, this.courseName});

  Course.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    courseName = json['course_name'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'course_name': courseName,
    };
  }
}

class StageEvaluation {
  String? text;
  String? date;
  String? sId;

  StageEvaluation({this.text, this.date, this.sId});

  StageEvaluation.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    date = json['date'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'date': date,
      '_id': sId,
    };
  }
}