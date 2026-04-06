import 'package:get/get.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/controllers/student_controller/student_under_show_request.dart';
import 'package:gr_flutter/models/request_model.dart';
import 'package:gr_flutter/services/functions/filter_request_with_conditions.dart';
import 'package:gr_flutter/services/functions/sort_requests.dart';
import 'package:gr_flutter/services/remote/request_remote.dart';
import 'package:gr_flutter/services/shared/auth_model.dart';
import 'package:gr_flutter/views/widgets/submit_dialog.dart';

import '../../services/functions/handling_data.dart';
import '../../utils/app_constants/status_request.dart';
import '../../utils/app_constants/tooth_constants.dart';
import '../../views/widgets/show_request.dart';

abstract class StudentRequestsController extends GetxController {
  showRequest(int index);
  fetchItems();
  updateFilterRequest(int index);
  updateFilterExpaded(int index);
  agreeRequest(AcceptRequestModel data, String id);
  getOwnedStudentRequest();
  // طلبات التي يشرف عليها الطالب
  showMyRequest();
}

class StudentRequestsControllerImp extends StudentRequestsController {
  AuthModel authModel = AuthModel();
  List requestList = <RequestReceiveModel>[];
  List requestSpecialList = <RequestReceiveModel>[];
  List<RequestReceiveModel> requestListFilter = <RequestReceiveModel>[];
  late StatusRequest statusRequest;
  String filterRequest = ToothConstants.filterRequest[0];
  String filterExpanded = ToothConstants.sortBy[0];
  List<String> listFilterExpanded = ToothConstants.sortBy;
  RequestRemote requestRemote = RequestRemote(Get.find());
  @override
  void onInit() {
    fetchItems();
    fetchFilterItems();
    super.onInit();
  }

  fetchFilterItems() {
    if (filterRequest == ToothConstants.filterRequest[0]) {
      if (filterExpanded == ToothConstants.sortBy[0]) {
        requestListFilter = sortRequest(
          requestList.cast(),
          (request) => request.updatedAt,
        );
      } else {
        requestListFilter = sortRequest(
            requestList.cast(), (request) => request.updatedAt,
            asc: false);
      }
    }
    if (filterRequest == ToothConstants.filterRequest[1]) {
      requestListFilter = filterRequestWithConditions(
        requestList.cast(),
        [
          (request) => request.caseType == filterExpanded,
        ],
      );
    }
    if (filterRequest == ToothConstants.filterRequest[2]) {
      if (filterExpanded == ToothConstants.painSeverity[0]) {
        requestListFilter = sortRequest(
          requestList.cast(),
          (request) => request.painSeverity,
        );
      } else {
        requestListFilter = sortRequest(
            requestList.cast(), (request) => request.painSeverity,
            asc: false);
      }
    }
    if (filterRequest == ToothConstants.filterRequest[3]) {
      requestListFilter = filterRequestWithConditions(
        requestList.cast(),
        [
          (request) => request.toothLocation == filterExpanded,
        ],
      );
    }

    update();
  }

  @override
  fetchItems() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.fetchingData();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      requestList = response['data']
          .map((item) => RequestReceiveModel.fromJson(item))
          .toList();

