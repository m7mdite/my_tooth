import 'package:get_storage/get_storage.dart';

class AuthService {
  final _box = GetStorage();
  
  // بادئة للمفاتيح (اختياري للتنظيم)
  static const String _prefix = 'profile_';
  static const String _tokenKey = 'token';
  static const String _roleKey = 'role';
  
  // ============ حفظ كل حقل على حدة ============
  
  // حفظ المعرف
  Future<void> saveId(String id) async {
    await _box.write('${_prefix}id', id);
  }
  
  String? getId() {
    return _box.read('${_prefix}id');
  }
  
  // حفظ رقم الجوال
  Future<void> savePhoneNumber(String phoneNumber) async {
    await _box.write('${_prefix}phone_number', phoneNumber);
  }
  
  Future<void> saveIsVerified(bool isVerified) async {
    await _box.write('${_prefix}is_verified', isVerified);
  }
  bool isVerified() {
    return _box.read('${_prefix}is_verified') ?? false;
  }
  String? getPhoneNumber() {
    return _box.read('${_prefix}phone_number');
  }
  
  // حفظ البريد الإلكتروني
  Future<void> saveEmail(String email) async {
    await _box.write('${_prefix}email', email);
  }
  
  String? getEmail() {
    return _box.read('${_prefix}email');
  }
  
  // حفظ user ID
  Future<void> saveUserId(String userId) async {
    await _box.write('${_prefix}user_id', userId);
  }
  
  String? getUserId() {
    return _box.read('${_prefix}user_id');
  }
  
  // حفظ الرقم الجامعي
  Future<void> saveUniversityNumber(String universityNumber) async {
    await _box.write('${_prefix}university_number', universityNumber);
  }
  
  String? getUniversityNumber() {
    return _box.read('${_prefix}university_number');
  }
  
  // حفظ الاسم الأول
  Future<void> saveFirstName(String firstName) async {
    await _box.write('${_prefix}first_name', firstName);
  }
  
  String? getFirstName() {
    return _box.read('${_prefix}first_name');
  }
  
  // حفظ اسم الأب
  Future<void> saveFatherName(String fatherName) async {
    await _box.write('${_prefix}father_name', fatherName);
  }
  
  String? getFatherName() {
    return _box.read('${_prefix}father_name');
  }
  
  // حفظ الاسم الأخير
  Future<void> saveLastName(String lastName) async {
    await _box.write('${_prefix}last_name', lastName);
  }
  
  String? getLastName() {
    return _box.read('${_prefix}last_name');
  }
  
  // حفظ السيرة الذاتية
  Future<void> saveBio(String bio) async {
    await _box.write('${_prefix}bio', bio);
  }
  
  String? getBio() {
    return _box.read('${_prefix}bio');
  }
  
  // حفظ العمر
  Future<void> saveAge(String age) async {
    await _box.write('${_prefix}age', age);
  }
  
  String? getAge() {
    return _box.read('${_prefix}age');
  }
  
  // حفظ الجنس
  Future<void> saveGender(String gender) async {
    await _box.write('${_prefix}gender', gender);
  }
  
  String? getGender() {
    return _box.read('${_prefix}gender');
  }
  
  // حفظ صورة البروفايل (publicId)
  Future<void> saveProfilePhotoPublicId(String? publicId) async {
    await _box.write('${_prefix}photo_public_id', publicId);
  }
  
  String? getProfilePhotoPublicId() {
    return _box.read('${_prefix}photo_public_id');
  }
  
  // حفظ صورة البروفايل (url)
  Future<void> saveProfilePhotoUrl(String? url) async {
    await _box.write('${_prefix}photo_url', url);
  }
  
  String? getProfilePhotoUrl() {
    return _box.read('${_prefix}photo_url');
  }
  
  // حفظ صورة البروفايل (مسار كامل)
  Future<void> saveProfilePicture(String url) async {
    await _box.write('${_prefix}profile_picture', url);
  }
  
  String? getProfilePicture() {
    return _box.read('${_prefix}profile_picture');
  }
  
  // حفظ التوكن
  Future<void> saveToken(String token) async {
    await _box.write(_tokenKey, token);
  }
  
  String? getToken() {
    return _box.read(_tokenKey);
  }
  
  // حفظ الدور
  Future<void> saveRole(String role) async {
    await _box.write(_roleKey, role);
  }
  
  String? getRole() {
    return _box.read(_roleKey);
  }
  
  // حفظ __v
  Future<void> saveV(int v) async {
    await _box.write('${_prefix}v', v);
  }
  
  int? getV() {
    return _box.read('${_prefix}v');
  }
  
