import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/controllers/admin_controllers/admin_users_controller.dart';
import 'package:gr_flutter/models/requests_models/pending_request_model.dart';
import 'package:gr_flutter/models/requests_models/treatment_request_processing_s_model.dart';
import 'package:gr_flutter/services/functions/show_snack.dart';

import '../../models/admin_models/course_model.dart';
import '../../models/public_models/profile_model.dart';
import '../../models/requests_models/treatment_model.dart';
import '../../services/functions/handling_data.dart';
import '../../services/remote/admin_remotes/admin_remote.dart';
import '../../utils/app_constants/status_request.dart';

abstract class AdminRequestController extends GetxController {
  toAddCoursePage();
  toAddTreatmentPage();
  toAddLessonsPage();
  toAddCategoryPage();
  toViewTreatmentsPage();
  toViewCoursesPage();
  toViewCategorysPage();
  toViewPendingRequestsPage();
  toViewInProcessingRequestsPage();
  toViewFinishedRequestsPage();
  toViewRejectedRequestsPage();
  addTreatment();
  addCourse();
  addLesson();
  addCategory();
  getAllTreatments();
  getAllCourses();
  getAllOverSeers();
  getAllCategory();
  getAllPendingRequests();
  getAllInProcessingRequests();
  getAllFinishedRequests();
  getAllRejectedRequests();
  deleteCategory(String id);
}

class AdminRequestControllerImpl extends AdminRequestController {
  AdminUsersControllerImpl adminUsersControllerImpl =
      Get.put(AdminUsersControllerImpl());
  late StatusRequest statusRequest;
  AdminRemote adminRemote = AdminRemote(Get.find());
  List<TreatmentModel> treatments = [];
  List<CourseModel> courses = [];
  List<ProfileModel> overSeers = [];
  List lessons = [];
  List<Map<String, String>> categorys = [];
  List<PendingRequestModel> pendingRequests =[];
  List<TreatmentRequestProcessingSModel> inProcessingRequests =[];
  List<TreatmentRequestProcessingSModel> finishedRequests =[];
  List<TreatmentRequestProcessingSModel> rejectedRequests =[];
  Map category = {};
  Map<String, dynamic> lesson = {};
  List<ProfileModel> selectedOverseers = <ProfileModel>[];
  CourseModel? selectedCourse;
  String selectedCourseId = "";
  String selectedCategoryId = "";
  String selectedDay = "";
  // String time ="$";

  TextEditingController courseNameController = TextEditingController();
  TextEditingController treatmentCaseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
// ========= variable for time
  String day = "";
  String periodLesson = "";
  String hall = "";

  @override
  void onInit() {
    getAllCourses();
    super.onInit();
  }

  @override
  toAddCoursePage() {
    overSeers = getAllOverSeers();
    // showsnack();
    Get.toNamed(AppRroute.addCourse);
  }

  @override
  toAddTreatmentPage() {
    getAllTreatments();
    Get.toNamed(AppRroute.addTreatment);
  }

  @override
  toViewCoursesPage() {
    getAllCourses();

    Get.toNamed(AppRroute.viewCourses);
  }

  @override
  toViewTreatmentsPage() {
    getAllTreatments();
    Get.toNamed(AppRroute.viewTreatments);
  }

  @override
  addTreatment() async {
    if (selectedCourse == null) {
      showsnack(title: "خطأ", message: "الرجاء اختيار كورس");
      return;
    }
    if (treatmentCaseController.text.trim().isEmpty) {
      showsnack(title: "خطأ", message: "الرجاء إدخال حالة المعالجة");
      return;
    }
    Map data = {
      "case_type": treatmentCaseController.text,
      "course": selectedCourse!.sId,
    };
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.addTreatment(data);
    statusRequest = handlingData(response);
    print("$statusRequest");
    if (statusRequest == StatusRequest.success) {
      // print("${response}");
      Get.back();
      Get.back();
      showsnack(
          title: "${response['status']}", message: "${response['message']}");
    } else {
      showsnack(
          title: "${response['status']}", message: "${response['message']}");
    }
    update();
  }

  @override
  addCourse() async {
    statusRequest = StatusRequest.loading;
    update();
    if (courseNameController.text.trim().isEmpty) {
      showsnack(title: "خطأ", message: "الرجاء إدخال اسم الكورس");
      return;
    }
    var response =
        await adminRemote.addCourse({"course_name": courseNameController.text});
    statusRequest = handlingData(response);
    update();
    if (statusRequest == StatusRequest.success) {
      Get.back();
      showsnack(
          title: "${response['status']}", message: "${response['message']}");
    } else {
      showsnack(
          title: "${response['status']}", message: "${response['message']}");
    }
    update();
  }

  @override
  getAllCourses() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.getAllCourses();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      courses = (response['data'] as List)
          .map((course) => CourseModel.fromJson(course))
          .toList();

