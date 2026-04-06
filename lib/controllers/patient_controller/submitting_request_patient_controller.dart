// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gr_flutter/controllers/patient_controller/patient_request_controller.dart';
// import 'package:gr_flutter/models/request_model.dart';
// import '../../services/functions/handling_data.dart';
// import '../../services/functions/upload_picture.dart';
// import '../../services/remote/request_remote.dart';
// import '../../utils/app_constants/status_request.dart';

// abstract class SubmittingRequestPatientController extends GetxController {}

// class SubmittingRequestPatientControllerImp
//     extends SubmittingRequestPatientController {
//   PatientRequestControllerImp patientRequestControllerImp = Get.find();
//   File? image;
//   formateData() {
//     toothPositionController;
//   }

//   // ============================ Form State ============================
//   final GlobalKey<FormState> formState = GlobalKey<FormState>();
//   final RequestRemote requestData = RequestRemote(Get.find());

//   late StatusRequest statusRequest;

//   String painLevel = "";
//   String chronicDiseases = "";
//   bool? regnant;
//   String medicines = "";
//   String painTime = "";
//   String previousTreatment = "";
//   String gender = "";
//   String age = "";
//   String notes = "";
//   String toothLocation = "";
//   String caseType = "أخرى";
//   String painSeverity = "0";

//   List<String> painLevelList = ["0", "1", "2", "3", "4", "5"];
//   List<String> painSeverityList = ["0", "1", "2", "3", "4", "5"];
//   final TextEditingController toothPositionController =
//       TextEditingController(); // موقع السن
//   final TextEditingController ageController = TextEditingController(); //العمر
//   final TextEditingController chronicDiseasesController =
//       TextEditingController(); //امراض مزمنة
//   final TextEditingController medicinesController =
//       TextEditingController(); // ادوية او مكملات
//   final TextEditingController painTimesController =
//       TextEditingController(text: 'لايوجد ألم'); // اوقات الالم

// // ============================ Data Preparation ============================
//   Map<String, dynamic> _prepareRequestData() {
//     var requestData = RequestSendModel(
//         age: ageController.text,
//         caseType: caseType,
//         gender: gender,
//         painSeverity: int.tryParse(painLevel)!,
//         painTime: painTimesController.text,
//         toothLocation: toothPositionController.text,
//         isPregnant: regnant,
//         notes: "{'أمراض':'','أدوية':'','تمت معالجته سابقا':''}");
//     final Map<String, dynamic> data = requestData.toJson();
//     return data;
//   }

//   xx(RequestReceiveModel r) {
//     ageController.text = r.age;
//     caseType = r.caseType;
//     gender = r.gender;
//     painLevel = r.painSeverity.toString();
//     painTimesController.text = r.painTime;
//     toothPositionController.text = r.toothLocation;
//     regnant = r.isRegnant;
//     image = null;
//     update();
//   }

//   uploadPicturee() async {
//     File? pickedImage = await uploadPicture(); // استقبال الصورة المرفوعة
//     if (pickedImage != null) {
//       image = pickedImage; // تحديث المتغير في الـ Controller
//       update(); // تحديث الواجهة
//     }
//   }

//   // ====================================================
//   Future<void> submitRequest() async {
//     print('Submitting request...'); // Debug

//     if (!_validateForm()) {
//       print('Form validation failed'); // Debug
//       return;
//     }

//     final formData = _prepareRequestData();
//     statusRequest = StatusRequest.loading;

//     try {
//       print('Sending request with data: $formData'); // Debug
//       final response = await requestData.sendRequestData(formData, image);
//       print('Response received: $response'); // Debug

//       statusRequest = handlingData(response);
//       if (statusRequest == StatusRequest.success) {
//         print('Request successful'); // Debug
//         _showSuccessMessage();
//         // Get.closeAllSnackbars();
//         _resetForm();
//         Get.close(1);
//         patientRequestControllerImp.refreshData();
//       } else {
//         print('Request failed with status: $statusRequest'); // Debug
//         _showErrorMessage();
//       }
//       // cancelRequest();
//       // update();
//     } catch (error) {
//       print('Error during request: $error'); // Debug
//       statusRequest = StatusRequest.serverFailure;
//       _showErrorMessage();
//     }
//   }

//   Future<void> updateRequest(String id) async {
//     print('Updating request...'); // Debug

//     if (!_validateForm()) {
//       print('Form validation failed'); // Debug
//       return;
//     }

//     final formData = _prepareRequestData();
//     statusRequest = StatusRequest.loading;

//     try {
//       print('Sending request with data: $formData'); // Debug
//       final response = await requestData.updateRequestData(formData, image, id);
//       print('Response received: $response'); // Debug

//       statusRequest = handlingData(response);
//       if (statusRequest == StatusRequest.success) {
//         print('Request successful'); // Debug
//         _showSuccessMessage();
//         // Get.closeAllSnackbars();
//         _resetForm();
//         Get.close(1);
//         patientRequestControllerImp.refreshData();
//       } else {
//         print('Request failed with status: $statusRequest'); // Debug
//         _showErrorMessage();
//       }
//       // cancelRequest();
//       // update();
//     } catch (error) {
//       print('Error during request: $error'); // Debug
//       statusRequest = StatusRequest.serverFailure;
//       _showErrorMessage();
//     }
//   }

