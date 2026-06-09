class TreatmentRequestProcessingSModel {
  String? sId;
  Patient? patient;
  Requestion? requestion;
  Patient? overseer;
  Patient? student;
  String? dateOfAccepting;
  CaseType? caseType;
  List<StageEvaluation>? stageEvaluations;
  CourseInfo? courseInfo;

  TreatmentRequestProcessingSModel(
      {this.sId,
      this.patient,
      this.requestion,
      this.overseer,
      this.student,
      this.dateOfAccepting,
      this.caseType,
      this.stageEvaluations,
      this.courseInfo});

  TreatmentRequestProcessingSModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json.containsKey('patient')) patient = Patient.fromJson(json['patient'] as Map<String, dynamic>);
    requestion = json['Requestion'] != null
        ? Requestion.fromJson(json['Requestion'])
        : null;
    overseer =
        json['overseer'] != null ? Patient.fromJson(json['overseer']) : null;
    student =
        json['student'] != null ? Patient.fromJson(json['student']) : null;
    dateOfAccepting = json['date_of_accepting'];
    caseType =
        json['case_type'] != null ? CaseType.fromJson(json['case_type']) : null;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (patient != null) {
      data['patient'] = patient!.toJson();
    }
    if (requestion != null) {
      data['Requestion'] = requestion!.toJson();
    }
    if (overseer != null) {
      data['overseer'] = overseer!.toJson();
    }
    data['date_of_accepting'] = dateOfAccepting;
    if (caseType != null) {
      data['case_type'] = caseType!.toJson();
    }
    if (stageEvaluations != null) {
      data['stage_evaluations'] =
          stageEvaluations!.map((v) => v.toJson()).toList();
    }
    if (courseInfo != null) {
      data['course_info'] = courseInfo!.toJson();
    }
    return data;
  }
}

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
  MoreDetails? moreDetails;
  String? age;
  Photo? photo;

  Requestion(
      {this.painSeverity,
      this.painTime,
      this.toothLocation,
      this.gender,
      this.moreDetails,
      this.age,
      this.photo});

  Requestion.fromJson(Map<String, dynamic> json) {
    painSeverity = json['pain_severity'];
    painTime = json['pain_time'];
    toothLocation = json['tooth_location'];
    gender = json['gender'];
    moreDetails = json['more_details'] != null
        ? MoreDetails.fromJson(json['more_details'])
        : null;
    age = json['age'];
    photo = json['photo'] != null ? Photo.fromJson(json['photo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pain_severity'] = painSeverity;
    data['pain_time'] = painTime;
    data['tooth_location'] = toothLocation;
    data['gender'] = gender;
    if (moreDetails != null) {
      data['more_details'] = moreDetails!.toJson();
    }
    data['age'] = age;
    if (photo != null) {
      data['photo'] = photo!.toJson();
    }
    return data;
  }
}

class MoreDetails {
  String? medicines;
  String? chronicDiseases;
  bool? previousTreatment;
  String? notes;

  MoreDetails(
      {this.medicines,
      this.chronicDiseases,
      this.previousTreatment,
      this.notes});

