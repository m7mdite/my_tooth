import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/services/functions/show_snack.dart';
import 'package:gr_flutter/views/admin_views/submit_verify_student.dart';
import 'package:gr_flutter/views/widgets/dialog/submit_dialog.dart';
import '../../models/public_models/profile_model.dart';
import '../../models/admin_models/veify_student_model.dart';
import '../../services/functions/handling_data.dart';
import '../../services/local_storge/local_user_storage.dart';
import '../../services/remote/public_remotes/gimini_remote.dart';
import '../../services/remote/admin_remotes/admin_remote.dart';
import '../../utils/app_constants/status_request.dart';
import '../../views/admin_views/users/admin_reports_screen.dart';

abstract class AdminUsersController extends GetxController {
  toAddOverSeerPage();
  toViewOverSeersPage();
  toViewStudentsPage();
  toViewPatientesPage();
  toViewVerifyStudentsPage();
  toReportsPage();
  acceptVerifyStudent(String studentId);
  rejectVerifyStudent(String studentId);
  addOverSeer();
  getAllOverSeers();
  getAllStudents();
  getAllPatientes();
  getAllVerifyStudents();
  toSubmitVerifyStudentPage(VeifyStudentModel student);
  logout();
}

class AdminUsersControllerImpl extends AdminUsersController {
  RxBool isLoading = false.obs;
  final geminiService = GeminiRemote();

  // x () async {
  //   String userMessage = "Hello, how are you?";
  //   String response = await geminiService.sendMessage(userMessage);
  //   print("Gemini Response: $response");
  // }
  List<ProfileModel> overSeers = [];
  List<ProfileModel> students = [];
  List<ProfileModel> patients = [];
  List<VeifyStudentModel> verifyStudents = [];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController rejectReasonController =
      TextEditingController(text: "خطأ بالمعلومات ");
  AdminRemote adminRemote = AdminRemote(Get.find());
  late StatusRequest statusRequest;



  @override
  void onInit() {
    getAllOverSeers();
    super.onInit();
  }
  @override
  toAddOverSeerPage() {
    Get.toNamed(AppRroute.addOverSeer);
  }

  @override
  addOverSeer() async {
    isLoading.value = true;
    Map data = {
      "email": emailController.text,
      "password": passwordController.text,
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "father_name": fatherNameController.text,
    };
    if (formKey.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      update();
      var response = await adminRemote.addOverSeer(data);
      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        showsnack(
            title: response['status'], message: response['message'] ?? '');
        // Get.back();
      } else {
        showsnack(title: response['status'], message: response['message']);
      }
      update();
      isLoading.value = false;
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
          .map<ProfileModel>((json) => ProfileModel.fromJson(json))
          .toList();
      for (var overSeer in overSeers) {
        print(
            "OverSeer: ${overSeer.firstName} ${overSeer.lastName}, Email: ${overSeer.user}, Bio: ${overSeer.bio}");
      }
      print("${overSeers.length} OverSeers fetched successfully");
    } else {
      showsnack(title: response['status'], message: response['message']);
    }
    update();
  }

  @override
  getAllStudents() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.getAllStudents();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      students = response['data']
          .map<ProfileModel>((json) => ProfileModel.fromJson(json))
          .toList();
      for (var student in students) {
        print(
            "Student: ${student.firstName} ${student.lastName}, Email: ${student.universityNumber}, Bio: ${student.bio}");
      }
      print("${students.length} Students fetched successfully");
    } else {
      showsnack(title: response['status'], message: response['message']);
    }
    update();

    // .then((response) {
    //   statusRequest = handlingData(response);
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
          .map<ProfileModel>((json) => ProfileModel.fromJson(json))
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
  void toReportsPage() {
    Get.to(() => AdminReportsScreen());
  }

  @override
  acceptVerifyStudent(String studentId) {
    Get.dialog(
      SubmitDialog(
        title: "تأكيد التوثيق",
        question: "هل أنت متأكد أنك تريد توثيق هذا الطالب؟",
        onTapSubmit: () async {
          statusRequest = StatusRequest.loading;
          update();
          var response = await adminRemote.acceptVerifyStudent(studentId);
          statusRequest = handlingData(response);

          if (statusRequest == StatusRequest.success) {
            Get.snackbar(response['status'] ?? "تم", response['message']);
            getAllVerifyStudents();
            Get.close(2);
          } else {
            Get.snackbar("Error", "Failed to verify Student");
          }
          update();
        },
      ),
    );
  }

  @override
  rejectVerifyStudent(String studentId) async {
    if (rejectReasonController.text == "") {
      Get.snackbar("فشل", "ادخل سبب الرفض");
      return;
    }
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.rejectVerifyStudent(studentId,
        data: {"reject_reason": rejectReasonController.text});
    statusRequest = handlingData(response);

    if (statusRequest == StatusRequest.success) {
      Get.snackbar(response['status'] ?? "تم", response['message']);
      getAllVerifyStudents();
      Get.close(2);
    } else {
      Get.snackbar("خطأ", "حدث خطأ ما ");
    }
    update();
  }

  // داخل AdminUsersControllerImpl
  Future<void> deleteOverSeer(String id) async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await adminRemote.deleteOverSeer(id);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      // إزالة المشرف من القائمة المحلية
      overSeers.removeWhere((overSeer) => overSeer.user == id);
      showsnack(
          title: 'نجاح', message: response['message'] ?? 'تم حذف المشرف بنجاح');
    } else {
      showsnack(title: 'خطأ', message: response['message'] ?? 'فشل حذف المشرف');
    }
    update();
  }

  @override
  logout() async {
    Get.dialog(
      SubmitDialog(
        title: "تسجيل الخروج",
        question: "هل أنت متأكد من رغبتك بتسجيل الخروج؟",
        onTapSubmit: () async {
          await Get.find<LocalUserStorage>().deleteToken();
          await Get.find<LocalUserStorage>().deleteRole();
          await Get.find<LocalUserStorage>().clearAll();
          Get.offAllNamed(AppRroute.register);
          // Get.close(2);
        },
      ),
    );
  }
}
