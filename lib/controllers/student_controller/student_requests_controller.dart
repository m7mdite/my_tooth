import 'package:get/get.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/controllers/student_controller/student_under_show_request.dart';
import 'package:gr_flutter/models/accept_request_model.dart';
import 'package:gr_flutter/models/pending_request_model.dart';
import 'package:gr_flutter/models/treatment_model.dart';
import 'package:gr_flutter/models/treatment_request_processing_s_model.dart';
import 'package:gr_flutter/services/functions/filter_request_with_conditions.dart';
import 'package:gr_flutter/services/functions/sort_requests.dart';
import 'package:gr_flutter/services/remote/request_remote.dart';
import 'package:gr_flutter/services/shared/auth_model.dart';
import 'package:gr_flutter/views/widgets/bottom_controller.dart';
import 'package:gr_flutter/views/widgets/requests/show_request_processing.dart';
import 'package:gr_flutter/views/widgets/requests/student_dunning_request.dart';
import 'package:gr_flutter/views/widgets/select_over_seer.dart';
import 'package:gr_flutter/views/widgets/submit_dialog.dart';

import '../../services/functions/handling_data.dart';
import '../../utils/app_constants/status_request.dart';
import '../../utils/app_constants/tooth_constants.dart';
import '../../views/widgets/requests/show_request.dart';

abstract class StudentRequestsController extends GetxController {
  showRequest(PendingRequestModel requestModel);
  fetchItems();
  // updateFilterRequest(int index);
  // updateFilterExpaded(int index);
  agreeRequest(String idR, String idO);
  getOwnedStudentRequest();
  // طلبات التي يشرف عليها الطالب
  // showMyRequest();
  getOverSeer(String id);
}

class StudentRequestsControllerImp extends StudentRequestsController {
  // AuthModel authModel = AuthModel();
  List requestList = <PendingRequestModel>[];
  List requestSpecialList = <TreatmentRequestProcessingSModel>[];
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
    fetchItems();

    // fetchFilterItems();
    super.onInit();
  }

  @override
  fetchItems() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.fetchingData();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      requestList = (response['data'])
          .map((item) => PendingRequestModel.fromJson(item))
          .toList();

      // print("$requestList");
    }
    // print("${response['data']}");
    // fetchFilterItems();
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

      fetchItems();
      Get.close(1);
    }
    update();
  }

  @override
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

      fetchItems();
      Get.close(1);
    }
    update();
  }

  // late int i;
  @override
  showRequest(PendingRequestModel requestModel) async {
    // i = index;
    await getOverSeer(requestModel.courseInfo!.sId!);
    // if (overseersCourse.isEmpty) {
    //   Get.snackbar("لا يوجد مشرفين لهذا المقرر",
    //       "يرجى التواصل مع الإدارة لتعيين مشرف لهذا المقرر");
    //   return;
    // }
    print("======== ${requestModel.courseInfo!.sId!}");
    Get.dialog(StudentDunningRequest(requestModel: requestModel));
  }

  showOnedRequest(TreatmentRequestProcessingSModel requestModel) {
    // i = index;
    getOverSeer(requestModel.courseInfo!.sId ?? "");
    Get.dialog(
      ShowRequestProcessing(
        requestModel: requestModel,
        children: [
          if (requestModel.overseer == null)
            BottomContainer(
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
  getOwnedStudentRequest() async {
    // Get.snackbar("جاري جلب الطلبات الخاصة بك", "يرجى الانتظار...");
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.fetchingSpecialData();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      requestSpecialList = response['data']
          .map((item) => TreatmentRequestProcessingSModel.fromJson(item))
          .toList();
    }
    print("${response['data']}");
    // fetchFilterItems();
    update();
  }

  @override
  showMyRequest() async {
    await getOwnedStudentRequest();
    Get.toNamed(AppRroute.showOwnedStudentRequest);
  }

  @override
  getOverSeer(String id) async {
    // Get.snackbar("جاري جلب المشرفين الخاصة بك", "يرجى الانتظار...");
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





  // fetchFilterItems() {
  //   if (filterRequest == ToothConstants.filterRequest[0]) {
  //     if (filterExpanded == ToothConstants.sortBy[0]) {
  //       requestListFilter = sortRequest(
  //         requestList.cast(),
  //         (request) => request.updatedAt!,
  //       );
  //     } else {
  //       requestListFilter = sortRequest(
  //           requestList.cast(), (request) => request.updatedAt!,
  //           asc: false);
  //     }
  //   }
  //   if (filterRequest == ToothConstants.filterRequest[1]) {
  //     requestListFilter = filterRequestWithConditions(
  //       requestList.cast(),
  //       [
  //         // (request) => request.caseType == filterExpanded,
  //       ],
  //     );
  //   }
  //   if (filterRequest == ToothConstants.filterRequest[2]) {
  //     if (filterExpanded == ToothConstants.painSeverity[0]) {
  //       requestListFilter = sortRequest(
  //         requestList.cast(),
  //         (request) => request.painSeverity!,
  //       );
  //     } else {
  //       requestListFilter = sortRequest(
  //           requestList.cast(), (request) => request.painSeverity!,
  //           asc: false);
  //     }
  //   }
  //   if (filterRequest == ToothConstants.filterRequest[3]) {
  //     requestListFilter = filterRequestWithConditions(
  //       requestList.cast(),
  //       [
  //         (request) => request.toothLocation == filterExpanded,
  //       ],
  //     );
  //   }

  //   update();
  // }

  // =============================================

  // @override
  // updateFilterRequest(int index) {
  //   filterRequest = ToothConstants.filterRequest[index];
  //   if (filterRequest == ToothConstants.filterRequest[0]) {
  //     filterExpanded = ToothConstants.sortBy[0];
  //     listFilterExpanded = ToothConstants.sortBy;
  //     update();
  //   }

  //   if (filterRequest == ToothConstants.filterRequest[2]) {
  //     filterExpanded = ToothConstants.painSeverity[0];
  //     listFilterExpanded = ToothConstants.painSeverity;
  //     update();
  //   }
  //   if (filterRequest == ToothConstants.filterRequest[1]) {
  //     filterExpanded = ToothConstants.caseTypeAr[0];
  //     listFilterExpanded = ToothConstants.caseTypeAr;
  //     update();
  //   }
  //   if (filterRequest == ToothConstants.filterRequest[3]) {
  //     listFilterExpanded = ToothConstants.toothLocationList;
  //     filterExpanded = listFilterExpanded[0];
  //     update();
  //   }
  //   // fetchFilterItems();
  // }

  // @override
  // updateFilterExpaded(int index) {
  //   if (filterRequest == ToothConstants.filterRequest[1]) {
  //     filterExpanded = ToothConstants.caseTypeAr[index];
  //     update();
  //   }
  //   if (filterRequest == ToothConstants.filterRequest[3]) {
  //     filterExpanded = ToothConstants.toothLocationList[index];
  //     update();
  //   }
  //   if (filterRequest == ToothConstants.filterRequest[0]) {
  //     filterExpanded = ToothConstants.sortBy[index];
  //     update();
  //   }
  //   if (filterRequest == ToothConstants.filterRequest[2]) {
  //     filterExpanded = ToothConstants.painSeverity[index];
  //     update();
  //   }
  //   fetchFilterItems();
  // }