  // ============ دوال مساعدة ============
  
  // الحصول على الاسم الكامل
  String getFullName() {
    final firstName = getFirstName() ?? '';
    final fatherName = getFatherName() ?? '';
    final lastName = getLastName() ?? '';
    
    return [firstName, fatherName, lastName]
        .where((name) => name.isNotEmpty)
        .join(' ');
  }
  
  // حفظ كل البيانات من JSON مرة واحدة
  Future<void> saveAllFromJson(Map<String, dynamic> json) async {
    try {
      // حفظ البيانات الأساسية
      if (json['_id'] != null) await saveId(json['_id']);
      if (json['user'] != null) await saveUserId(json['user']);
      if (json['university_number'] != null) await saveUniversityNumber(json['university_number']);
      if (json['first_name'] != null) await saveFirstName(json['first_name']);
      if (json['father_name'] != null) await saveFatherName(json['father_name']);
      if (json['last_name'] != null) await saveLastName(json['last_name']);
      if (json['email'] != null) await saveEmail(json['email']);
      if (json['bio'] != null) await saveBio(json['bio']);
      if (json['gender'] != null) await saveGender(json['gender']);
      if (json['age'] != null) await saveAge(json['age'].toString());
      if (json['phone_number'] != null) await savePhoneNumber(json['phone_number']);
      if (json['__v'] != null) await saveV(json['__v']);
      
      // حفظ بيانات الصورة
      if (json['profile_photo'] != null) {
        final photo = json['profile_photo'];
        if (photo is Map<String, dynamic>) {
          await saveProfilePhotoPublicId(photo['publicId']);
          await saveProfilePhotoUrl(photo['url']);
          // حفظ المسار الكامل للصورة
          if (photo['url'] != null) {
            await saveProfilePicture(photo['url']);
          }
        } else if (photo is String) {
          // إذا كانت الصورة مجرد مسار
          await saveProfilePicture(photo);
        }
      }
      
      // حفظ التوكن إذا كان موجوداً
      if (json['token'] != null) {
        await saveToken(json['token']);
      }
      
      // حفظ الدور إذا كان موجوداً
      if (json['role'] != null) {
        await saveRole(json['role']);
      }
      
      print('All data saved to local storage successfully');
    } catch (e) {
      print('Error saving data to local storage: $e');
      rethrow;
    }
  }
  
  // الحصول على كل البيانات كـ Map
  Map<String, dynamic> getAllAsJson() {
    return {
      '_id': getId(),
      'user': getUserId(),
      'university_number': getUniversityNumber(),
      'first_name': getFirstName(),
      'father_name': getFatherName(),
      'email': getEmail(),
      'last_name': getLastName(),
      'bio': getBio(),
      'age': getAge(),
      'phone_number': getPhoneNumber(),
      'profile_photo': {
        'publicId': getProfilePhotoPublicId(),
        'url': getProfilePhotoUrl(),
      },
      'profile_picture': getProfilePicture(),
      'gender': getGender(),
      '__v': getV(),
      'token': getToken(),
      'role': getRole(),
    };
  }
  
  // التحقق من وجود بيانات
  bool hasData() {
    return getId() != null || getUserId() != null;
  }
  
  // التحقق من وجود توكن
  bool hasToken() {
    return getToken() != null && getToken()!.isNotEmpty;
  }
  
  // مسح حقل محدد
  Future<void> removeField(String field) async {
    await _box.remove('$_prefix$field');
  }
  
  // مسح كل البيانات
  Future<void> clearAll() async {
    await _box.erase();
  }
  
  // مسح بيانات البروفايل فقط (بدون مسح التوكن والدور)
  Future<void> clearProfileData() async {
    final keys = [
      '${_prefix}id',
      '${_prefix}user_id',
      '${_prefix}university_number',
      '${_prefix}first_name',
      '${_prefix}father_name',
      '${_prefix}last_name',
      '${_prefix}email',
      '${_prefix}phone_number',
      '${_prefix}bio',
      '${_prefix}age',
      '${_prefix}photo_public_id',
      '${_prefix}photo_url',
      '${_prefix}profile_picture',
      '${_prefix}gender',
      '${_prefix}v',
    ];
    
    for (var key in keys) {
      await _box.remove(key);
    }
  }
  
  // مسح كل بيانات المستخدم (بما فيها التوكن)
  Future<void> clearUserData() async {
    await clearProfileData();
    await _box.remove(_tokenKey);
    await _box.remove(_roleKey);
  }
  
