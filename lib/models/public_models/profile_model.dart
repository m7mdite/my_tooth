class ProfileModel {
  String? user;
  String? firstName;
  String? fatherName;
  String? lastName;
  String? bio;
  String? email;
  ProfilePhoto? profilePhoto;
  String? gender;
  String? phoneNumber;
  String? role;
  Category? category;
  String? universityNumber;
  bool? isVerified;
  int? countCasesFinishds;
  int? countCasesInProcess;

  ProfileModel(
      {this.user,
      this.firstName,
      this.fatherName,
      this.lastName,
      this.bio,
      this.profilePhoto,
      this.gender,
      this.role,
      this.category,
      this.universityNumber,
      this.isVerified,
      this.countCasesFinishds,
      this.email,
      this.phoneNumber,
      this.countCasesInProcess});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    firstName = json['first_name'];
    fatherName = json['father_name'];
    lastName = json['last_name'];
    email = json['email']??'noemail@gmail.com';
    bio = json['bio'];
    profilePhoto = json['profile_photo'] != null
        ? ProfilePhoto.fromJson(json['profile_photo'])
        : null;
    gender = json['gender'];
    phoneNumber =json['phone_number']??"+963957863599";
    role = json['role'];
    category = json['category'] != null
        ? Category.fromJson(json['category'])
        : null;
    universityNumber = json['university_number'];
    isVerified = json['is_verified'];
    countCasesFinishds = json['count_cases_finishds'];
    countCasesInProcess = json['count_cases_in_process'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    
    if(data['first_name']!=null) data['first_name'] = firstName;
    if(data['father_name']!=null)data['father_name'] = fatherName;
    if(data['last_name']!=null)data['last_name'] = lastName;
    if(data['bio']!=null)data['bio'] = bio;
    if (profilePhoto != null) {
      data['profile_photo'] = profilePhoto!.toJson();
    }
    if(data['gender']!=null)data['gender'] = gender;
    if(data['role']!=null)data['role'] = role;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if(data['university_number']!=null)data['university_number'] = universityNumber;
    if(data['is_verified']!=null)data['is_verified'] = isVerified;
    if(data['count_cases_finishds']!=null)data['count_cases_finishds'] = countCasesFinishds;
    if(data['count_cases_in_process']!=null)data['count_cases_in_process'] = countCasesInProcess;
    if(data['phone_number']!=null)data['phone_number'] = phoneNumber;
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

class Category {
  String? sId;
  String? category;

  Category({this.sId, this.category});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['_id'] = sId;
    data['category'] = category;
    return data;
  }
}