import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/models/requests_models/treatment_model.dart';
import 'package:gr_flutter/services/functions/show_snack.dart';
import 'package:gr_flutter/views/widgets/requests/overseer_manage_request.dart';
import 'package:gr_flutter/views/widgets/dialog/submit_dialog.dart';

import '../../models/requests_models/treatment_request_model.dart';
import '../../services/functions/handling_data.dart';
import '../../services/remote/public_remotes/request_remote.dart';
import '../../utils/app_constants/status_request.dart';
import '../../views/overseer_views/overseer_view_request_processing.dart';
import '../../views/widgets/requests/overseer_reject_request.dart';

abstract class OverseerRequestsController extends GetxController {
  // تعريف الدوال التي ستستخدم في التحكم في الطلبات
  getProcessingRequest();
  showRequest(TreatmentRequestModel request);
  toRejectRequest(TreatmentRequestModel request);
  rejectRequest(TreatmentRequestModel request);
  manageRequest(TreatmentRequestModel request);
  changeCaseRequest(TreatmentRequestModel request);
  toManageRequest(TreatmentRequestModel request);
  addEvaluationRequest(TreatmentRequestModel request);
  finishRequest(TreatmentRequestModel request);
  getAllTreatment();
}

class OverseerRequestsControllerImpl extends OverseerRequestsController {
  List<TreatmentRequestModel> requestList =
      <TreatmentRequestModel>[];
  TreatmentRequestModel selectRequest =
      TreatmentRequestModel();
  List<TreatmentModel> treatments = <TreatmentModel>[];
  RequestRemote requestRemote = RequestRemote(Get.find());
  late StatusRequest statusRequest;
  late TextEditingController textEditingControllerReject;
  late TextEditingController textEditingControllerFeedback;
  // late TextEditingController textEditingControllerRating;
  late TextEditingController textEditingControllerNote;
  late TextEditingController textEditingControllerAddEvaluation;

  bool rejectBool = false;
  bool finishBool = false;
  TreatmentModel? selectnewTreatment;
  RxInt selectedRating = 1.obs;
  formatTextEditing() {
    textEditingControllerAddEvaluation = TextEditingController();
    textEditingControllerFeedback = TextEditingController();
    textEditingControllerNote = TextEditingController();
    // textEditingControllerRating =TextEditingController();
    textEditingControllerReject = TextEditingController();
  }

  @override
  void onInit() {
    formatTextEditing();
    getAllTreatment();
    getProcessingRequest();
    update();
    super.onInit();
  }

  @override
  getProcessingRequest() async {
    requestList = [];
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.getTreatmentRequestsForOverseer();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      requestList = (response['data'] as List)
          .map((e) => TreatmentRequestModel.fromJson(e))
          .toList();
    }
    update();
  }

  @override
  showRequest(TreatmentRequestModel request) {
    selectRequest = request;
    Get.dialog(
      OverseerViewRequestProcessing(requestModel: request),
    );
  }

  @override
  toRejectRequest(TreatmentRequestModel request) {
    Get.dialog(
      SubmitDialog(
        title: "رفض هذا الطلب",
        children: [
          Flexible(
            child: OverseerRejectRequest(),
          ),
        ],
        onTapSubmit: () {
          rejectRequest(request);
        },
      ),
    );
  }

  @override
  toManageRequest(TreatmentRequestModel request) {
    Get.dialog(
      SubmitDialog(
        title: "متابعة حالة الطلب",
        children: [
          Flexible(child: OverseerManageRequest()),
        ],
        onTapSubmit: () {
          manageRequest(request);
        },
      ),
    );
  }

  @override
  rejectRequest(TreatmentRequestModel request) async {
    if (rejectBool == false) {
      statusRequest = StatusRequest.loading;
      update();
      var response = await requestRemote.rejectRequestData(
          {"note": textEditingControllerReject.text}, request.sId!);
      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        showsnack(
            title: response['status'] ?? "tm",
            message: response['message'] ?? "");
        Get.close(2);
        getProcessingRequest();
      } else {
        showsnack(
            title: response['status'] ?? "no",
            message: response['message'] ?? "now");
      }
    } else {
      changeCaseRequest(request);
    }
    update();
  }

  @override
  manageRequest(TreatmentRequestModel request) async {
    if (finishBool) {
      // انتهاء الحالة
      finishRequest(request);
      onInit();
    } else {
      addEvaluationRequest(request);
      onInit();
    }
  }

  @override
  changeCaseRequest(TreatmentRequestModel request) async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.changeCaseRequestData(
        {"note": textEditingControllerNote.text},
        request.sId!,
        selectnewTreatment!.caseType!.sId!);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      showsnack(
          title: response['status'] ?? "tm",
          message: response['message'] ?? "");
      Get.close(2);
      getProcessingRequest();
    } else {
      showsnack(
          title: response['status'] ?? "no",
          message: response['message'] ?? "now");
    }
  }

  @override
  getAllTreatment() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.getTreatments();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      treatments = (response['data'] as List)
          .map((item) => TreatmentModel.fromJson(item))
          .toList();
      selectnewTreatment = treatments[0];
    }
    update();
  }

  @override
  addEvaluationRequest(TreatmentRequestModel request) async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.addEvaluationRequestData({
      "evaluationText": textEditingControllerAddEvaluation.text,
    }, request.sId!);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      showsnack(
        title: response['status'] ?? "tm",
        message: response['message'] ?? "",
      );
      Get.close(2);
      getProcessingRequest();
    } else {
      showsnack(
        title:
            // response['status'] ??
            "no",
        message:
            // response['message']
            //  ??
            "now",
      );
    }
    update();
  }

  @override
  finishRequest(TreatmentRequestModel request) async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.complateRequestData({
      // "rating": textEditingControllerRating.text,
      "rating": selectedRating.value.toString(),
      "feedback": textEditingControllerFeedback.text,
    }, request.sId!);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      showsnack(
        title: response['status'] ?? "tm",
        message: response['message'] ?? "",
      );
      Get.close(2);
      getProcessingRequest();
    } else {
      showsnack(
        title: response['status'] ?? "no",
        message: response['message'] ?? "now",
      );
    }
    update();
  }
}