  // الحصول على عدد الحقول المحفوظة
  int getStoredFieldsCount() {
    int count = 0;
    if (getId() != null) count++;
    if (getUserId() != null) count++;
    if (getUniversityNumber() != null) count++;
    if (getFirstName() != null) count++;
    if (getFatherName() != null) count++;
    if (getLastName() != null) count++;
    if (getEmail() != null) count++;
    if (getPhoneNumber() != null) count++;
    if (getBio() != null) count++;
    if (getAge() != null) count++;
    if (getProfilePhotoPublicId() != null) count++;
    if (getProfilePhotoUrl() != null) count++;
    if (getProfilePicture() != null) count++;
    if (getGender() != null) count++;
    if (getV() != null) count++;
    if (getToken() != null) count++;
    if (getRole() != null) count++;
    return count;
  }
  
  // تحديث حقل واحد فقط
  Future<void> updateField(String field, dynamic value) async {
    await _box.write('$_prefix$field', value);
  }
  
  // التحقق من وجود حقل معين
  bool hasField(String field) {
    return _box.hasData('$_prefix$field');
  }
  
  // الحصول على قيمة حقل معين
  dynamic getField(String field) {
    return _box.read('$_prefix$field');
  }
}

// import 'package:get_storage/get_storage.dart';

// class AuthService {
//   final _box = GetStorage();
  
//   // بادئة للمفاتيح (اختياري للتنظيم)
//   static const String _prefix = 'profile_';
  
//   // ============ حفظ كل حقل على حدة ============
  
//   // حفظ المعرف
//   Future<void> saveId(String id) async {
//     await _box.write('${_prefix}id', id);
//   }
  
//   String? getId() {
//     return _box.read('${_prefix}id');
//   }
//   String getFullName() {
//     final firstName = getFirstName() ?? '';
//     final fatherName = getFatherName() ?? '';
//     final lastName = getLastName() ?? '';
    
//     return [firstName, fatherName, lastName]
//         .where((name) => name.isNotEmpty)
//         .join(' ');
//   }
//   getPhoneNumber() {
//     return _box.read('${_prefix}phone_number');
//   }
//   Future<void> savePhoneNumber(String phoneNumber) async {
//     await _box.write('${_prefix}phone_number', phoneNumber);
//   }
//   // حفظ user ID
//   Future<void> saveUserId(String userId) async {
//     await _box.write('${_prefix}user_id', userId);
//   }
  
//   String? getUserId() {
//     return _box.read('${_prefix}user_id');
//   }
  
//   // حفظ الرقم الجامعي
//   Future<void> saveUniversityNumber(String universityNumber) async {
//     await _box.write('${_prefix}university_number', universityNumber);
//   }
  
//   String? getUniversityNumber() {
//     return _box.read('${_prefix}university_number');
//   }
  
//   // حفظ الاسم الأول
//   Future<void> saveFirstName(String firstName) async {
//     await _box.write('${_prefix}first_name', firstName);
//   }
  
//   String? getFirstName() {
//     return _box.read('${_prefix}first_name');
//   }
//   Future<void> saveEmail(String email) async {
//     await _box.write('${_prefix}email', email);
//   }
  
//   String? getEmail() {
//     return _box.read('${_prefix}email');
//   }
  
//   // حفظ اسم الأب
//   Future<void> saveFatherName(String fatherName) async {
//     await _box.write('${_prefix}father_name', fatherName);
//   }
  
//   String? getFatherName() {
//     return _box.read('${_prefix}father_name');
//   }
  
//   // حفظ الاسم الأخير
//   Future<void> saveLastName(String lastName) async {
//     await _box.write('${_prefix}last_name', lastName);
//   }
  
//   String? getLastName() {
//     return _box.read('${_prefix}last_name');
//   }
  
//   // حفظ السيرة الذاتية
//   Future<void> saveBio(String bio) async {
//     await _box.write('${_prefix}bio', bio);
//   }
  
//   String? getBio() {
//     return _box.read('${_prefix}bio');
//   }
  
//   // حفظ صورة البروفايل (publicId)
//   Future<void> saveProfilePhotoPublicId(String? publicId) async {
//     await _box.write('${_prefix}photo_public_id', publicId);
//   }
  
//   String? getProfilePhotoPublicId() {
//     return _box.read('${_prefix}photo_public_id');
//   }
  
//   // حفظ صورة البروفايل (url)
//   Future<void> saveProfilePhotoUrl(String? url) async {
//     await _box.write('${_prefix}photo_url', url);
//   }
  
//   String? getProfilePhotoUrl() {
//     return _box.read('${_prefix}photo_url');
//   }
  
