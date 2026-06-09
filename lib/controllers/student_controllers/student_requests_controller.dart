import 'package:get/get.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/models/student_models/accept_request_model.dart';
import 'package:gr_flutter/models/requests_models/pending_request_model.dart';
import 'package:gr_flutter/models/requests_models/treatment_request_processing_s_model.dart';
import 'package:gr_flutter/services/remote/public_remotes/request_remote.dart';
import 'package:gr_flutter/views/widgets/botton_controller.dart';
import 'package:gr_flutter/views/widgets/requests/show_request_processing.dart';
import 'package:gr_flutter/views/widgets/requests/student_dunning_request.dart';

import '../../services/functions/handling_data.dart';
import '../../utils/app_constants/status_request.dart';
import '../../utils/app_constants/tooth_constants.dart';

abstract class StudentRequestsController extends GetxController {
  showRequest(PendingRequestModel requestModel);
  getPendingRequests();

  agreeRequest(String idR, String idO);
  getOwnedStudentRequest();
  // طلبات التي يشرف عليها الطالب
  showMyRequest();
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

      getPendingRequests();
      Get.close(1);
    }
    update();
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



