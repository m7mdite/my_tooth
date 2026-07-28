import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/models/requests_models/pending_request_model.dart';
import 'package:gr_flutter/views/widgets/botton_controller.dart';

import '../../models/requests_models/treatment_request_model.dart';
import '../../services/functions/handling_data.dart';
import '../../services/functions/upload_picture.dart';
import '../../services/remote/public_remotes/request_remote.dart';
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
  bool? previousTreatment ;
  RxInt selectedPainSeverity = 0.obs;

  File? image;

  Widget? bottomNavigationBar;
  late TreatmentRequestModel treatmentRequestModel;
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  late StatusRequest statusRequest;
  final RequestRemote requestData = RequestRemote(Get.find());

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
    print("${treatmentRequestModel.toJson()}");
    print("${treatmentRequestModel.toJson().runtimeType}");
    final formData = treatmentRequestModel.toJson();

    print("formData: $formData");
    statusRequest = StatusRequest.loading;

    try {
      print("$formData ======================================== ");
      final response = await requestData.sendRequestData(formData, image);
      print("$response");
      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        Get.snackbar(
          'نجاح',
          'تم إرسال الطلب بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        onClose();
        return true;
      } else {
        Get.snackbar(
          'خطأ',
          'فشل في إرسال الطلب. الرجاء المحاولة مرة أخرى',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (error) {
      statusRequest = StatusRequest.serverFailure;
      Get.snackbar(
        'خطأ',
        'فشل في إرسال الطلب. الرجاء المحاولة مرة أخرى',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
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
        treatmentRequestModel.requestion!.painSeverity! < 1 || treatmentRequestModel.requestion!.painSeverity! >10) {
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
    if (treatmentRequestModel.requestion!.moreDetails!.previousTreatment ==
        null) {
      Get.snackbar('تحذير', "حدد في ما إذا قمت بمعالجة هذا السن من قبل أم لا");
      return false;
    }
    if (treatmentRequestModel.requestion!.painTime == null ||
        treatmentRequestModel.requestion!.painTime!.isEmpty) {
      Get.snackbar('تحذير', 'الرجاء إدخال  وقت الألم');
      return false;
    }
    if (medicines == true &&
        (treatmentRequestModel.requestion!.moreDetails!.medicines == null ||
            treatmentRequestModel.requestion!.moreDetails!.medicines!.isEmpty)) {
      Get.snackbar(
          'تحذير', 'الرجاء إدخال الأدوية أو المكملات التي تتناولها أو إختر لا');
      return false;
    }
    if (chronicDiseases == true &&
        (treatmentRequestModel.requestion!.moreDetails!.chronicDiseases == null ||
            treatmentRequestModel
                .requestion!.moreDetails!.chronicDiseases!.isEmpty)) {
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
        moreDetails: MoreDetails(
          chronicDiseases: "",
          medicines: "",
          previousTreatment: false,
        ),
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
      print("$response");
      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        Get.snackbar(
          'نجاح',
          'تم تعديل الطلب بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        onClose();
      } else {
        Get.snackbar(
          'خطأ',
          'فشل في إرسال الطلب. الرجاء المحاولة مرة أخرى',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (error) {
      statusRequest = StatusRequest.serverFailure;
      Get.snackbar(
        'خطأ',
        'فشل في إرسال الطلب. الرجاء المحاولة مرة أخرى',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}