//   void disposeControllers() {
//     // medicinesController.dispose();
//     // chronicDiseasesController.dispose();
//     // toothPositionController.dispose();
//     // ageController.dispose();
//     // painTimesController.dispose();
//   }

//   @override
//   void onClose() {
//     disposeControllers();
//     super.onClose();
//   }

//   // ============================ Update Methods ============================
//   void updatePainLevel(int level) {
//     if (painLevel != "$level") {
//       painLevel = "$level";
//       update();
//     }
//   }

//   void updatePainSeverity(String? value) {
//     painSeverity = value!;
//     update();
//   }

//   void updateCaseType(String? value) {
//     caseType = value!;
//     update();
//   }

//   void updateMedicines(String value) {
//     if (medicines != value) {
//       medicines = value;
//       if (value != "نعم") {
//         medicinesController.clear();
//       }
//       update();
//     }
//   }

//   void updateChronicDiseases(String value) {
//     if (chronicDiseases != value) {
//       chronicDiseases = value;
//       if (value != "نعم") {
//         chronicDiseasesController.clear();
//       }
//       update();
//     }
//   }

//   void updateRegnant(bool value) {
//     if (regnant != value) {
//       regnant = value;

//       update();
//     }
//   }

//   void updateGender(String value) {
//     if (gender != value) {
//       gender = value;
//       update();
//     }
//   }

//   void updatePreviousTreatment(String value) {
//     if (previousTreatment != value) {
//       previousTreatment = value;
//       update();
//     }
//   }

//   // ============================ Form Submission ============================

//   bool _validateForm() {
//     final form = formState.currentState;
//     if (form == null) {
//       print('Form state is null'); // Debug
//       Get.snackbar('خطأ', 'نموذج غير صالح');
//       return false;
//     }

//     if (!form.validate()) {
//       print('Form validation failed'); // Debug
//       Get.snackbar('خطأ', 'الرجاء ملء جميع الحقول المطلوبة بشكل صحيح');
//       return false;
//     }

//     // Additional validations
//     if (painLevel != "0" &&
//         painLevel != "1" &&
//         painLevel != "2" &&
//         painLevel != "3" &&
//         painLevel != "4" &&
//         painLevel != "5") {
//       Get.snackbar('تحذير', 'الرجاء تحديد شدة الألم');
//       return false;
//     }

//     if (gender != "male" && gender != "female" && gender != "other") {
//       Get.snackbar('تحذير', 'الرجاء تحديد الجنس');
//       return false;
//     }

//     if (toothPositionController.text.isEmpty) {
//       Get.snackbar('تحذير', 'الرجاء إدخال موقع السن');
//       return false;
//     }

//     return true;
//   }

//   void _showSuccessMessage() {
//     Get.snackbar(
//       'نجاح',
//       'تم إرسال الطلب بنجاح',
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 3),
//     );
//   }

//   void _showErrorMessage() {
//     Get.snackbar(
//       'خطأ',
//       'فشل في إرسال الطلب. الرجاء المحاولة مرة أخرى',
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 3),
//     );
//   }

//   // ============================ Form Reset ============================
//   void _resetForm() {
//     medicinesController.clear();
//     chronicDiseasesController.clear();
//     toothPositionController.clear();
//     painTimesController.clear();
//     ageController.clear();
//     update();
//   }

//   void cancelRequest() {
//     _resetForm();
//     Get.back();
//   }

//   // ====================================================uploadProfilePicture
//   Future<void> uploadRequestPicture(File image) async {
//     try {
//       statusRequest = StatusRequest.loading;
//       update();
//       print('بدء رفع الصورة: ${image.path}');
//       print('حجم الصورة: ${image.lengthSync()} bytes');
//       // var response = await requestData.uploadRequestPicture(image);
//       // print('استجابة الخادم: $response');
//       // statusRequest = handlingData(response);
//       if (statusRequest == StatusRequest.success) {
//         print('تم رفع الصورة بنجاح');
//         // تحديث البيانات المحلية بالصورة الجديدة
//         // await fetchingData();
//         Get.snackbar('نجاح', 'تم تحديث الصورة بنجاح',
//             backgroundColor: Colors.green, colorText: Colors.white);
//         // data['profile_picture']=response['data']['profile_photo']['url'];
//         // profilePicture=data['profile_picture'];
//         // print(data['profile_picture']);

//         update();
//       } else {
//         print('فشل في رفع الصورة - StatusRequest: $statusRequest');
//         Get.snackbar('خطأ', 'فشل في تحميل الصورة',
//             backgroundColor: Colors.red, colorText: Colors.white);
//       }
//     } catch (e) {
//       print('خطأ أثناء رفع الصورة: $e');
//       statusRequest = StatusRequest.serverFailure;
//       Get.snackbar('خطأ', 'حدث خطأ أثناء تحميل الصورة: $e',
//           backgroundColor: Colors.red, colorText: Colors.white);
//     }
//     update();
//   }
//   // ============================ Treatment Types ============================

//   // final List<String> caseTypeEn = [
//   //   "Light filling",
//   //   "Nerve pulling",
//   //   "Crown",
//   //   "Front bridge",
//   //   "Back bridge",
//   //   "Partial suit",
//   //   "Full suit",
//   //   "Children",
//   //   "Extraction",
//   //   "Gum treatment",
//   //   "Other",
//   // ];
// }
