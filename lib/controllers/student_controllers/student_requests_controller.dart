import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/models/student_models/accept_request_model.dart';
import 'package:gr_flutter/services/remote/public_remotes/request_remote.dart';
import 'package:gr_flutter/views/widgets/botton_controller.dart';
import 'package:gr_flutter/views/widgets/requests/show_request_processing.dart';
import 'package:gr_flutter/views/widgets/requests/student_dunning_request.dart';

import '../../models/requests_models/treatment_request_model.dart';
import '../../services/functions/handling_data.dart';
import '../../utils/app_constants/status_request.dart';
import '../../utils/app_constants/tooth_constants.dart';

abstract class StudentRequestsController extends GetxController {
  showRequest(TreatmentRequestModel requestModel);
  // getPendingRequests();

  agreeRequest(String idR, String idO);
  getProcessingRequest();
  // طلبات التي يشرف عليها الطالب
  showMyRequest();
  getOverSeer(String id);
}

class StudentRequestsControllerImp extends StudentRequestsController {
  RxInt currentPageIndex = 0.obs;
  PageController pageController = PageController(initialPage: 0);
  List completedRequests = <TreatmentRequestModel>[];
  // AuthModel authModel = AuthModel();
  List pendingRequests = <TreatmentRequestModel>[];
  List processingRequests = <TreatmentRequestModel>[];
  // List<TreatmentRequestModel> requestListFilter = <TreatmentRequestModel>[];
  late StatusRequest statusRequest;
  String filterRequest = ToothConstants.filterRequest[0];
  String filterExpanded = ToothConstants.sortBy[0];
  List<String> listFilterExpanded = ToothConstants.sortBy;
  RequestRemote requestRemote = RequestRemote(Get.find());
  List overseersCourse = [];
  String selectOverseer = "";
  AcceptRequestModel acceptRequestModel = AcceptRequestModel();
  @override
  void onInit() {
    getPendingRequests();

    // fetchFilterItems();
    super.onInit();
  }

  @override
  getPendingRequests() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.getPendingRequests();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      pendingRequests = (response['data'])
          .map((item) => TreatmentRequestModel.fromJson(item))
          .toList();
    }
    update();
  }

  @override
  agreeRequest(String idR, String idO) async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.acceptRequestData({}, idR, idO);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      print("===========================$response");
      Get.snackbar("${response['status']}", "${response['message']}");

      getPendingRequests();
      Get.close(1);
    }
    update();
  }

  Future<void> getCompletedRequests() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.getCompletedRequest();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      completedRequests = (response['data'] as List)
          .map((item) => TreatmentRequestModel.fromJson(item))
          .toList();
    }
    update();
  }

  void changePage(int index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
    update();
  }

// ===== جلب البيانات حسب الصفحة =====
  List getCurrentPageData() {
    if (currentPageIndex.value == 0) {
      return processingRequests; // قيد المعالجة
    } else {
      return completedRequests; // مكتملة
    }
  }

  // @override
  dunningOverseerRequest(
      AcceptRequestModel data, String idR, String idO) async {
    // Get.snackbar("تمت المطالبة بنجاح", "سوف يتم مراجعة طلبك من قبل المشرف");
    statusRequest = StatusRequest.loading;
    update();
    var response =
        await requestRemote.dunningOverseerData(data.toJson(), idR, idO);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      print("$response");
      Get.snackbar("${response['status']}", "${response['message']}");

      getPendingRequests();
      Get.close(1);
    }
    update();
  }

  // late int i;
  @override
  showRequest(TreatmentRequestModel requestModel) async {
    // i = index;
    await getOverSeer(requestModel.courseInfo!.sId!);
    print("======== ${requestModel.courseInfo!.sId!}");
    Get.dialog(StudentDunningRequest(requestModel: requestModel));
  }

  showOnedRequest(TreatmentRequestModel requestModel) {
    // i = index;
    getOverSeer(requestModel.courseInfo!.sId ?? "");
    Get.dialog(
      ShowRequestProcessing(
        requestModel: requestModel,
        children: [
          if (requestModel.overseer == null)
            BottonContainer(
              body: "تعيين مشرف",
              onTap: () {
                if (overseersCourse.isEmpty) {
                  Get.snackbar("لا يوجد مشرفين لهذا المقرر",
                      "يرجى التواصل مع الإدارة لتعيين مشرف لهذا المقرر");
                  return;
                }
                Get.dialog(
                  StudentSelectOverseer(
                    onTapSubmit: () {
                      dunningOverseerRequest(acceptRequestModel,
                          requestModel.sId ?? "", selectOverseer);
                      Get.close(1);
                      onInit();
                    },
                  ),
                );
              },
            )
        ],
      ),
    );
  }

  @override
  getProcessingRequest() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.getProcessingRequest();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      processingRequests = response['data']
          .map((item) => TreatmentRequestModel.fromJson(item))
          .toList();
    }
    print("${response['data']}");
    update();
  }

  @override
  showMyRequest() async {
    currentPageIndex.value=0;
    await getProcessingRequest();
    await getCompletedRequests();
    Get.toNamed(AppRroute.showOwnedStudentRequest);
  }

  @override
  getOverSeer(String id) async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.getOverSeerForCourse(id);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      response['data'] == null || response['data'] == []
          ? overseersCourse = []
          : overseersCourse = response['data'] as List;

      print("$overseersCourse");
    }
    update();
  }
}
