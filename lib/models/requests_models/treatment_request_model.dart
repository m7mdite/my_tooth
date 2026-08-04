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
  int? rating; // إضافة خاصية التقييم

  // خصائص إضافية من PendingRequestModel
  Course? courseInfoAlt;
  String? caseTypeId;

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
    this.rating, // إضافة خاصية التقييم
  });

  // fromJson موحد يتعامل مع كلا النوعين
  factory TreatmentRequestModel.fromJson(Map<String, dynamic> json) {
    // التحقق من وجود stage_evaluations لتحديد النوع
    final hasStageEvaluations = json.containsKey('stage_evaluations');

    return TreatmentRequestModel(
      sId: json['_id'],
      rating: json['rating'], // إضافة خاصية التقييم
      // patient - موجود في كلا النوعين
      patient: json['patient'] != null
          ? Patient.fromJson(json['patient'] as Map<String, dynamic>)
          : null,

      // status - فقط في TreatmentRequestProcessingSModel
      status: json['status'],

      // requestion - موجود في كلا النوعين
      requestion: json['Requestion'] != null
          ? Requestion.fromJson(json['Requestion'])
          : null,

      // overseer - فقط في TreatmentRequestProcessingSModel
      overseer:
          json['overseer'] != null ? Patient.fromJson(json['overseer']) : null,

      // student - فقط في TreatmentRequestProcessingSModel
      student:
          json['student'] != null ? Patient.fromJson(json['student']) : null,

      // dateOfAccepting - فقط في TreatmentRequestProcessingSModel
      dateOfAccepting: json['date_of_accepting'],

      // caseType - موجود في كلا النوعين لكن بشكل مختلف
      caseType: json['case_type'] != null && json['case_type'] is Map
          ? CaseType.fromJson(json['case_type'])
          : null,

      // stageEvaluations - فقط في TreatmentRequestProcessingSModel
      stageEvaluations: json['stage_evaluations'] != null
          ? (json['stage_evaluations'] as List)
              .map((v) => StageEvaluation.fromJson(v))
              .toList()
          : null,

      // courseInfo - فقط في TreatmentRequestProcessingSModel
      courseInfo: json['course_info'] != null && json['course_info'] is Map
          ? CourseInfo.fromJson(json['course_info'])
          : null,

      // courseInfoAlt - فقط في PendingRequestModel
      courseInfoAlt: json['course_info'] != null && json['course_info'] is Map
          ? Course.fromJson(json['course_info'])
          : null,

      // caseTypeId - إذا كان case_type عبارة عن String فقط (في PendingRequestModel)
      caseTypeId: json['case_type'] is String ? json['case_type'] : null,
    );
  }

  @override