      // print("$requestList");
    }
    // print("${response['data']}");
    fetchFilterItems();
    update();
  }

  @override
  agreeRequest(AcceptRequestModel data, String id) async {
    // Get.snackbar("تمت المطالبة بنجاح", "سوف يتم مراجعة طلبك من قبل المشرف");
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.acceptRequestData(data.toJson(), id);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      print("$response");
      Get.snackbar("${response['status']}", "${response['message']}");

      fetchItems();
      Get.close(1);
    }
    update();
  }

  late int i;
  @override
  showRequest(int index) {
    i = index;
    Get.dialog(
      ShowRequest(
        requestModel: requestListFilter[index],
        toothLocation: ToothConstants.toothLocationMap,
        children: [
          StudentUnderShowRequest(
            onAgreeTap: () {
              AcceptRequestModel data = AcceptRequestModel(
                date: DateTime.now().toString().split(' ')[0],
                hour: "10:00 AM",
                location: "Main Clinic",
              );
              reservation(data, requestListFilter[index].id!);
            },
          )
        ],
      ),
    );
  }
  showOnedRequest(int index) {
    i = index;
    Get.dialog(
      ShowRequest(
        requestModel: requestSpecialList[index],
        toothLocation: ToothConstants.toothLocationMap,
        children: [
          // StudentUnderShowRequest(
          //   onAgreeTap: () {
          //     AcceptRequestModel data = AcceptRequestModel(
          //       date: DateTime.now().toString().split(' ')[0],
          //       hour: "10:00 AM",
          //       location: "Main Clinic",
          //     );
          //     reservation(data, requestSpecialList[index].id!);
          //   },
          // ),
        ],
      ),
    );
  }

  reservation(AcceptRequestModel data, String id) {
    Get.dialog(
      SubmitDialog(
        title: "تحذير مهم !",
        question:
            "هل أنت متأكد من رغبتك في حجز هذه الحالة ؟؟ \n عند مطالبتك بهذه الحالة فإنك تضع المسؤولية على عاتقك \n إقرأ سياسة الخصوصية ",
        onTapSubmit: () {
          Get.close(1);
          agreeRequest(data, id);
        },
      ),
    );
  }

  @override
  updateFilterRequest(int index) {
    filterRequest = ToothConstants.filterRequest[index];
    if (filterRequest == ToothConstants.filterRequest[0]) {
      filterExpanded = ToothConstants.sortBy[0];
      listFilterExpanded = ToothConstants.sortBy;
      update();
    }

    if (filterRequest == ToothConstants.filterRequest[2]) {
      filterExpanded = ToothConstants.painSeverity[0];
      listFilterExpanded = ToothConstants.painSeverity;
      update();
    }
    if (filterRequest == ToothConstants.filterRequest[1]) {
      filterExpanded = ToothConstants.caseTypeAr[0];
      listFilterExpanded = ToothConstants.caseTypeAr;
      update();
    }
    if (filterRequest == ToothConstants.filterRequest[3]) {
      listFilterExpanded = ToothConstants.toothLocationList;
      filterExpanded = listFilterExpanded[0];
      update();
    }
    fetchFilterItems();
  }

  @override
  updateFilterExpaded(int index) {
    if (filterRequest == ToothConstants.filterRequest[1]) {
      filterExpanded = ToothConstants.caseTypeAr[index];
      update();
    }
    if (filterRequest == ToothConstants.filterRequest[3]) {
      filterExpanded = ToothConstants.toothLocationList[index];
      update();
    }
    if (filterRequest == ToothConstants.filterRequest[0]) {
      filterExpanded = ToothConstants.sortBy[index];
      update();
    }
    if (filterRequest == ToothConstants.filterRequest[2]) {
      filterExpanded = ToothConstants.painSeverity[index];
      update();
    }
    fetchFilterItems();
  }

  @override
  getOwnedStudentRequest() async {
    Get.snackbar("جاري جلب الطلبات الخاصة بك", "يرجى الانتظار...");
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.fetchingSpecialData();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      requestSpecialList = response['data']
          .map((item) => RequestReceiveModel.fromJson(item['Requestion']))
          .toList();

      // print(
      //     "====================================================${response['data']['Requestion']}");
      // print(
          // "====================================================${requestSpecialList[2].toJson()}");
      // print(
          // "====================================================${requestSpecialList[3].toJson()}");
    }
    print("${response['data']}");
    fetchFilterItems();
    update();
  }

  @override
  showMyRequest() async {
    await getOwnedStudentRequest();
    Get.toNamed(AppRroute.showOwnedStudentRequest);
  }
}
