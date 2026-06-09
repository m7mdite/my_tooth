import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/requests_controllers/fill_request_controller.dart';
import 'package:gr_flutter/models/requests_models/pending_request_model.dart';
import 'package:gr_flutter/models/requests_models/treatment_request_processing_s_model.dart';
import 'package:gr_flutter/services/functions/show_snack.dart';
import 'package:gr_flutter/views/patient_views/dialog_request/dialog_update_request.dart';
import 'package:gr_flutter/views/widgets/requests/show_request.dart';
import 'package:gr_flutter/views/widgets/requests/show_request_processing.dart';
import 'package:gr_flutter/views/widgets/dialog/submit_dialog.dart';

import '../../services/functions/handling_data.dart';
import '../../services/remote/public_remotes/request_remote.dart';
import '../../utils/app_constants/status_request.dart';
import '../../views/widgets/botton_controller.dart';

abstract class PatientRequestController extends GetxController {
  refreshData();
  // fetchItems();
  getPendingRequest();
  getInProcessingRequest();
  getRejectedRequest();
  getCompletedRequest();
  // fetchFilterItems();
  showRequest(PendingRequestModel request);
  showProcessingRequest(TreatmentRequestProcessingSModel request);
  toUpdateMode(PendingRequestModel request);
  toCancelUpdateMode();
  sendUpdateData();
  deleteRequest(String id);
  List<dynamic> getListRequest();
  toPageView(int page);
  sendRequest();
  cancelSendRequest();
  updateRequest(String id);
  cancelUpdateRequest();
  getTreatments();
}

class PatientRequestControllerImp extends PatientRequestController {
  late final FillRequestControllerImp fillRequestController;
  bool isUpdate = false;
  // final localStorage = Get.find<LocalUserStorage>();
  late PendingRequestModel selectedRequest;
  List<PendingRequestModel> requestListPending = <PendingRequestModel>[];
  List<TreatmentRequestProcessingSModel> requestListProcessing =
      <TreatmentRequestProcessingSModel>[];
  List<TreatmentRequestProcessingSModel> requestListCompleted =
      <TreatmentRequestProcessingSModel>[];
  List<List> requestList = [];

  // List<PendingRequestModel> currentListRequest = <PendingRequestModel>[];
  List typeStatus = ['pending', 'processing', 'done', 'rejected'];
  late StatusRequest statusRequest;
  late PageController pageController;
  int currentPageFilter = 0;
  RequestRemote requestRemote = RequestRemote(Get.find());
  List<Map<String, String>> treatments = [];

  @override
  void onInit() {
    fillRequestController = Get.put(FillRequestControllerImp());
    getTreatments();
    pageController = PageController(initialPage: 0);
    getPendingRequest();
    getInProcessingRequest();
    getCompletedRequest();
    getRejectedRequest();
    requestList =[requestListPending,requestListProcessing,requestListCompleted];
    super.onInit();
  }

  @override
  sendRequest() {
    if (fillRequestController.validateForm()) {
      fillRequestController.sendRequest();
      refreshData();
      Get.close(1);
    }
    update;
  }

  @override
  cancelSendRequest() {
    fillRequestController.onClose();
    Get.snackbar("إلغاء الإرسال", "تم إلغاء الإرسال بنجاح");
    Get.close(1);
    update();
  }

  @override
  cancelUpdateRequest() {
    fillRequestController.onClose();
    Get.snackbar("إلغاء الإرسال", "تم إلغاء التعديل بنجاح");
    Get.close(1);
    update();
  }

  @override
  updateRequest(String id) {
    if (fillRequestController.validateForm()) {
      fillRequestController.updateRequest(id);
      refreshData();
      Get.close(1);
    }
    update;
  }

  @override
  refreshData() async {
    getPendingRequest();
    getInProcessingRequest();
    getCompletedRequest();
    // fetchFilterItems();
    requestList =[requestListPending,requestListProcessing,requestListCompleted];
    update();
  }

  // @override
  // fetchItems() async {
  //   statusRequest = StatusRequest.loading;
  //   update();
  //   var response = await requestRemote.fetchingMyData();
  //   statusRequest = handlingData(response);
  //   if (statusRequest == StatusRequest.success) {
  //     print("$response");
  //     requestList = (response['data'] as List)
  //         .map((item) => PendingRequestModel.fromJson(item))
  //         .toList();
  //     fetchFilterItems();
  //   }
  //   update();
  // }

  @override
  sendUpdateData() async {
    statusRequest = StatusRequest.loading;
    update();
  }

