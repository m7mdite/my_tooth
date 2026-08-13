import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/widgets/botton_controller.dart';
import 'package:gr_flutter/views/widgets/dialog/case_type_prediction_dialog.dart';
import 'package:gr_flutter/views/widgets/dialog/prediction_result_dialog.dart';

import '../../models/requests_models/case_type_prediction_result_model.dart';
import '../../models/requests_models/prediction_result_model.dart';
import '../../models/requests_models/treatment_request_model.dart';
import '../../services/functions/handling_data.dart';
import '../../services/functions/upload_picture.dart';
import '../../services/remote/public_remotes/request_remote.dart';
import '../../utils/app_constants/colors_constant.dart';
import '../../utils/app_constants/status_request.dart';
import '../../views/request_views/modified_request.dart';

abstract class FillRequestController extends GetxController {
  canselSendRequest();
  sendRequest();
  updateRequest(String id);
}

class FillRequestControllerImp extends FillRequestController {
  bool chronicDiseases = false;
  bool medicines = false;
  bool? previousTreatment;
  RxInt selectedPainSeverity = 0.obs;

  File? image;

  Widget? bottomNavigationBar;
  late TreatmentRequestModel treatmentRequestModel;
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  late StatusRequest statusRequest;
  final RequestRemote requestData = RequestRemote(Get.find());

  // ===== حالة التنبؤ بإمكانية العلاج (اختياري) =====
  final RxBool isPredicting = false.obs;

  // ===== حالة التنبؤ بنوع المعالجة (اختياري) =====
  final RxBool isPredictingCaseType = false.obs;

