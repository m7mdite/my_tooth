import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'secure_storage_service.dart';

class LocalUserStorage extends GetxService {
  static const String _profilePrefix = 'profile_';
  final GetStorage _box = GetStorage();
  final SecureStorageService _secureStorage = Get.find<SecureStorageService>();
  String? _cachedToken;
  String? _cachedRole;

  // ============ التوكن والدور (تخزين آمن مع كاش) ============
  Future<void> saveToken(String token) async {
    _cachedToken = token;
    await _secureStorage.saveToken(token);
  }

  Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;
    _cachedToken = await _secureStorage.getToken();
    return _cachedToken;
  }

  Future<void> deleteToken() async {
    _cachedToken = null;
    await _secureStorage.deleteToken();
  }

  Future<void> saveRole(String role) async {
    _cachedRole = role;
    await _secureStorage.saveRole(role);
  }

  Future<String?> getRole() async {
    if (_cachedRole != null) return _cachedRole;
    _cachedRole = await _secureStorage.getRole();
    return _cachedRole;
  }

  Future<void> deleteRole() async {
    _cachedRole = null;
    await _secureStorage.deleteRole();
  }

  // ============ بيانات المستخدم (تخزين عادي) ============
  // (جميع دوال save/get التالية متطابقة مع النسخة السابقة)
  Future<void> saveId(String id) async => await _box.write('${_profilePrefix}id', id);
  String? getId() => _box.read('${_profilePrefix}id');

  Future<void> saveUserId(String userId) async => await _box.write('${_profilePrefix}user_id', userId);
  String? getUserId() => _box.read('${_profilePrefix}user_id');

  Future<void> saveFirstName(String name) async => await _box.write('${_profilePrefix}first_name', name);
  String? getFirstName() => _box.read('${_profilePrefix}first_name');

  Future<void> saveFatherName(String name) async => await _box.write('${_profilePrefix}father_name', name);
  String? getFatherName() => _box.read('${_profilePrefix}father_name');

  Future<void> saveLastName(String name) async => await _box.write('${_profilePrefix}last_name', name);
  String? getLastName() => _box.read('${_profilePrefix}last_name');

  Future<void> saveEmail(String email) async => await _box.write('${_profilePrefix}email', email);
  String? getEmail() => _box.read('${_profilePrefix}email');

  Future<void> saveBio(String bio) async => await _box.write('${_profilePrefix}bio', bio);
  String? getBio() => _box.read('${_profilePrefix}bio');

  Future<void> savePhoneNumber(String phone) async => await _box.write('${_profilePrefix}phone_number', phone);
  String? getPhoneNumber() => _box.read('${_profilePrefix}phone_number');

  Future<void> saveAge(String age) async => await _box.write('${_profilePrefix}age', age);
  String? getAge() => _box.read('${_profilePrefix}age');

  Future<void> saveGender(String gender) async => await _box.write('${_profilePrefix}gender', gender);
  String? getGender() => _box.read('${_profilePrefix}gender');

  Future<void> saveUniversityNumber(String num) async => await _box.write('${_profilePrefix}university_number', num);
  String? getUniversityNumber() => _box.read('${_profilePrefix}university_number');

  Future<void> saveCategory(String cat) async => await _box.write('${_profilePrefix}category', cat);
  String? getCategory() => _box.read('${_profilePrefix}category');

  Future<void> saveIsVerified(bool verified) async => await _box.write('${_profilePrefix}is_verified', verified);
  bool isVerified() => _box.read('${_profilePrefix}is_verified') ?? false;

  Future<void> saveCompletedCases(int count) async => await _box.write('${_profilePrefix}completed_cases', count);
  int getCompletedCases() => _box.read('${_profilePrefix}completed_cases') ?? 0;

  Future<void> saveInProgressCases(int count) async => await _box.write('${_profilePrefix}in_progress_cases', count);
  int getInProgressCases() => _box.read('${_profilePrefix}in_progress_cases') ?? 0;

  Future<void> saveProfilePhotoPublicId(String? id) async => await _box.write('${_profilePrefix}photo_public_id', id);
  String? getProfilePhotoPublicId() => _box.read('${_profilePrefix}photo_public_id');

  Future<void> saveProfilePhotoUrl(String? url) async => await _box.write('${_profilePrefix}photo_url', url);
  String? getProfilePhotoUrl() => _box.read('${_profilePrefix}photo_url');

  Future<void> saveProfilePicture(String url) async => await _box.write('${_profilePrefix}profile_picture', url);
  String? getProfilePicture() => _box.read('${_profilePrefix}profile_picture');

  Future<void> saveV(int v) async => await _box.write('${_profilePrefix}v', v);
  int? getV() => _box.read('${_profilePrefix}v');

  // ============ دوال مساعدة (تم إصلاح hasToken) ============
  String getFullName() {
    final first = getFirstName() ?? '';
    final father = getFatherName() ?? '';
    final last = getLastName() ?? '';
    return [first, father, last].where((n) => n.isNotEmpty).join(' ');
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  bool hasData() => getId() != null || getUserId() != null;

  Future<void> clearAll() async {
    await deleteToken();
    await deleteRole();
    await _box.erase();
  }

  Future<void> clearProfileData() async {
    final keys = _box.getKeys().where((k) => k.toString().startsWith(_profilePrefix));
    for (var key in keys) {
      await _box.remove(key);
    }
    await _box.remove(_profilePrefix);
  }

  // ============ حفظ جميع البيانات من JSON (API) ============
  Future<void> saveAllFromJson(Map<String, dynamic> json) async {
    try {
      if (json['token'] != null) await saveToken(json['token']);
      if (json['role'] != null) await saveRole(json['role']);

      if (json['_id'] != null) await saveId(json['_id']);
      if (json['user'] != null) await saveUserId(json['user']);
      if (json['first_name'] != null) await saveFirstName(json['first_name']);
      if (json['father_name'] != null) await saveFatherName(json['father_name']);
      if (json['last_name'] != null) await saveLastName(json['last_name']);
      if (json['email'] != null) await saveEmail(json['email']);
      if (json['bio'] != null) await saveBio(json['bio']);
      if (json['gender'] != null) await saveGender(json['gender']);
      if (json['age'] != null) await saveAge(json['age'].toString());
      if (json['phone_number'] != null) await savePhoneNumber(json['phone_number']);
      if (json['university_number'] != null) await saveUniversityNumber(json['university_number']);
      if (json['is_verified'] != null) await saveIsVerified(json['is_verified']);
      if (json['__v'] != null) await saveV(json['__v']);

      if (json['category'] != null) {
        if (json['category'] is Map) {
          await saveCategory(json['category']['category'] ?? '');
        } else {
          await saveCategory(json['category'].toString());
        }
      }

      if (json['count_cases_finishds'] != null) await saveCompletedCases(json['count_cases_finishds']);
      if (json['count_cases_in_process'] != null) await saveInProgressCases(json['count_cases_in_process']);

      if (json['profile_photo'] != null) {
        final photo = json['profile_photo'];
        if (photo is Map) {
          await saveProfilePhotoPublicId(photo['publicId']);
          await saveProfilePhotoUrl(photo['url']);
          if (photo['url'] != null) await saveProfilePicture(photo['url']);
        } else if (photo is String) {
          await saveProfilePicture(photo);
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}