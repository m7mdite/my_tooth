class TreatmentModel {
  CaseType? caseType;
  CourseInfo? courseInfo;

  TreatmentModel({this.caseType, this.courseInfo});

  TreatmentModel.fromJson(Map<String, dynamic> json) {
    caseType = json['case_type'] != null
        ? CaseType.fromJson(json['case_type'])
        : null;
    courseInfo = json['course_info'] != null
        ? CourseInfo.fromJson(json['course_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (caseType != null) {
      data['case_type'] = caseType!.toJson();
    }
    if (courseInfo != null) {
      data['course_info'] = courseInfo!.toJson();
    }
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