      showsnack(title: "Success", message: "Courses loaded successfully");
    } else {
      showsnack(title: "Error", message: "Failed to load courses");
    }
    update();
  }

  @override
  getAllTreatments() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.getAllTreatments();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      treatments = (response['data'] as List)
          .map((treatment) => TreatmentModel.fromJson(treatment))
          .toList();
      // print("${response['data']}");
      print(" ${treatments.length} treatments loaded successfully");

      showsnack(title: "Success", message: "Treatments loaded successfully");
    }
    update();
  }

  @override
  List<ProfileModel> getAllOverSeers() {
    adminUsersControllerImpl.getAllOverSeers();
    // print("${adminUsersControllerImpl.overSeers[1]}");
    return adminUsersControllerImpl.overSeers;
  }

  @override
  toAddLessonsPage() {
    overSeers = getAllOverSeers();
    getAllCourses();
    getAllCategory();
    Get.toNamed(AppRroute.addLessons);
  }

  @override
  addLesson() async {
    lesson = {
      "course": selectedCourseId,
      "category": selectedCategoryId,
      "overseers": selectedOverseers.map((o) => o.user).toList(),
      "time": "$day-$periodLesson",
      "hall": hall
    };
    print("====================$lesson");
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.addLesson(lesson);
    statusRequest = handlingData(response);
    print("+++++++++++++++++++++++++++$response");
    // if(statusRequest == StatusRequest.success){
    // showsnack(title: response['status'], message: response['message']);
    // }
    Get.back();
    update();
  }

  @override
  toAddCategoryPage() {
    Get.toNamed(AppRroute.addCategory);
  }

  @override
  toViewCategorysPage() {
    getAllCategory();
    Get.toNamed(AppRroute.viewCategorys);
    update();
  }

  @override
  addCategory() async {
    Map c = {"category": categoryController.text};
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.addCategory(c);
    statusRequest = handlingData(response);
    // if(statusRequest == StatusRequest.success){
    showsnack(title: response['status'], message: response['message']);
    // }
    Get.back();
    update();
  }

  @override
  getAllCategory() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.getAllCategory();
    statusRequest = handlingData(response);
    print("$response");
    if (statusRequest == StatusRequest.success) {
      categorys = (response['data'] as List)
          .map((c) => {
                "id": c['_id'] as String,
                "category": c['category'] as String,
              })
          .toList();
      // print("${response['data']}");
      print(" ${categorys.length} categorys loaded successfully");
      showsnack(title: response['status'], message: response['message']);
    }
    update();
  }

  @override
  toViewFinishedRequestsPage() {
    getAllFinishedRequests();
    Get.toNamed(AppRroute.viewFinishedRequests);
  }

  @override
  toViewInProcessingRequestsPage() {
    getAllInProcessingRequests();
    Get.toNamed(AppRroute.viewInProcessingRequests);
  }

  @override
  toViewPendingRequestsPage() {
    getAllPendingRequests();
    Get.toNamed(AppRroute.viewPendingRequests);
  }

  @override
  toViewRejectedRequestsPage() {
    getAllRejectedRequests();
    Get.toNamed(AppRroute.viewRejectedRequests);
  }
  
  @override
  getAllFinishedRequests() async{
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.getAllFinishedRequests();
    statusRequest = handlingData(response);
    print("$response");
    if (statusRequest == StatusRequest.success) {
      finishedRequests = (response['data'] as List)
          .map((c) => TreatmentRequestProcessingSModel.fromJson(c))
          .toList();
      // print("${response['data']}");
      print(" ${finishedRequests.length} in-processing requests loaded successfully");
      showsnack(title: response['status'], message: response['message']);
    }
    update();
  }
  
  @override
  getAllInProcessingRequests()async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.getAllInProcessingRequests();
    statusRequest = handlingData(response);
    print("$response");
    if (statusRequest == StatusRequest.success) {
      inProcessingRequests = (response['data'] as List)
          .map((c) => TreatmentRequestProcessingSModel.fromJson(c))
          .toList();
      // print("${response['data']}");
      print(" ${inProcessingRequests.length} in-processing requests loaded successfully");
      showsnack(title: response['status'], message: response['message']);
    }
    update();
  }
  
  @override
  getAllPendingRequests() async{
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.getAllPendingRequests();
    statusRequest = handlingData(response);
    print("$response");
    if (statusRequest == StatusRequest.success) {
      pendingRequests = (response['data'] as List)
          .map((c) => PendingRequestModel.fromJson(c))
          .toList();
      // print("${response['data']}");
      print(" ${pendingRequests.length} pending requests loaded successfully");
      showsnack(title: response['status'], message: response['message']);
    }
    update();
  }
  
  @override
  getAllRejectedRequests()async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.getAllRejectedRequests();
    statusRequest = handlingData(response);
    print("$response");
    if (statusRequest == StatusRequest.success) {
      rejectedRequests = (response['data'] as List)
          .map((c) => TreatmentRequestProcessingSModel.fromJson(c))
          .toList();
      // print("${response['data']}");
      print(" ${rejectedRequests.length} rejected requests loaded successfully");
      showsnack(title: response['status'], message: response['message']);
    }
    update();
  }
  @override
  Future<void> deleteCategory(String id) async {
  statusRequest = StatusRequest.loading;
  update();
  var response = await adminRemote.deleteCategory(id);
  statusRequest = handlingData(response);
  if (statusRequest == StatusRequest.success) {
    // تحديث القائمة محلياً
    categorys.removeWhere((cat) => (cat['_id'] ?? cat['id']) == id);
    update();
    Get.snackbar('نجاح', 'تم حذف الفئة بنجاح');
  } else {
    Get.snackbar('خطأ', response['message'] ?? 'فشل الحذف');
  }
  update();
}
}

