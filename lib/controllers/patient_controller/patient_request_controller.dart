import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/patient_controller/submitting_request_patient_controller.dart';
import 'package:gr_flutter/controllers/fill_request_controller.dart';
import 'package:gr_flutter/services/functions/filter_request_with_conditions.dart';
import 'package:gr_flutter/views/patient_views/dialog_request/dialog_update_request.dart';
import 'package:gr_flutter/views/patient_views/dialog_submit_request.dart';
import 'package:gr_flutter/views/widgets/show_request.dart';
import 'package:gr_flutter/views/widgets/submit_dialog.dart';

import '../../models/request_model.dart';
import '../../services/functions/handling_data.dart';
import '../../services/remote/request_remote.dart';
import '../../services/shared/auth_model.dart';
import '../../utils/app_constants/status_request.dart';
import '../../utils/app_constants/tooth_constants.dart';
import '../../views/widgets/bottom_controller.dart';
import 'patient_under_show_request.dart';

abstract class PatientRequestController extends GetxController {
  refreshData();
  fetchItems();
  fetchFilterItems();
  showRequest(int index);
  toUpdateMode(RequestReceiveModel r);
  toCancelUpdateMode();
  sendUpdateData();
  deleteRequest(String id);
  List<dynamic> getListRequest();
  toPageView(int page);
  sendRequest();
  cancelSendRequest();
  updateRequest(String id);
  cancelUpdateRequest();
}

class PatientRequestControllerImp extends PatientRequestController {
  // FillRequestControllerImp fillRequestControllerImp =Get.find<FillRequestControllerImp>();
  // FillRequestControllerImp fillRequestControllerImp =Get.put(FillRequestControllerImp());
  late final FillRequestControllerImp fillRequestController;
  bool isUpdate = false;
  AuthModel authModel = AuthModel();
  List requestList = <RequestReceiveModel>[];
  List requestListPending = <RequestReceiveModel>[];
  List requestListProcessing = <RequestReceiveModel>[];
  List requestListDone = <RequestReceiveModel>[];
  List currentListRequest = <RequestReceiveModel>[];
  List typeStatus = ['pending', 'processing', 'done'];
  late StatusRequest statusRequest;
  late PageController pageController;
  int currentPageFilter = 0;
  RequestRemote requestRemote = RequestRemote(Get.find());

  @override
  void onInit() {
    fillRequestController = Get.put(FillRequestControllerImp());
    pageController = PageController(initialPage: 0);
    fetchItems();
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
    fetchItems();
    fetchFilterItems();
    update();
  }

  @override
  fetchItems() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await requestRemote.fetchingMyData();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      requestList = response['data']
          .map((item) => RequestReceiveModel.fromJson(item))
          .toList();
      fetchFilterItems();
    }
    update();
  }

  @override
  sendUpdateData() async {
    statusRequest = StatusRequest.loading;
    update();
  }

  late int i;
  @override
  showRequest(int index) {
    i = index;
    Get.dialog(
      ShowRequest(
        requestModel: getListRequest()[index],
        toothLocation: ToothConstants.toothLocationMap,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomContainer(
                body: "حذف",
                onTap: () {
                  Get.dialog(
                SubmitDialog(
                  title: "انتباه! ",
                  question:
                      "هل انت متأكد من رغبتك بحذف هذا الطلب ؟\n لا يمكن التراجع عن هذا الإجراء...",
                  onTapSubmit: () {
                    deleteRequest(getListRequest()[index].id);
                    Get.close(2);
                  },
                ),
              );
                },
              ),
              BottomContainer(
                  body: "تعديل",
                  onTap: () {
                    Get.snackbar(
                        "تم تفعيل وضع التعديل", "قم بتعديل المعلومات الخاطئة");
                    Get.snackbar("", "${getListRequest()[index]}");
                    Get.close(1);
                    fillRequestController.fromReceiveToSend(getListRequest()[index]);
                    Get.dialog(
                      DialogUpdateRequest(
                        cancel: () {cancelUpdateRequest();},
                        update: () {
                          Get.dialog(
                            SubmitDialog(
                              title: " انتباه ",
                              question: "هل انت متأكد من صحة البيانات؟ ",
                              onTapSubmit: () {
                                fillRequestController
                        .updateRequest(getListRequest()[index].id);
                        refreshData();
                        Get.close(2);
                              },
                            ),
                          );
                          
                        },
                      ),
                    );
                    
                  }),
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
  toUpdateMode(r) {
    // final SubmittingRequestPatientControllerImp cntr =
    //     Get.put(SubmittingRequestPatientControllerImp());
    // cntr.xx(r);
    Get.close(1);
    Get.dialog(Center(
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
    ));
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

  @override
  fetchFilterItems() {
    requestListPending = filterRequestWithConditions(
      requestList.cast(),
      [(request) => request.status == 'pending'],
    );
    requestListProcessing = filterRequestWithConditions(
      requestList.cast(),
      [(request) => request.status == 'processing'],
    );
    requestListDone = filterRequestWithConditions(
      requestList.cast(),
      [(request) => request.status == 'done'],
    );
    update();
  }

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
  List<dynamic> getListRequest() {
    if (currentPageFilter == 0) {
      return requestListPending;
    } else if (currentPageFilter == 1) {
      return requestListProcessing;
    } else {
      return requestListDone;
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
}