//   // حفظ الجنس
//   Future<void> saveGender(String gender) async {
//     await _box.write('${_prefix}gender', gender);
//   }
  
//   String? getGender() {
//     return _box.read('${_prefix}gender');
//   }
  
//   // حفظ __v
//   Future<void> saveV(int v) async {
//     await _box.write('${_prefix}v', v);
//   }
  
//   int? getV() {
//     return _box.read('${_prefix}v');
//   }
  
//   // ============ دوال مساعدة ============
  
//   // حفظ كل البيانات من JSON مرة واحدة
//   Future<void> saveAllFromJson(Map<String, dynamic> json) async {
//     if (json['_id'] != null) await saveId(json['_id']);
//     if (json['user'] != null) await saveUserId(json['user']);
//     if (json['university_number'] != null) await saveUniversityNumber(json['university_number']);
//     if (json['first_name'] != null) await saveFirstName(json['first_name']);
//     if (json['father_name'] != null) await saveFatherName(json['father_name']);
//     if (json['last_name'] != null) await saveLastName(json['last_name']);
//     if (json['email'] != null) await saveEmail(json['email']);
//     if (json['bio'] != null) await saveBio(json['bio']);
//     if (json['gender'] != null) await saveGender(json['gender']);
//     if (json['__v'] != null) await saveV(json['__v']);
    
//     // حفظ بيانات الصورة
//     if (json['profile_photo'] != null) {
//       final photo = json['profile_photo'] as Map<String, dynamic>;
//       await saveProfilePhotoPublicId(photo['publicId']);
//       await saveProfilePhotoUrl(photo['url']);
//     }
//   }
  
//   // الحصول على كل البيانات كـ Map
//   Map<String, dynamic> getAllAsJson() {
//     return {
//       '_id': getId(),
//       'user': getUserId(),
//       'university_number': getUniversityNumber(),
//       'first_name': getFirstName(),
//       'father_name': getFatherName(),
//       'email': getEmail(),
//       'last_name': getLastName(),
//       'bio': getBio(),
//       'profile_photo': {
//         'publicId': getProfilePhotoPublicId(),
//         'url': getProfilePhotoUrl(),
//       },
//       'gender': getGender(),
//       '__v': getV(),
//     };
//   }
  
//   // // الحصول على الاسم الكامل
//   // String getFullName() {
//   //   final firstName = getFirstName() ?? '';
//   //   final fatherName = getFatherName() ?? '';
//   //   final lastName = getLastName() ?? '';
    
//   //   return [firstName, fatherName, lastName]
//   //       .where((name) => name.isNotEmpty)
//   //       .join(' ');
//   // }
//   String getRole() {
//     return _box.read('role') ?? '';
//   }
//   String? getToken() {
//     return _box.read('token');
//   }
//   String? getAge() {
//     return _box.read('${_prefix}age');
//   }
//   Future<void> saveAge(String age) async {
//     await _box.write('${_prefix}age', age);
//   }
//   // التحقق من وجود بيانات
//   bool hasData() {
//     return getId() != null || getUserId() != null;
//   }
  
//   // مسح حقل محدد
//   Future<void> removeField(String field) async {
//     await _box.remove('$_prefix$field');
//   }
  
//   // مسح كل البيانات
//   Future<void> clearAll() async {
//     await _box.erase();
//   }
  
//   // مسح بيانات البروفايل فقط (بدون مسح باقي التطبيق)
//   Future<void> clearProfileData() async {
//     final keys = [
//       '${_prefix}id',
//       '${_prefix}user_id',
//       '${_prefix}university_number',
//       '${_prefix}first_name',
//       '${_prefix}father_name',
//       '${_prefix}last_name',
//       '${_prefix}bio',
//       '${_prefix}photo_public_id',
//       '${_prefix}photo_url',
//       '${_prefix}gender',
//       '${_prefix}v',
//     ];
    
//     for (var key in keys) {
//       await _box.remove(key);
//     }
//   }
  
//   // الحصول على عدد الحقول المحفوظة
//   int getStoredFieldsCount() {
//     int count = 0;
//     if (getId() != null) count++;
//     if (getUserId() != null) count++;
//     if (getUniversityNumber() != null) count++;
//     if (getFirstName() != null) count++;
//     if (getFatherName() != null) count++;
//     if (getLastName() != null) count++;
//     if (getBio() != null) count++;
//     if (getProfilePhotoPublicId() != null) count++;
//     if (getProfilePhotoUrl() != null) count++;
//     if (getGender() != null) count++;
//     if (getV() != null) count++;
//     return count;
//   }
// }