  late int i;
  @override
  showRequest(PendingRequestModel request) {
    // i = index;
    Get.dialog(
      ShowRequest(
        requestModel: request,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottonContainer(
                body: "حذف",
                onTap: () {
                  Get.dialog(
                    SubmitDialog(
                      title: "انتباه! ",
                      question:
                          "هل انت متأكد من رغبتك بحذف هذا الطلب ؟\n لا يمكن التراجع عن هذا الإجراء...",
                      onTapSubmit: () {
                        deleteRequest(request.sId ?? "");
                        Get.close(2);
                      },
                    ),
                  );
                },
              ),
              BottonContainer(
                body: "تعديل",
                onTap: () {
                  Get.snackbar(
                      "تم تفعيل وضع التعديل", "قم بتعديل المعلومات الخاطئة");
                  Get.snackbar("", "$request");
                  Get.close(1);
                  fillRequestController.pendingRequestModel = request;
                  Get.dialog(
                    DialogUpdateRequest(
                      cancel: () {
                        cancelUpdateRequest();
                      },
                      update: () {
                        Get.dialog(
                          SubmitDialog(
                            title: " انتباه ",
                            question: "هل انت متأكد من صحة البيانات؟ ",
                            onTapSubmit: () {
                              fillRequestController.updateRequest(request.sId!);
                              refreshData();
                              Get.close(2);
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),

          // onCancelUpdateTap: () {
          //   toCancelUpdateMode();
          // },
          // onSendUpdateTap: () {
          //   Get.dialog(SubmitDialog(
          //     title: " انتباه ",
          //     question: "هل انت متأكد من صحة البيانات؟ ",
          //     onTapSubmit: () {
          //       sendUpdateData();
          //     },
          // ),
          // );
          // },
        ],
      ),
    );
  }

  @override
  toUpdateMode(request) {
    // final SubmittingRequestPatientControllerImp cntr =
    //     Get.put(SubmittingRequestPatientControllerImp());
    // cntr.xx(r);
    Get.close(1);
    Get.dialog(
      Center(
        child: AnimatedContainer(
          height: Get.height * 0.8,
          width: Get.width * 0.9,
          duration: Duration(milliseconds: 1800),
          curve: Curves.easeIn,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 1.5,
            ),
            color: const Color.fromARGB(40, 255, 255, 255),
            borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(100, 10),
              bottomLeft: Radius.elliptical(10, 100),
              topRight: Radius.elliptical(10, 100),
              bottomRight: Radius.elliptical(100, 10),
            ),
          ),
          // child:
          //  DialogSubmitRequest(
          //   // onTapSubmit: () => cntr.updateRequest(r.id!),
          //   // onTapCancel: cntr.cancelRequest,
          // ),
        ),
      ),
    );
    update();
  }

  @override
  toCancelUpdateMode() {
    isUpdate = false;
    Get.close(1);
    Get.snackbar(
      "إلغاء التعديل",
      "تم إلغاء تعديل البيانات",
    );
    update();
  }

  // @override
  // fetchFilterItems() {
  //   // requestListPending = filterRequestWithConditions(
  //   //   requestList.cast(),
  //   //   [(request) => request.status == 'pending'],
  //   // );
  //   // requestListProcessing = filterRequestWithConditions(
  //   //   requestList.cast(),
  //   //   [(request) => request.status == 'processing'],
  //   // );
  //   // requestListDone = filterRequestWithConditions(
  //   //   requestList.cast(),
  //   //   [(request) => request.status == 'done'],
  //   // );
  //   requestListPending = requestList.cast();
  //   update();
  // }

  @override
  deleteRequest(String id) async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.deleteRequest(id);
    print("$response");
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      Get.snackbar("done", "مشي الحال");
    }
    refreshData();
  }

  @override
  List getListRequest() {
    if (currentPageFilter == 0) {
      return requestListPending;
    } else if (currentPageFilter == 1) {
      return requestListProcessing;
    } else {
      return requestListCompleted;
    }
  }

  @override
  toPageView(int page) {
    pageController.animateToPage(
      page,
      duration: Duration(seconds: 1),
      curve: Curves.easeOutSine,
    );
  }

  @override
  getTreatments() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.getTreatments();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      showsnack(message: "تم جلب العلاجات بنجاح");
      treatments= (response['data'] as List)
          .map((item) => {
                'id': item['_id'].toString(),
                'case_type': item['case_type'].toString(),
              })
          .toList(); 
      // for (var item in response['data']) {
      //   print("=============== ${item} ==================");
      //   treatments.add({
      //     'id': item['_id'].toString(),
      //     'case_type': item['case_type'].toString(),
      //   });
      // }
      // treatments = response['data'];
    }
  }

  @override
  getCompletedRequest() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.getCompletedPatientRequest();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      print("$response");
      requestListCompleted = (response['data'] as List)
          .map((item) => TreatmentRequestProcessingSModel.fromJson(item))
          .toList();
    }
    update();
  }

  @override
  getInProcessingRequest() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.getInProcessingPatientRequest();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      print("حقخسس     $response");
      requestListProcessing = (response['data'] as List)
          .map((item) => TreatmentRequestProcessingSModel.fromJson(item))
          .toList();
    }
    update();
  }

  @override
  getPendingRequest() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.getPendingPatientRequest();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      print("$response");
      requestListPending = (response['data'] as List)
          .map((item) => PendingRequestModel.fromJson(item))
          .toList();
    }
    update();
  }

  @override
  getRejectedRequest() {
    
  }
  
  @override
  showProcessingRequest(TreatmentRequestProcessingSModel request) {
    Get.dialog(ShowRequestProcessing(requestModel: request));
  }
}
