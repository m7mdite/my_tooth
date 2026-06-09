import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/models/requests_models/treatment_model.dart';
import 'package:gr_flutter/models/requests_models/treatment_request_processing_s_model.dart';
import 'package:gr_flutter/services/functions/show_snack.dart';
import 'package:gr_flutter/views/widgets/requests/overseer_manage_request.dart';
import 'package:gr_flutter/views/widgets/dialog/submit_dialog.dart';

import '../../services/functions/handling_data.dart';
import '../../services/remote/public_remotes/request_remote.dart';
import '../../utils/app_constants/status_request.dart';
import '../../views/overseer_views/overseer_view_request_processing.dart';
import '../../views/widgets/requests/overseer_reject_request.dart';

abstract class OverseerRequestsController extends GetxController {
  // تعريف الدوال التي ستستخدم في التحكم في الطلبات
  getTreatmentRequests();
  showRequest(TreatmentRequestProcessingSModel request);
  toRejectRequest(TreatmentRequestProcessingSModel request);
  rejectRequest(TreatmentRequestProcessingSModel request);
  manageRequest(TreatmentRequestProcessingSModel request);
  changeCaseRequest(TreatmentRequestProcessingSModel request);
  toManageRequest(TreatmentRequestProcessingSModel request);
  addEvaluationRequest(TreatmentRequestProcessingSModel request);
  finishRequest(TreatmentRequestProcessingSModel request);
  getAllTreatment();
}

class OverseerRequestsControllerImpl extends OverseerRequestsController {
  List<String> rejectCase = [
    "كبسة",
    "مندي",
    "كريستيانو",
  ];
  List<TreatmentRequestProcessingSModel> requestList =
      <TreatmentRequestProcessingSModel>[];
  TreatmentRequestProcessingSModel selectRequest =
      TreatmentRequestProcessingSModel();
  List<TreatmentModel> treatments = <TreatmentModel>[];
  RequestRemote requestRemote = RequestRemote(Get.find());
  late StatusRequest statusRequest;
  late TextEditingController textEditingControllerReject;
  late TextEditingController textEditingControllerFeedback;
  late TextEditingController textEditingControllerRating;
  late TextEditingController textEditingControllerNote;
  late TextEditingController textEditingControllerAddEvaluation;

  bool rejectBool = false;
  bool finishBool = false;
  TreatmentModel? selectnewTreatment;
  formatTextEditing(){
    textEditingControllerAddEvaluation =TextEditingController();
    textEditingControllerFeedback =TextEditingController();
    textEditingControllerNote =TextEditingController();
    textEditingControllerRating =TextEditingController();
    textEditingControllerReject =TextEditingController();
  }
  @override
  void onInit() {
    formatTextEditing();
    getAllTreatment();
    
    getTreatmentRequests();
    update();
    super.onInit();
    // يمكنك هنا جلب البيانات أو تهيئة المتغيرات اللازمة
  }

  @override
  getTreatmentRequests() async {
    requestList = [];
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.getTreatmentRequestsForOverseer();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      requestList = (response['data'] as List)
          .map((e) => TreatmentRequestProcessingSModel.fromJson(e))
          .toList();
    }
    update();
  }

  @override
  showRequest(TreatmentRequestProcessingSModel request) {
    selectRequest = request;
    Get.dialog(
      OverseerViewRequestProcessing(requestModel: request),
    );
  }

  @override
  toRejectRequest(TreatmentRequestProcessingSModel request) {
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
  toManageRequest(TreatmentRequestProcessingSModel request) {
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
  rejectRequest(TreatmentRequestProcessingSModel request) async {
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
        getTreatmentRequests();
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
  manageRequest(TreatmentRequestProcessingSModel request) async {
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
  changeCaseRequest(TreatmentRequestProcessingSModel request) async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.changeCaseRequestData(
        {"note": textEditingControllerNote.text},
        request.sId!,
        selectnewTreatment!.caseType!.sId ?? "69e8f1f661485d1812ce0046");
    statusRequest = handlingData(response);
    print("===============$response");
    if (statusRequest == StatusRequest.success) {
      showsnack(
          title: response['status'] ?? "tm",
          message: response['message'] ?? "");
      Get.close(2);
      getTreatmentRequests();
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
    print("----------------------- $response");
    if (statusRequest == StatusRequest.success) {
      treatments = (response['data'] as List)
          .map((item) => TreatmentModel.fromJson(item))
          .toList();
          selectnewTreatment =treatments[0];
    }
    update();
  }

  @override
  addEvaluationRequest(TreatmentRequestProcessingSModel request) async {
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
      getTreatmentRequests();
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
  finishRequest(TreatmentRequestProcessingSModel request) async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.complateRequestData({
      "rating": textEditingControllerRating.text,
      "feedback": textEditingControllerFeedback.text,
    }, request.sId!);
    statusRequest = handlingData(response);
    print("dddddddddddddddddddddddddddddddddddd $response");
    if (statusRequest == StatusRequest.success) {
      showsnack(
        title: response['status'] ?? "tm",
        message: response['message'] ?? "",
      );
      Get.close(2);
      getTreatmentRequests();
    } else {
      showsnack(
        title: response['status'] ?? "no",
        message: response['message'] ?? "now",
      );
    }
  }
}
