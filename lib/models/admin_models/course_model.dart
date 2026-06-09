class CourseModel {
  String? sId;
  String? courseName;
  Categories? categories;
  Overseers? overseers;
  String? createdAt;
  String? updatedAt;
  int? iV;
  @override
  String toString() {
    return courseName ?? "اسم الكورس غير متوفر";
  }
  CourseModel(
      {this.sId,
      this.courseName,
      this.categories,
      this.overseers,
      this.createdAt,
      this.updatedAt,
      this.iV});

  CourseModel.fromJson(Map<String, dynamic> json) {
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
    // data['created_at'] = createdAt;
    // data['updated_at'] = updatedAt;
    // data['__v'] = iV;
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
  List<String>? category1;  // ✅ تحديد النوع كـ List<String>
  List<String>? category2;  // ✅ تحديد النوع كـ List<String>

  Overseers({this.category1, this.category2});

  Overseers.fromJson(Map<String, dynamic> json) {
    // ✅ التحويل الصحيح لـ category1
    if (json['category1'] != null && json['category1'] is List) {
      category1 = List<String>.from(json['category1'].map((v) => v.toString()));
    }
    
    // ✅ التحويل الصحيح لـ category2
    if (json['category2'] != null && json['category2'] is List) {
      category2 = List<String>.from(json['category2'].map((v) => v.toString()));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (category1 != null) {
      data['category1'] = category1;
    }
    if (category2 != null) {
      data['category2'] = category2;
    }
    return data;
  }
}