  // ===== عرض الديالوج =====
  showDialog(String status) async {
    status == "send"
        ? bottomNavigationBar = Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottonContainer(
                body: "send",
                paddingHorizontal: 20,
                paddingVertical: 5,
                onTap: () {
                  sendRequest();
                },
              ),
              BottonContainer(
                body: "cancel",
                paddingHorizontal: 20,
                paddingVertical: 5,
                onTap: () {
                  canselSendRequest();
                },
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottonContainer(
                body: "update",
                paddingHorizontal: 20,
                paddingVertical: 5,
                onTap: () {
                  // updateRequest();
                },
              ),
              BottonContainer(
                body: "cancel",
                paddingHorizontal: 20,
                paddingVertical: 5,
                onTap: () {
                  canselSendRequest();
                },
              ),
            ],
          );
    await Get.dialog(
      ModifiedRequest(),
    );
  }

  // داخل FillRequestControllerImp
  RxInt currentStep = 0.obs;
  int totalSteps = 12; // حسب عدد العناصر الرئيسية

  void goToNextStep() {
    if (currentStep.value < totalSteps) {
      currentStep.value++;
    }
  }

  // ===== إرسال الطلب =====
  @override
  sendRequest() async {
    if (!validateForm()) {
      return false;
    }
    final formData = treatmentRequestModel.toJson();

    statusRequest = StatusRequest.loading;

    try {
      final response = await requestData.sendRequestData(formData, image);
      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        Get.snackbar(
          'نجاح',
          'تم إرسال الطلب بنجاح',
          backgroundColor: AppColors.success,
          colorText: AppColors.white,
          duration: const Duration(seconds: 3),
        );
        onClose();
        return true;
      } else {
        Get.snackbar(
          'خطأ',
          'فشل في إرسال الطلب. الرجاء المحاولة مرة أخرى',
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (error) {
      statusRequest = StatusRequest.serverFailure;
      Get.snackbar(
        'خطأ',
        'فشل في إرسال الطلب. الرجاء المحاولة مرة أخرى',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// ===== التنبؤ بإمكانية علاج الحالة (اختياري تماماً) =====
  /// المريض حر يستخدمه أو يتجاهله. نفس شروط التحقق تبع إرسال الطلب
  /// (validateForm) لازم تنجح أول، لأن نموذج الـ ML مدرّب على نفس
  /// الحقول المطلوبة بالضبط ومحتاج بيانات كاملة عشان يعطي نتيجة موثوقة.
  Future<void> predictTreatment() async {
    if (!validateForm()) {
      return;
    }

    isPredicting.value = true;

    try {
      final formData = treatmentRequestModel.toJson();
      final response = await requestData.predictTreatment(formData);
      final predictStatus = handlingData(response);

      if (predictStatus == StatusRequest.success &&
          response is Map &&
          response['data'] != null) {
        final result = PredictionResult.fromJson(
          Map<String, dynamic>.from(response['data']),
        );
        Get.dialog(PredictionResultDialog(result: result));
      } else {
        Get.snackbar(
          'تعذر التنبؤ',
          'حدث خطأ أثناء محاولة التنبؤ بإمكانية العلاج، حاول مرة أخرى',
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (error) {
      Get.snackbar(
        'تعذر التنبؤ',
        'حدث خطأ أثناء محاولة التنبؤ بإمكانية العلاج، حاول مرة أخرى',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isPredicting.value = false;
    }
  }

  /// ✅ تحقق مخصص للتنبؤ بنوع المعالجة — عن قصد مختلف عن validateForm().
  /// ما بنشترط اختيار نوع المعالجة (caseType) هون، لأن هدف هالزر أصلاً
  /// هو مساعدة المريض يعرف نوع المعالجة المتوقع *قبل* ما يختاره يدوياً.
  /// بنتحقق فقط من نفس الحقول اللي الباك نفسه بيرفض الطلب بدونها
  /// (age, gender, pain_severity, pain_time, tooth_location).
  bool _validateForCaseTypePrediction() {
    final r = treatmentRequestModel.requestion;
    if (r == null) {
      Get.snackbar('تنبيه', 'الرجاء تعبئة بيانات الطلب أولاً');
      return false;
    }
    if (r.age == null || r.age!.isEmpty) {
      Get.snackbar('تنبيه', 'الرجاء إدخال العمر أولاً');
      return false;
    }
    if (r.gender != "male" && r.gender != "female" && r.gender != "other") {
      Get.snackbar('تنبيه', 'الرجاء تحديد الجنس أولاً');
      return false;
    }
    if (r.painSeverity == null ||
        r.painSeverity! < 1 ||
        r.painSeverity! > 10) {
      Get.snackbar('تنبيه', 'الرجاء تحديد شدة الألم أولاً');
      return false;
    }
    if (r.painTime == null || r.painTime!.isEmpty) {
      Get.snackbar('تنبيه', 'الرجاء تحديد وقت الألم أولاً');
      return false;
    }
    if (r.toothLocation == null || r.toothLocation!.isEmpty) {
      Get.snackbar('تنبيه', 'الرجاء إدخال موقع/رقم السن أولاً');
      return false;
    }
    return true;
  }

  /// ===== التنبؤ بنوع المعالجة المتوقع (اختياري تماماً) =====
  Future<void> predictCaseType() async {
    if (!_validateForCaseTypePrediction()) {
      return;
    }

    isPredictingCaseType.value = true;

    try {
      final r = treatmentRequestModel.requestion!;
      final data = <String, dynamic>{
        'age': r.age,
        'gender': r.gender,
        'pain_severity': r.painSeverity,
        'pain_time': r.painTime,
        'tooth_location': r.toothLocation,
        'is_pregnant': r.isPregnant ?? false,
        'previous_treatment': r.previousTreatment ?? false,
        'takes_medication': medicines,
        // ⚠️ الفورم الحالي ما بيجمع نوع الدواء كرقم مصنّف، فبنبعت 0
        // كافتراضي (نفس الـ fallback يلي الباك نفسه بيعمله).
        'medication_type': 0,
      };

      final response = await requestData.predictCaseType(data, image);
      final predictStatus = handlingData(response);

      if (predictStatus == StatusRequest.success &&
          response is Map &&
          response['data'] != null) {
        final result = CaseTypePredictionResult.fromJson(
          Map<String, dynamic>.from(response['data']),
        );
        Get.dialog(CaseTypePredictionDialog(result: result));
      } else {
        Get.snackbar(
          'تعذر التنبؤ',
          'حدث خطأ أثناء محاولة التنبؤ بنوع المعالجة، حاول مرة أخرى',
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (error) {
      Get.snackbar(
        'تعذر التنبؤ',
        'حدث خطأ أثناء محاولة التنبؤ بنوع المعالجة، حاول مرة أخرى',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isPredictingCaseType.value = false;
    }
  }

  // ===== التحقق من صحة النموذج =====
  bool validateForm() {
    final form = formState.currentState;
    if (form == null) {
      Get.snackbar('خطأ', 'نموذج غير صالح');
      return false;
    }

    // ✅ التحقق من اختيار نوع المعالجة
    if (treatmentRequestModel.caseType?.sId == null ||
        treatmentRequestModel.caseType!.sId!.isEmpty) {
      Get.snackbar('تنبيه', 'الرجاء اختيار نوع المعالجة');
      return false;
    }

    if (!form.validate()) {
      Get.snackbar('خطأ', 'الرجاء ملء جميع الحقول المطلوبة بشكل صحيح');
      return false;
    }

    // ✅ التحقق من اختيار شدة الألم
    if (treatmentRequestModel.requestion!.painSeverity == null ||
        treatmentRequestModel.requestion!.painSeverity! < 1 ||
        treatmentRequestModel.requestion!.painSeverity! > 10) {
      Get.snackbar('تنبيه', 'الرجاء تحديد شدة الألم');
      return false;
    }

    if (treatmentRequestModel.requestion!.gender != "male" &&
        treatmentRequestModel.requestion!.gender != "female" &&
        treatmentRequestModel.requestion!.gender != "other") {
      Get.snackbar('تحذير', 'الرجاء تحديد الجنس');
      return false;
    }

    if (treatmentRequestModel.requestion!.toothLocation == null ||
        treatmentRequestModel.requestion!.toothLocation!.isEmpty) {
      Get.snackbar('تحذير', 'الرجاء إدخال موقع السن');
      return false;
    }
    if (treatmentRequestModel.requestion!.previousTreatment == null) {
      Get.snackbar('تحذير', "حدد في ما إذا قمت بمعالجة هذا السن من قبل أم لا");
      return false;
    }
    if (treatmentRequestModel.requestion!.painTime == null ||
        treatmentRequestModel.requestion!.painTime!.isEmpty) {
      Get.snackbar('تحذير', 'الرجاء إدخال  وقت الألم');
      return false;
    }
    if (medicines == true &&
        (treatmentRequestModel.requestion!.medicines == null ||
            treatmentRequestModel.requestion!.medicines!.isEmpty)) {
      Get.snackbar(
          'تحذير', 'الرجاء إدخال الأدوية أو المكملات التي تتناولها أو إختر لا');
      return false;
    }
    if (chronicDiseases == true &&
        (treatmentRequestModel.requestion!.chronicDiseases == null ||
            treatmentRequestModel.requestion!.chronicDiseases!.isEmpty)) {
      Get.snackbar(
          'تحذير', 'الرجاء إدخال الأمراض المزمنة التي تعاني منها أو إختر لا');
      return false;
    }

    if (treatmentRequestModel.requestion!.age == null ||
        treatmentRequestModel.requestion!.age!.isEmpty) {
      Get.snackbar('تحذير', 'الرجاء إدخال  العمر ');
      return false;
    }

    return true;
  }

  // ===== رفع الصورة =====
  uploadReguestPicture() async {
    File? pickedImage = await uploadPicture();
    if (image != pickedImage) update();
    if (pickedImage != null) {
      image = pickedImage;
      update();
    }
    update();
  }

  // ===== تهيئة النموذج =====
  formatRequest() {
    selectedPainSeverity.value = 0;
    treatmentRequestModel = TreatmentRequestModel(
      requestion: Requestion(
        painSeverity: 0,
        painTime: "لا يوجد",
        toothLocation: "",
        chronicDiseases: "",
        medicines: "",
        previousTreatment: false,
      ),
      caseType: CaseType(sId: "", caseType: ""),
    );
    image = null;
    update();
  }

  @override
  void onInit() {
    formatRequest();
    super.onInit();
  }

  @override
  void onClose() {
    formatRequest();
    super.onClose();
  }

  @override
  canselSendRequest() {
    onClose();
    Get.close(1);
  }

  // ===== تعديل الطلب =====
  @override
  Future<void> updateRequest(String id) async {
    if (!validateForm()) {
      return;
    }
    final formData = treatmentRequestModel.toJson();
    statusRequest = StatusRequest.loading;

    try {
      final response = await requestData.updateRequestData(formData, image, id);
      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        Get.snackbar(
          'نجاح',
          'تم تعديل الطلب بنجاح',
          backgroundColor: AppColors.success,
          colorText: AppColors.white,
          duration: const Duration(seconds: 3),
        );
        onClose();
      } else {
        Get.snackbar(
          'خطأ',
          'فشل في إرسال الطلب. الرجاء المحاولة مرة أخرى',
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (error) {
      statusRequest = StatusRequest.serverFailure;
      Get.snackbar(
        'خطأ',
        'فشل في إرسال الطلب. الرجاء المحاولة مرة أخرى',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
