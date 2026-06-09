import 'dart:io';
import 'package:get/get.dart';
import 'package:gr_flutter/services/local_storge/local_user_storage.dart'; // المستورد الجديد
import 'package:gr_flutter/services/remote/public_remotes/unified_profile_remote.dart';
import 'package:gr_flutter/services/functions/handling_data.dart';
import 'package:gr_flutter/utils/app_constants/status_request.dart';
import 'package:gr_flutter/views/widgets/dialog/submit_dialog.dart';
import 'package:gr_flutter/app_route.dart';
import '../../services/functions/upload_picture.dart';

class UnifiedSettingController extends GetxController {
  final localStorage = Get.find<LocalUserStorage>(); // استخدم الكلاس الموحد
  final UnifiedProfileRemote remote = UnifiedProfileRemote(Get.find());
  File? document;
  Rx<StatusRequest> statusRequest = StatusRequest.none.obs;
  RxString profilePicture = "".obs;
  RxString fullName = "".obs;
  RxString role = "".obs;
  RxBool isLoading = false.obs;
  RxBool isVerified = false.obs;

  // بيانات إضافية حسب الدور
  RxString universityNumber = "".obs;
  RxString category = "".obs;
  RxInt completedCases = 0.obs;
  RxInt inProgressCases = 0.obs;
  RxString age = "".obs;
  RxString gender = "".obs;
  RxString phoneNumber = "".obs;
  RxString bio = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadLocalData();       // عرض البيانات المخزنة محليًا أولاً
    fetchProfileData();    // ثم جلب أحدث البيانات من السيرفر
  }

  void loadLocalData()async {
    fullName.value = localStorage.getFullName();
    role.value =await localStorage.getRole() ?? "";
    profilePicture.value = localStorage.getProfilePicture() ?? "";
    phoneNumber.value = localStorage.getPhoneNumber() ?? "";
    bio.value = localStorage.getBio() ?? "";
    isVerified.value = localStorage.isVerified();

    if (role.value == 'student') {
      universityNumber.value = localStorage.getUniversityNumber() ?? "";
      category.value = localStorage.getCategory() ?? "";
    }
    if (role.value == 'patient') {
      age.value = localStorage.getAge() ?? "";
      gender.value = localStorage.getGender() ?? "";
    }
  }

  // جلب البيانات من السيرفر وحفظها محليًا (مع تحديث الواجهة)
  Future<void> fetchProfileData() async {
    isLoading.value = true;
    statusRequest.value = StatusRequest.loading;
    var response = await remote.getMyProfile();
    statusRequest.value = handlingData(response);
    if (statusRequest.value == StatusRequest.success && response['data'] != null) {
      final data = response['data'];
      fullName.value = "${data['first_name'] ?? ''} ${data['father_name'] ?? ''} ${data['last_name'] ?? ''}";
      profilePicture.value = data['profile_photo']?['url'] ?? "";
      phoneNumber.value = data['phone_number'] ?? "";
      bio.value = data['bio'] ?? "";

      if (role.value == 'student') {
        universityNumber.value = data['university_number'] ?? "";
        category.value = data['category']?['category'] ?? "";
        completedCases.value = data['count_cases_finishds'] ?? 0;
        inProgressCases.value = data['count_cases_in_process'] ?? 0;
        isVerified.value = data['is_verified'] ?? false;
        await localStorage.saveIsVerified(isVerified.value);
      }
      if (role.value == 'overseer') {
        completedCases.value = data['count_cases_finishds'] ?? 0;
        inProgressCases.value = data['count_cases_in_process'] ?? 0;
      }
      if (role.value == 'patient') {
        age.value = data['age']?.toString() ?? "";
        gender.value = data['gender'] ?? "";
      }

      // حفظ البيانات في التخزين المحلي (LocallocalStorage)
      await localStorage.saveAllFromJson(data);
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل تحميل البيانات');
    }
    isLoading.value = false;
    statusRequest.value = StatusRequest.success;
  }

  // دالة منفصلة للتحديث (لـ RefreshIndicator)
  Future<void> refreshProfileData() async {
    await fetchProfileData();
  }

  // رفع صورة البروفايل
  Future<void> uploadProfilePicture(File image) async {
    statusRequest.value = StatusRequest.loading;
    update();
    var response = await remote.uploadProfilePicture(image);
    statusRequest.value = handlingData(response);
    if (statusRequest.value == StatusRequest.success && response['data'] != null) {
      profilePicture.value = response['data']['profile_photo']?['url'] ?? "";
      await localStorage.saveProfilePicture(profilePicture.value);
      Get.snackbar('نجاح', 'تم تحديث الصورة');
    } else {
      Get.snackbar('خطأ', 'فشل تحميل الصورة');
    }
    update();
  }

  void toEditProfile() {
    Get.toNamed(AppRroute.unifiedEditProfile);
  }

  void toShowProfile() {
    Get.toNamed(AppRroute.unifiedProfileScreen);
  }

  void toChangePassword() {
    Get.toNamed(AppRroute.changePassword);
  }

  void toPrivacyPolicy() {
    Get.toNamed(AppRroute.privacyPolicy);
  }

  void toContactSupport() {
    Get.toNamed(AppRroute.contactSupport);
  }

  void toVerifypage() {
    Get.toNamed(AppRroute.viewVerify);
  }

  Future<void> uploadVerifyDocument() async {
    File? pickedImage = await uploadPicture();
    if (document != pickedImage) update();
    if (pickedImage != null) {
      document = pickedImage;
      update();
    }
    update();
  }

  Future<void> verifyDocument() async {
    if (document == null) {
      Get.snackbar("خطأ", "الرجاء تحميل صورة البطاقة الجامعية");
      return;
    }
    Get.dialog(
      SubmitDialog(
        title: "تأكيد",
        question: "هل أنت متأكد من رغبتك في تقديم طلب التوثيق؟ ",
        onTapSubmit: () async {
          await remote.sendVerifyDocument(document!);
          Get.snackbar("تم", "تم تقديم طلب التوثيق بنجاح");
          await Future.delayed(Duration(seconds: 1));
          Get.close(2);
        },
      ),
    );
  }

  void confirmLogOut() {
    Get.dialog(SubmitDialog(
      title: "تسجيل الخروج",
      question: "هل أنت متأكد من رغبتك بتسجيل الخروج؟",
      onTapSubmit: () async {
        await localStorage.clearAll();    // مسح كل البيانات (توكن، دور، بروفايل)
        Get.offAllNamed(AppRroute.register);
      },
    ));
  }

  String getRoleTitle() {
    switch (role.value) {
      case 'student': return 'طالب';
      case 'patient': return 'مريض';
      case 'overseer': return 'مشرف';
      default: return role.value;
    }
  }

  Future<void> updateProfileData(Map<String, dynamic> updatedData) async {
    statusRequest.value = StatusRequest.loading;
    update();
    var response = await remote.updateProfile(updatedData);
    statusRequest.value = handlingData(response);
    if (statusRequest.value == StatusRequest.success && response['data'] != null) {
      final data = response['data'];
      fullName.value = "${data['first_name'] ?? ''} ${data['father_name'] ?? ''} ${data['last_name'] ?? ''}";
      phoneNumber.value = data['phone_number'] ?? '';
      bio.value = data['bio'] ?? '';
      if (role.value == 'student') {
        universityNumber.value = data['university_number'] ?? '';
        category.value = data['category']?['category'] ?? '';
      }
      if (role.value == 'patient') {
        age.value = data['age']?.toString() ?? '';
        gender.value = data['gender'] ?? '';
      }
      // حفظ في LocallocalStorage
      await localStorage.saveFirstName(data['first_name']);
      await localStorage.saveFatherName(data['father_name']);
      await localStorage.saveLastName(data['last_name']);
      await localStorage.savePhoneNumber(phoneNumber.value);
      await localStorage.saveBio(bio.value);
      if (role.value == 'student') await localStorage.saveUniversityNumber(universityNumber.value);
      if (role.value == 'patient') {
        await localStorage.saveAge(age.value);
        await localStorage.saveGender(gender.value);
      }
      await localStorage.saveProfilePicture(profilePicture.value);
      Get.back();
      Get.snackbar('نجاح', 'تم تحديث الملف الشخصي بنجاح');
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل التحديث');
    }
    update();
  }
}