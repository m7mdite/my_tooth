
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/controllers/websocket_controller.dart';
import 'package:gr_flutter/services/shared/auth_model.dart';
import 'package:gr_flutter/services/websocket_service.dart';

import '../../services/crud.dart';
import '../../services/functions/handling_data.dart';
import '../../services/remote/auth_remote.dart';
import '../../services/shared/auth_service.dart';
import '../../utils/app_constants/status_request.dart';

abstract class LoginController extends GetxController {
  login();
  goToRegister();
  toHome(Map<String, dynamic> response);
}

class LoginControllerImp extends LoginController {
  late TextEditingController email;
  late TextEditingController password;

  // final AuthService _authService = Get.find<AuthService>();
  AuthModel authModel = AuthModel();
  AuthService authService = AuthService();
  AuthRemote authRemote = AuthRemote(Get.find());
  WebSocketController webSocketController = WebSocketController();
  Map<String, String> data = <String, String>{};
  GlobalKey<FormState> formStateLogin = GlobalKey<FormState>();
  Crud crud = Crud();
  late StatusRequest statusRequest;
  // WebSocketService webSocketService = WebSocketService();
  WebSocketService webSocketService1 = WebSocketService();

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    _checkForRegistrationEmail();
    super.onInit();
  }

  void _checkForRegistrationEmail() {
    final arguments = Get.arguments;
    print("Arguments received: $arguments");

    if (arguments != null && arguments['email'] != null) {
      email.text = arguments['email'];
      update();
    }
  }

  fillMap() {
    data['email'] = email.text;
    data['password'] = password.text;
  }

  @override
  login() async {
    await fillMap();
    print("Data to send: $data");

    var formData = formStateLogin.currentState;
    if (formData!.validate()) {
      statusRequest = StatusRequest.loading;
      update();
      try {
        var response = await authRemote.login(data);
        print("${response.runtimeType}");
        statusRequest = handlingData(response);
        if (statusRequest == StatusRequest.success) {
          toHome(response);
          print("id ${response['data']['_id']}");
        webSocketService1.connect(response['data']['_id']);

        } else {
          Get.snackbar(
            'خطأ',
            'فشل في الاتصال بالخادم',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }

        update();
      } catch (e) {
        statusRequest = StatusRequest.serverFailure;
        update();
        print("Exception in register: $e");
      }
    }
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }

  @override
  goToRegister() {
    Get.offAndToNamed(AppRroute.register);
  }

  @override
  toHome(Map<String, dynamic> response) {
    print(  "Response in toHome: ${response.runtimeType}");
    if (response.containsKey('status') && response['status'] == "success") {
      if (response['data'].containsKey('is_admin') && response['data']['is_admin'] == true) {
        authModel.saveEmail(response['data']['email']);
        authModel.saveToken(response['token']);
        print(response['token']);
        authModel.saveRole('admin');
        Get.snackbar('  نجاح التسجيل', 'اهلا بك مديري',
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAndToNamed(
          AppRroute.mainScreenAdmin,
          arguments: {'role': 'admin'},
        );
      } else {
        print(response['token']);

        // student or patient or super
        authModel.saveToken(response['token']);
        authService.saveAllFromJson(response['data']);
        if (response['data']['role'] == 'student') {
          // authService.saveIsVerified(response['data']['is_verified']);
          print("${response}");
          Get.offAndToNamed(AppRroute.mainScreenStudent);
        } else if (response['data']['role'] == 'patient') {
          Get.offAndToNamed(AppRroute.mainScreenPatient);
        } else if (response['data']['role'] == 'overseer') {
          Get.offAndToNamed(AppRroute.mainScreenOverseer);
        }
        Get.snackbar('نجاح', 'اهلا بك ${response['data']['first_name']}',
            backgroundColor: Colors.green, colorText: Colors.white);
        
        
        authModel.saveRole(response['data']['role']);
      }
    } else {
      String errorMessage = response['message'] ?? 'حدث خطأ غير معروف';
      Get.snackbar(
        'خطأ',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
