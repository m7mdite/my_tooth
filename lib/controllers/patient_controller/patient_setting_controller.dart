import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/models/patient_model/patient_profile_model.dart';
import 'package:gr_flutter/models/profile_model.dart';
import 'package:gr_flutter/services/remote/patient_profile_remote.dart';
import '../../app_route.dart';
import '../../services/functions/handling_data.dart';
import '../../services/shared/auth_model.dart';
import '../../services/shared/auth_service.dart';
import '../../utils/app_constants/status_request.dart';
import '../../views/widgets/submit_dialog.dart';

abstract class PatientSettingController extends GetxController {
  Future<void> fetchingData();
  Future<void> refreshData();
  Future<void> uploadProfilePicture(File image);
  Future<void> updateProfileData(Map<String, dynamic> updatedData);
  void toUpdateProfile();
  void logOut();
  void confirmLogOut();
  void toShowProfile();
}

class PatientSettingControllerImp extends PatientSettingController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late StatusRequest statusRequest;
  late Map<String, dynamic> data = {};
  bool updateMode = false;
  PatientProfileRemote profileData = PatientProfileRemote(Get.find());
  
  // Text editing controllers
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController genderController;
  late TextEditingController ageController;
  
  PatientProfileModel? patientProfileModel;
  String profilePicture = "";
  int currentPageInfo = 0;
  AuthModel authModel = AuthModel();
  AuthService authService = AuthService();

  // Getters for easy access
  String get fullName => authService.getFullName() ?? "";
  String get email => authService.getEmail() ?? "";
  String get phoneNumber => authService.getPhoneNumber() ?? "";
  String get gender => authService.getGender() ?? "";
  String get age => authService.getAge() ?? "";

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _loadLocalData();
    // Fetch fresh data from server in background
    fetchingData();
  }

  void _initializeControllers() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
    genderController = TextEditingController();
    ageController = TextEditingController();
  }

  void _loadLocalData() {
    // Load from local storage first for immediate display
    nameController.text = fullName;
    emailController.text = email;
    phoneNumberController.text = phoneNumber;
    genderController.text = gender;
    ageController.text = age;
    
    // Load profile picture from local storage if available
    profilePicture = authService.getProfilePicture() ?? "";
    update();
  }

  void _updateControllersFromData(Map<String, dynamic> newData) {
    data = newData;
    
    // Update controllers with new data
    nameController.text = newData['first_name'] ?? fullName;
    emailController.text = newData['email'] ?? email;
    phoneNumberController.text = newData['phone_number'] ?? phoneNumber;
    genderController.text = newData['gender'] ?? gender;
    ageController.text = newData['age']?.toString() ?? age;
    
    // Update profile picture
    String newProfilePicture = "";
    if (newData['profile_photo'] != null && newData['profile_photo']['url'] != null) {
      newProfilePicture = "/${newData['profile_photo']['url']}";
    }
    profilePicture = newProfilePicture;
    
    // Save to local storage
    _saveToLocalStorage(newData);
  }

  void _saveToLocalStorage(Map<String, dynamic> userData) {
    try {
      // Create a complete user data map
      Map<String, dynamic> completeData = {
        'first_name': userData['first_name'],
        'last_name': userData['last_name'],
        'email': userData['email'],
        'phone_number': userData['phone_number'],
        'gender': userData['gender'],
        'age': userData['age'],
        'profile_photo': userData['profile_photo'],
      };
      
      // Save all data to local storage
      authService.saveAllFromJson(completeData);
      
      // Also save profile picture separately if needed
      if (userData['profile_photo'] != null && userData['profile_photo']['url'] != null) {
        authService.saveProfilePicture(userData['profile_photo']['url']);
      }
      
      print("Data saved to local storage successfully");
    } catch (e) {
      print("Error saving to local storage: $e");
    }
  }

  @override
  Future<void> fetchingData() async {
    try {
      statusRequest = StatusRequest.loading;
      update();
      
      var response = await profileData.fetchingData();
      statusRequest = handlingData(response);
      
      if (statusRequest == StatusRequest.success) {
        if (response['data'] != null) {
          _updateControllersFromData(response['data']);
        }
        print("Data fetched successfully: $data");
      } else {
        print("Failed to fetch data - StatusRequest: $statusRequest");
        // Keep using local data if fetch fails
        Get.snackbar(
          'تنبيه',
          'لا يمكن الاتصال بالخادم، يتم عرض البيانات المحفوظة',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      print("Error fetching data: $e");
      statusRequest = StatusRequest.serverFailure;
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء جلب البيانات',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    update();
  }

  @override
  Future<void> refreshData() async {
    await fetchingData(); // Re-fetch fresh data from server
    update();
  }

  @override
  Future<void> uploadProfilePicture(File image) async {
    try {
      statusRequest = StatusRequest.loading;
      update();
      
      print('Uploading image: ${image.path}');
      print('Image size: ${image.lengthSync()} bytes');
      
      var response = await profileData.uploadProfilePicture(image);
      statusRequest = handlingData(response);
      
      if (statusRequest == StatusRequest.success) {
        print('Image uploaded successfully');
        
        // Update local data with new picture
        if (response['data'] != null && response['data']['profile_photo'] != null) {
          String newPictureUrl = response['data']['profile_photo']['url'];
          profilePicture = "/$newPictureUrl";
          
          // Save to local storage
          authService.saveProfilePicture(newPictureUrl);
          
          // Update the data map
          if (data['profile_photo'] != null) {
            data['profile_photo']['url'] = newPictureUrl;
          }
          
          Get.snackbar(
            'نجاح',
            'تم تحديث الصورة بنجاح',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          
          // Refresh all data to ensure consistency
          await fetchingData();
        } else {
          Get.snackbar(
            'تنبيه',
            'تم رفع الصورة ولكن حدث خطأ في تحديث البيانات',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      } else {
        print('Upload failed - StatusRequest: $statusRequest');
        Get.snackbar(
          'خطأ',
          'فشل في تحميل الصورة',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error uploading image: $e');
      statusRequest = StatusRequest.serverFailure;
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحميل الصورة: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    update();
  }

  
  @override
Future<void> updateProfileData(Map<String, dynamic> updatedData) async {
  try {
    statusRequest = StatusRequest.loading;
    update();
    
    var response = await profileData.updateProfileData(updatedData);
    statusRequest = handlingData(response);
    print(  "Update response: $response");
    if (statusRequest == StatusRequest.success) {
      if (response['data'] != null) {
        _updateControllersFromData(response['data']);
        Get.snackbar(
          'نجاح',
          'تم تحديث الملف الشخصي بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
        
        // العودة إلى صفحة عرض البروفايل
        Get.back(result: true);
      }
    } else {
      Get.snackbar(
        'خطأ',
        'فشل في تحديث البيانات',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    print("Error updating profile: $e");
    statusRequest = StatusRequest.serverFailure;
    Get.snackbar(
      'خطأ',
      'حدث خطأ أثناء تحديث البيانات: ${e.toString()}',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
  update();
}

@override
void toUpdateProfile() {
  Get.toNamed(AppRroute.patientUpdateProfile);
}

  @override
  void toShowProfile() {
    Get.toNamed(AppRroute.patientShowProfile);
  }

  @override
  void logOut() {
    authModel.clearToken();
    authService.clearAll(); // Clear local storage
    onClose();
    Get.close(5);
    Get.offAllNamed(AppRroute.register);
  }

  @override
  void confirmLogOut() async {
    Get.dialog(
      SubmitDialog(
        title: "تسجيل الخروج",
        question: "هل أنت متأكد من رغبتك بتسجيل الخروج؟",
        onTapSubmit: () async {
          Get.back(); // Close dialog
          Get.snackbar("باي", "مع السلامة يعمري");
          await Future.delayed(Duration(seconds: 1));
          logOut();
        },
      ),
    );
  }
  // أضف هذه الدوال في PatientProfileControllerImp

String getFirstName() {
  return authService.getFirstName() ?? '';
}

String getFatherName() {
  return authService.getFatherName() ?? '';
}

String getLastName() {
  return authService.getLastName() ?? '';
}

String getEmail() {
  return authService.getEmail() ?? '';
}

String getPhoneNumber() {
  return authService.getPhoneNumber() ?? '';
}

String getAge() {
  return authService.getAge() ?? '';
}

String getGender() {
  return authService.getGender() ?? '';
}
  @override
  void onClose() {
    // Dispose controllers
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    genderController.dispose();
    ageController.dispose();
    super.onClose();
  }
}
