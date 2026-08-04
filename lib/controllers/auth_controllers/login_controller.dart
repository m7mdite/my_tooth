
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/services/notification/websocket_service.dart';

import '../../services/remote/crud.dart';
import '../../services/functions/handling_data.dart';
import '../../services/local_storge/local_user_storage.dart';
import '../../services/remote/public_remotes/auth_remote.dart';
import '../../utils/app_constants/colors_constant.dart';
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
  
  // WebSocketController webSocketController = WebSocketController();
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


  final storage = Get.find<LocalUserStorage>();
  AuthRemote authRemote = AuthRemote(Get.find());
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
        await  toHome(response);
          print("id ${response['data']['_id']}");
        webSocketService1.connect(response['data']['_id']);
        } else {
          Get.snackbar(
            'خطأ',
            'فشل في الاتصال بالخادم',
            backgroundColor: AppColors.error,
            colorText: AppColors.white,
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
  toHome(Map<String, dynamic> response) async {
    print(  "Response in toHome: ${response.runtimeType}");
    if (response.containsKey('status') && response['status'] == "success") {
      if (response['data'].containsKey('is_admin') && response['data']['is_admin'] == true) {
        await  storage.saveAllFromJson(response['data']);
        await  storage.saveToken(response['token']);
        print(response['token']);
        await  storage.saveRole('admin');
        Get.snackbar('  نجاح التسجيل', 'اهلا بك مديري',
            backgroundColor: AppColors.success, colorText: AppColors.white);
        Get.offAndToNamed(
          AppRroute.mainScreenAdmin,
          arguments: {'role': 'admin'},
        );
      } else {
        print(response['token']);

        // student or patient or super
        await  storage.saveAllFromJson(response['data']);
        await  storage.saveToken(response['token']);

        if (response['data']['role'] == 'student') {
          // authService.saveIsVerified(response['data']['is_verified']);
          print("$response");
          Get.offAndToNamed(AppRroute.mainScreenStudent);
        } else if (response['data']['role'] == 'patient') {
          Get.offAndToNamed(AppRroute.mainScreenPatient);
        } else if (response['data']['role'] == 'overseer') {
          Get.offAndToNamed(AppRroute.mainScreenOverseer);
        }
        Get.snackbar('نجاح', 'اهلا بك ${response['data']['first_name']}',
            backgroundColor: AppColors.success, colorText: AppColors.white);
        
        
        // storage.saveRole(response['data']['role']);
      }
    } else {
      String errorMessage = response['message'] ?? 'حدث خطأ غير معروف';
      Get.snackbar(
        'خطأ',
        errorMessage,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    }
  }
}
