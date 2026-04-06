class TreatmentModel {
  String? sId;
  String? treatmentCase;
  Course? course;
  int? iV;

  TreatmentModel({this.sId, this.treatmentCase, this.course, this.iV});

  TreatmentModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    treatmentCase = json['treatment_case'];
    course =
        json['course'] != null ? Course.fromJson(json['course']) : null;
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['treatment_case'] = treatmentCase;
    if (course != null) {
      data['course'] = course!.toJson();
    }
    data['__v'] = iV;
    return data;
  }
}

class Course {
  String? sId;
  String? courseName;
  Categories? categories;
  Overseers? overseers;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Course(
      {this.sId,
      this.courseName,
      this.categories,
      this.overseers,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Course.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    courseName = json['course_name'];
    categories = json['categories'] != null
        ? Categories.fromJson(json['categories'])
        : null;
    overseers = json['overseers'] != null
        ? Overseers.fromJson(json['overseers'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['course_name'] = courseName;
    if (categories != null) {
      data['categories'] = categories!.toJson();
    }
    if (overseers != null) {
      data['overseers'] = overseers!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Categories {
  String? category1;
  String? category2;

  Categories({this.category1, this.category2});

  Categories.fromJson(Map<String, dynamic> json) {
    category1 = json['category1'];
    category2 = json['category2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category1'] = category1;
    data['category2'] = category2;
    return data;
  }
}

class Overseers {
  List<String>? category1;
  List<String>? category2;

  Overseers({this.category1, this.category2});

  Overseers.fromJson(Map<String, dynamic> json) {
    if (json['category1'] != null) {
      category1 = <String>[];
      json['category1'].forEach((v) {
        category1!.add(v.toString());
      });
    }
    if (json['category2'] != null) {
      category2 = <String>[];
      json['category2'].forEach((v) {
        category2!.add(v.toString());
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (category1 != null) {
      data['category1'] = category1!.map((v) => v.toString()).toList();
    }
    if (category2 != null) {
      data['category2'] = category2!.map((v) => v.toString()).toList();
    }
    return data;
  }
}