  MoreDetails.fromJson(Map<String, dynamic> json) {
    medicines = json['medicines'];
    chronicDiseases = json['chronic_diseases'];
    previousTreatment = json['previous_treatment'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['medicines'] = medicines;
    data['chronic_diseases'] = chronicDiseases;
    data['previous_treatment'] = previousTreatment;
    data['notes'] = notes;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['case_type'] = caseType;
    return data;
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

// class TreatmentRequestProcessingSModel {
//   String? sId;
//   Patient? patient;
//   Requestion? requestion;
//   Patient? overseer;
//   Patient? student;
//   String? dateOfAccepting;
//   String? caseType;
//   String? caseTypeTitle;
//   String? courseId;
//   String? courseName;
//   OverseerNote? overseerNote;
//   List<StageEvaluation>? stageEvaluation;

//   TreatmentRequestProcessingSModel(
//       {this.sId,
//       this.patient,
//       this.requestion,
//       this.overseer,
//       this.student,
//       this.dateOfAccepting,
//       this.caseType,
//       this.caseTypeTitle,
//       this.courseId,
//       this.courseName,
//       this.overseerNote,
//       this.stageEvaluation});

//   TreatmentRequestProcessingSModel.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     patient =
//         json['patient'] != null ? Patient.fromJson(json['patient']) : null;
//     requestion = json['Requestion'] != null
//         ? Requestion.fromJson(json['Requestion'])
//         : null;
//     overseer = json['overseer'] != null
//         ? Patient.fromJson(json['overseer'])
//         : null;
//     student = json['student'] != null
//         ? Patient.fromJson(json['student'])
//         : null;
//     dateOfAccepting = json['date_of_accepting'];
//     caseType = json['case_type'];
//     caseTypeTitle = json['case_type_title'];
//     courseId = json['course_id'];
//     courseName = json['course_name'];
//     overseerNote = json['overseer_note'] != null
//         ? OverseerNote.fromJson(json['overseer_note'])
//         : null;
//     if (json['stage_evaluations'] != null) {
//       stageEvaluation = <StageEvaluation>[];
//       json['stage_evaluations'].forEach((v) {
//         stageEvaluation!.add( StageEvaluation.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['_id'] = sId;
//     if (patient != null) {
//       data['patient'] = patient!.toJson();
//     }
//     if (requestion != null) {
//       data['Requestion'] = requestion!.toJson();
//     }
//     if (overseer != null) {
//       data['overseer'] = overseer!.toJson();
//     }
//     data['date_of_accepting'] = dateOfAccepting;
//     data['case_type'] = caseType;
//     data['case_type_title'] = caseTypeTitle;
//     data['course_id'] = courseId;
//     data['course_name'] = courseName;
//     return data;
//   }
// }

// class Patient {
//   String? user;
//   String? firstName;
//   String? fatherName;
//   String? lastName;

//   Patient({this.user, this.firstName, this.fatherName, this.lastName});

//   Patient.fromJson(Map<String, dynamic> json) {
//     user = json['user'];
//     firstName = json['first_name'];
//     fatherName = json['father_name'];
//     lastName = json['last_name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['user'] = user;
//     data['first_name'] = firstName;
//     data['father_name'] = fatherName;
//     data['last_name'] = lastName;
//     return data;
//   }
// }

// class Requestion {
//   String? sId;
//   int? painSeverity;
//   String? painTime;
//   String? toothLocation;
//   String? gender;
//   bool? isPregnant;
//   MoreDetails? moreDetails;
//   String? age;
//   Photo? photo;

//   Requestion(
//       {this.sId,
//       this.painSeverity,
//       this.painTime,
//       this.toothLocation,
//       this.gender,
//       this.isPregnant,
//       this.moreDetails,
//       this.age,
//       this.photo});

//   Requestion.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     painSeverity = json['pain_severity'];
//     painTime = json['pain_time'];
//     toothLocation = json['tooth_location'];
//     gender = json['gender'];
//     isPregnant = json['is_pregnant'];
//     moreDetails = json['more_details'] != null
//         ? MoreDetails.fromJson(json['more_details'])
//         : null;
//     age = json['age'];
//     photo = json['photo'] != null ? Photo.fromJson(json['photo']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['_id'] = sId;
//     data['pain_severity'] = painSeverity;
//     data['pain_time'] = painTime;
//     data['tooth_location'] = toothLocation;
//     data['gender'] = gender;
//     data['is_pregnant'] = isPregnant;
//     if (moreDetails != null) {
//       data['more_details'] = moreDetails!.toJson();
//     }
//     data['age'] = age;
//     if (photo != null) {
//       data['photo'] = photo!.toJson();
//     }
//     return data;
//   }
// }

// class MoreDetails {
//   String? medicines;
//   String? chronicDiseases;
//   bool? previousTreatment;
//   String? notes;

//   MoreDetails(
//       {this.medicines,
//       this.chronicDiseases,
//       this.previousTreatment,
//       this.notes});

//   MoreDetails.fromJson(Map<String, dynamic> json) {
//     medicines = json['medicines'];
//     chronicDiseases = json['chronic_diseases'];
//     previousTreatment = json['previous_treatment'];
//     notes = json['notes'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['medicines'] = medicines;
//     data['chronic_diseases'] = chronicDiseases;
//     data['previous_treatment'] = previousTreatment;
//     data['notes'] = notes;
//     return data;
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
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['publicId'] = publicId;
//     data['url'] = url;
//     return data;
//   }
// }

// class OverseerNote {
//   String? overseer;
//   String? note;
//   String? rejectedAt;

//   OverseerNote({this.overseer, this.note, this.rejectedAt});

//   OverseerNote.fromJson(Map<String, dynamic> json) {
//     overseer = json['overseer'];
//     note = json['note'];
//     rejectedAt = json['rejectedAt'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  <String, dynamic>{};
//     data['overseer'] = overseer;
//     data['note'] = note;
//     data['rejectedAt'] = rejectedAt;
//     return data;
//   }
// }
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
