import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/models/overseer/profile_overseer_model.dart';
import 'package:gr_flutter/models/patient_model/patient_profile_model.dart';
import 'package:gr_flutter/models/student_model/student_profile_model.dart';
import 'package:gr_flutter/views/admin_views/submit_verify_student.dart';
import 'package:gr_flutter/views/widgets/submit_dialog.dart';
import '../../models/student_model/veify_student_model.dart';
import '../../services/functions/handling_data.dart';
import '../../services/remote/admin_remote.dart';
import '../../utils/app_constants/status_request.dart';

abstract class AdminUsersController extends GetxController {
  toAddOverSeerPage();
  toViewOverSeersPage();
  toViewStudentsPage();
  toViewPatientesPage();
  toViewVerifyStudentsPage();
  acceptVerifyStudent(String studentId);
  addOverSeer();
  getAllOverSeers();
  getAllStudents();
  getAllPatientes();
  getAllVerifyStudents();
  toSubmitVerifyStudentPage(VeifyStudentModel student);
}

class AdminUsersControllerImpl extends AdminUsersController {
  List<ProfileOverseerModel> overSeers = [];
  List<StudentProfileModel> students = [];
  List<PatientProfileModel> patients = [];
  List<VeifyStudentModel> verifyStudents = [];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  AdminRemote adminRemote = AdminRemote(Get.find());
  late StatusRequest statusRequest;

  @override
  toAddOverSeerPage() {
    Get.toNamed(AppRroute.addOverSeer);
  }

  @override
  addOverSeer() {
    Map data = {
      "email": emailController.text,
      "password": passwordController.text,
    };
    if (formKey.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      update();
      adminRemote.addOverSeer(data).then(
        (response) {
          statusRequest = handlingData(response);
          if (statusRequest == StatusRequest.success) {
            Get.snackbar("Success", "OverSeer added successfully");
            Get.back();
          } else {
            Get.snackbar("Error", "Failed to add OverSeer");
          }
          update();
        },
      );
    }
  }

  @override
  toViewOverSeersPage() {
    Get.toNamed(AppRroute.viewOverSeers);
  }

  @override
  getAllOverSeers() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.getAllOverSeers();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      overSeers = response['data']
          .map<ProfileOverseerModel>(
              (json) => ProfileOverseerModel.fromJson(json))
          .toList();
      for (var overSeer in overSeers) {
        print(
            "OverSeer: ${overSeer.firstName} ${overSeer.lastName}, Email: ${overSeer.user}, Bio: ${overSeer.bio}");
      }
      print("${overSeers.length} OverSeers fetched successfully");
    } else {
      Get.snackbar("Error", "Failed to fetch OverSeers");
    }
    update();
  }

  @override
  getAllStudents() {
    statusRequest = StatusRequest.loading;
    update();
    adminRemote.getAllStudents().then((response) {
      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        students = response['data']
            .map<StudentProfileModel>(
                (json) => StudentProfileModel.fromJson(json))
            .toList();
        for (var student in students) {
          print(
              "Student: ${student.firstName} ${student.lastName}, Email: ${student.universityNumber}, Bio: ${student.bio}");
        }
        print("${students.length} Students fetched successfully");
      } else {
        Get.snackbar("Error", "Failed to fetch Students");
      }
      update();
    });
  }

  @override
  toViewStudentsPage() {
    Get.toNamed(AppRroute.viewStudents);
  }

  @override
  getAllPatientes() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.getAllPatientes();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      patients = response['data']
          .map<PatientProfileModel>(
              (json) => PatientProfileModel.fromJson(json))
          .toList();

      print("${patients.length} Patients fetched successfully");
    } else {
      Get.snackbar("Error", "Failed to fetch Patients");
    }
    update();
  }

  @override
  toViewPatientesPage() {
    Get.toNamed(AppRroute.viewPatientes);
  }

  @override
  toViewVerifyStudentsPage() {
    Get.toNamed(AppRroute.verifyStudents);
  }

  @override
  getAllVerifyStudents() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.getAllVerifyStudents();
    print(response);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      verifyStudents = response['data']
          .map<VeifyStudentModel>((json) => VeifyStudentModel.fromJson(json))
          .toList();

      print("${verifyStudents.length} Verify Students fetched successfully");
    } else {
      Get.snackbar("Error", "Failed to fetch Verify Students");
    }
    update();
  }

  @override
  toSubmitVerifyStudentPage(VeifyStudentModel student) {
    Get.dialog(SubmitVerifyStudent(
      studentModel: student,
    ));
    // Get.toNamed(AppRroute.submitVerifyStudent, arguments: student);
  }

  @override
  acceptVerifyStudent(String studentId) {
    Get.dialog(
      SubmitDialog(
        title: "تأكيد التوثيق",
        question: "هل أنت متأكد أنك تريد توثيق هذا الطالب؟",
        onTapSubmit: () {
          statusRequest = StatusRequest.loading;
          update();
          adminRemote.acceptVerifyStudent(studentId).then(
            (response) {
              statusRequest = handlingData(response);
              if (statusRequest == StatusRequest.success) {
                Get.snackbar("Success", "Student verified successfully");
                getAllVerifyStudents();
                Get.close(2);
              } else {
                Get.snackbar("Error", "Failed to verify Student");
              }
              update();
            },
          );
        },
      ),
    );
  }
}
