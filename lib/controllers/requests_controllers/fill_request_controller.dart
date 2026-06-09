import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/models/requests_models/pending_request_model.dart';
import 'package:gr_flutter/views/widgets/botton_controller.dart';

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
  bool previousTreatment = false;

  // PatientRequestControllerImp patientRequestControllerImp =
  //     Get.find<PatientRequestControllerImp>();
  // PatientRequestControllerImp patientRequestControllerImp =Get.put(PatientRequestControllerImp());
  File? image;

  Widget? bottomNavigationBar;
  late PendingRequestModel pendingRequestModel;
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  late StatusRequest statusRequest;
  final RequestRemote requestData = RequestRemote(Get.find());

  // fromReceiveToSend(PendingRequestModel r) {
  //   requestSendModel.age = r.age;
  //   // requestSendModel.caseType = r.caseType;
  //   requestSendModel.gender = r.gender;
  //   requestSendModel.isPregnant = r.isRegnant;
  //   requestSendModel.moreDetails = r.moreDetails;
  //   requestSendModel.painSeverity = r.painSeverity;
  //   requestSendModel.painTime = r.painTime;
  //   requestSendModel.photo = r.photo;
  //   requestSendModel.toothLocation = r.toothLocation;
  //   if (r.moreDetails!.chronicDiseases != null &&
  //       r.moreDetails!.chronicDiseases != "") {
  //     chronicDiseases = true;
  //   }
  //   if (r.moreDetails!.medicines != null && r.moreDetails!.medicines != "") {
  //     medicines = true;
  //   }
  //   update();
  // }

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

  @override
  sendRequest() async {
    if (!validateForm()) {
      return false;
    }
    print("${pendingRequestModel.toJson()}");
    print("${pendingRequestModel.toJson().runtimeType}");
    final formData = pendingRequestModel.toJson();

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
        // Get.close(1);
        return true;
        // patientRequestControllerImp.refreshData();
      } else {
        Get.snackbar(
          'خطأ',
          'فشل في إرسال الطلب. الرجاء المحاولة مرة أخرى',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
      // cancelRequest();
      // update();
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

  // ===================
  bool validateForm() {
    final form = formState.currentState;
    if (form == null) {
      Get.snackbar('خطأ', 'نموذج غير صالح');
      return false;
    }

    if (!form.validate()) {
      Get.snackbar('خطأ', 'الرجاء ملء جميع الحقول المطلوبة بشكل صحيح');
      return false;
    }

    // Additional validations
    if (pendingRequestModel.requestion!.painSeverity != 0 &&
        pendingRequestModel.requestion!.painSeverity != 1 &&
        pendingRequestModel.requestion!.painSeverity != 2 &&
        pendingRequestModel.requestion!.painSeverity != 3 &&
        pendingRequestModel.requestion!.painSeverity != 4 &&
        pendingRequestModel.requestion!.painSeverity != 5) {
      Get.snackbar('تحذير', 'الرجاء تحديد شدة الألم');
      return false;
    }

    if (pendingRequestModel.requestion!.gender != "male" &&
        pendingRequestModel.requestion!.gender != "female" &&
        pendingRequestModel.requestion!.gender != "other") {
      Get.snackbar('تحذير', 'الرجاء تحديد الجنس');
      return false;
    }

    if (pendingRequestModel.requestion!.toothLocation == null ||
        pendingRequestModel.requestion!.toothLocation!.isEmpty) {
      Get.snackbar('تحذير', 'الرجاء إدخال موقع السن');
      return false;
    }
    if (pendingRequestModel.requestion!.moreDetails!.previousTreatment ==
        null) {
      Get.snackbar('تحذير', "حدد في ما إذا قمت بمعالجة هذا السن من قبل أم لا");
      return false;
    }
    if (pendingRequestModel.requestion!.painTime == null ||
        pendingRequestModel.requestion!.painTime!.isEmpty) {
      Get.snackbar('تحذير', 'الرجاء إدخال  وقت الألم');
      return false;
    }
    if (medicines == true &&
        (pendingRequestModel.requestion!.moreDetails!.medicines == null ||
            pendingRequestModel.requestion!.moreDetails!.medicines!.isEmpty)) {
      Get.snackbar(
          'تحذير', 'الرجاء إدخال الأدوية أو المكملات التي تتناولها أو إختر لا');
      return false;
    }
    if (chronicDiseases == true &&
        (pendingRequestModel.requestion!.moreDetails!.chronicDiseases == null ||
            pendingRequestModel
                .requestion!.moreDetails!.chronicDiseases!.isEmpty)) {
      Get.snackbar(
          'تحذير', 'الرجاء إدخال الأمراض المزمنة التي تعاني منها أو إختر لا');
      return false;
    }

    if (pendingRequestModel.requestion!.age == null ||
        pendingRequestModel.requestion!.age!.isEmpty) {
      Get.snackbar('تحذير', 'الرجاء إدخال  العمر ');
      return false;
    }

    return true;
  }

  // ==================
  uploadReguestPicture() async {
    File? pickedImage = await uploadPicture();
    if (image != pickedImage) update();
    if (pickedImage != null) {
      image = pickedImage;
      update();
    }
    update();
  }

  formatRequest() {
    pendingRequestModel = PendingRequestModel(
      requestion: 
          RequestionModel(
            painSeverity: 0,
            painTime: "",
            toothLocation: "",
            moreDetails: MoreDetails(
              chronicDiseases: "",
              medicines: "",
              previousTreatment: null,
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

  @override
  Future<void> updateRequest(String id) async {
    if (!validateForm()) {
      return;
    }
    final formData = pendingRequestModel.toJson();
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
        // Get.close(1);
        // patientRequestControllerImp.refreshData();
      } else {
        // print("$response");
        Get.snackbar(
          'خطأ',
          'فشل في إرسال الطلب. الرجاء المحاولة مرة أخرى',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
      // cancelRequest();
      // update();
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
