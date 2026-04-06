import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/controllers/admin_controller/admin_users_controller.dart';
import 'package:gr_flutter/models/overseer/profile_overseer_model.dart';
import 'package:gr_flutter/services/functions/show_snack.dart';
import 'package:gr_flutter/views/admin_views/request_and_courses/add_treatment_page.dart';

import '../../models/admin/course_model.dart';
import '../../models/admin/treatment_model.dart';
import '../../services/functions/handling_data.dart';
import '../../services/remote/admin_remote.dart';
import '../../utils/app_constants/status_request.dart';

abstract class AdminRequestController extends GetxController {
  toAddCoursePage();
  toAddTreatmentPage();
  toViewTreatmentsPage();
  toViewCoursesPage();
  addTreatment();
  addCourse();
  getAllTreatments();
  getAllCourses();
  getAllOverSeers();
}

class AdminRequestControllerImpl extends AdminRequestController {
  AdminUsersControllerImpl adminUsersControllerImpl =Get.put(AdminUsersControllerImpl());
  late StatusRequest statusRequest;
  AdminRemote adminRemote = AdminRemote(Get.find());
  List<TreatmentModel> treatments = [];
  List<CourseModel> courses = [];
  List<ProfileOverseerModel> overSeers = [];
  List<ProfileOverseerModel> selectedOverseers = <ProfileOverseerModel>[];
  CourseModel? selectedCourse;

  TextEditingController courseNameController = TextEditingController();
  TextEditingController treatmentCaseController = TextEditingController();

  @override
  void onInit() {
    getAllCourses();
    super.onInit();
  }

  @override
  toAddCoursePage() {
    overSeers= getAllOverSeers();
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
    Get.toNamed(AppRroute.viewCourses);
  }

  @override
  toViewTreatmentsPage() {
    for (var i in courses) {
      print(i.courseName);
    }
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
      "treatment_case": treatmentCaseController.text,
      "course": selectedCourse!.sId,
    };
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.addTreatment(data);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      showsnack(title: "Success", message: "Treatment added successfully");
      Get.back();
    } else {
      showsnack(title: "Error", message: "Failed to add treatment");
    }
    update();
  }

  @override
  addCourse() async {}

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
    // if (statusRequest == StatusRequest.success) {
      treatments = (response['data'] as List)
          .map((treatment) => TreatmentModel.fromJson(treatment))
          .toList();
          print(" ${treatments.length} treatments loaded successfully");

      showsnack(title: "Success", message: "Treatments loaded successfully");
    // }
  }
  
  @override
  List<ProfileOverseerModel> getAllOverSeers() {
    adminUsersControllerImpl.getAllOverSeers();
    print("${adminUsersControllerImpl.overSeers.length} overseers in request controller");
    return adminUsersControllerImpl.overSeers;
  }
}