String toString() {
  return 'TreatmentRequestModel(\n'
      '  sId: $sId,\n'
      '  patient: ${patient != null ? patient!.toJson() : 'null'},\n'
      '  status: $status,\n'
      '  requestion: ${requestion != null ? requestion!.toJson() : 'null'},\n'
      '  overseer: ${overseer != null ? overseer!.toJson() : 'null'},\n'
      '  student: ${student != null ? student!.toJson() : 'null'},\n'
      '  dateOfAccepting: $dateOfAccepting,\n'
      '  caseType: ${caseType != null ? caseType!.toJson() : caseTypeId},\n'
      '  stageEvaluations: ${stageEvaluations != null ? stageEvaluations!.map((v) => v.toJson()).toList() : 'null'},\n'
      '  courseInfo: ${courseInfo != null ? courseInfo!.toJson() : 'null'},\n'
      '  courseInfoAlt: ${courseInfoAlt != null ? courseInfoAlt!.toJson() : 'null'},\n'
      '  caseTypeId: $caseTypeId,\n'
      '  rating: $rating,\n'
      ')';
}

  // toJson موحد
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};

  //   data['_id'] = sId;

  //   if (patient != null) {
  //     data['patient'] = patient!.toJson();
  //   }

  //   if (status != null) {
  //     data['status'] = status;
  //   }

  //   if (requestion != null) {
  //     data['Requestion'] = requestion!.toJson();
  //   }

  //   if (overseer != null) {
  //     data['overseer'] = overseer!.toJson();
  //   }

  //   if (student != null) {
  //     data['student'] = student!.toJson();
  //   }

  //   if (dateOfAccepting != null) {
  //     data['date_of_accepting'] = dateOfAccepting;
  //   }

  //   // handling caseType - إذا كان موجود كـ CaseType نستخدم toJson
  //   if (caseType != null) {
  //     data['case_type'] = caseType!.toJson();
  //   } else if (caseTypeId != null) {
  //     // إذا كان مجرد String نضيفه مباشرة
  //     data['case_type'] = caseTypeId;
  //   }

  //   if (stageEvaluations != null && stageEvaluations!.isNotEmpty) {
  //     data['stage_evaluations'] =
  //         stageEvaluations!.map((v) => v.toJson()).toList();
  //   }

  //   // courseInfo priority: courseInfo > courseInfoAlt
  //   if (courseInfo != null) {
  //     data['course_info'] = courseInfo!.toJson();
  //   } else if (courseInfoAlt != null) {
  //     data['course_info'] = courseInfoAlt!.toJson();
  //   }

  //   return data;
  // }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (caseType != null) data['case_type'] = caseType!.toJson();
    if (requestion!.painSeverity != null) data['pain_severity'] = requestion!.painSeverity;
    if (requestion!.painTime != null) data['pain_time'] = requestion!.painTime;
    if (requestion!.toothLocation != null) data['tooth_location'] = requestion!.toothLocation;
    if (requestion!.gender != null) data['gender'] = requestion!.gender;
    if (requestion!.isPregnant != null && requestion!.gender == "female") data['is_pregnant'] = requestion!.isPregnant;
    if (requestion!.chronicDiseases != null) data['chronic_diseases'] = requestion!.chronicDiseases;
    if (requestion!.medicines != null) data['medicines'] = requestion!.medicines;
    if (requestion!.previousTreatment != null) data['previous_treatment'] = requestion!.previousTreatment;
    if (requestion!.notes != null) data['notes'] = requestion!.notes;
    if (requestion!.age != null) data['age'] = requestion!.age;
    if (requestion!.photo != null) data['photo'] = requestion!.photo!.toJson();

    return data;
  }

  // Getters للوصول السهل
  String? getPatientFullName() {
    if (patient != null) {
      final parts = [patient!.firstName, patient!.fatherName, patient!.lastName]
          .where((part) => part != null && part!.isNotEmpty)
          .join(' ');
      return parts.isNotEmpty ? parts : null;
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

  bool isProcessingRequest() {
    return status != null || stageEvaluations != null;
  }
}

// باقي الكلاسات المساعدة كما هي...

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user;
    data['first_name'] = firstName;
    data['father_name'] = fatherName;
    data['last_name'] = lastName;
    return data;
  }
}

class Requestion {
  int? painSeverity;
  String? painTime;
  String? toothLocation;
  String? gender;
  bool? isPregnant;
  String? age;
  Photo? photo;
  String? medicines;
  String? chronicDiseases;
  bool? previousTreatment;
  String? notes;
  String? createdAt;
  String? updatedAt;

  Requestion({
    this.painSeverity,
    this.painTime,
    this.toothLocation,
    this.gender,
    this.isPregnant,
    this.age,
    this.photo,
    this.medicines,
    this.chronicDiseases,
    this.previousTreatment,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  Requestion.fromJson(Map<String, dynamic> json) {
    painSeverity = json['pain_severity'];
    painTime = json['pain_time'];
    toothLocation = json['tooth_location'];
    gender = json['gender'];
    isPregnant = json['is_pregnant'];

    age = json['age'];
    photo = json['photo'] != null ? Photo.fromJson(json['photo']) : null;
    medicines = json['medicines'];
    chronicDiseases = json['chronic_diseases'];
    previousTreatment = json['previous_treatment'];
    notes = json['notes'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pain_severity'] = painSeverity;
    data['pain_time'] = painTime;
    data['tooth_location'] = toothLocation;
    data['gender'] = gender;
    if (gender == "female") {
      data['is_pregnant'] = isPregnant;
    }

    data['age'] = age;
    if (photo != null) {
      data['photo'] = photo!.toJson();
    }
    if (medicines != null) data['medicines'] = medicines;
    if (chronicDiseases != null) data['chronic_diseases'] = chronicDiseases;
    data['previous_treatment'] = previousTreatment;
    if (notes != null) data['notes'] = notes;
    return data;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['publicId'] = publicId;
    data['url'] = url;
    return data;
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

  String toJson() {
    
    return sId??"";
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['course_name'] = courseName;
    return data;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['course_name'] = courseName;
    return data;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['date'] = date;
    data['_id'] = sId;
    return data;
  }
}
