import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/models/auth_models/register_model.dart';
import 'package:gr_flutter/services/remote/crud.dart';
import 'package:gr_flutter/services/remote/public_remotes/auth_remote.dart';
// import 'package:gr_flutter/services/shared/auth_model.dart';

import '../../services/functions/handling_data.dart';
import '../../utils/app_constants/status_request.dart';
import '../../utils/validators/register_validator.dart';

abstract class RegisterController extends GetxController {
  register();
  goToLogin();
  validatConfirmPassowrd(String? val);
}

class RegisterControllerImp extends RegisterController {
  late TextEditingController firstName;
  late TextEditingController fatherName;
  late TextEditingController lastName;
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController confirmPassword;
  late TextEditingController universityNumber;
  final RxBool isLoading = false.obs;
  String role = 'patient';
  String gender = 'male';
  Map<String, dynamic> data = <String, dynamic>{};
  GlobalKey<FormState> formStateRegister = GlobalKey<FormState>();
  Crud crud = Crud();
  AuthRemote authRemote = AuthRemote(Get.find());
  late StatusRequest statusRequest;
  @override
  void onInit() {
    firstName = TextEditingController();
    lastName = TextEditingController();
    fatherName = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();
    universityNumber = TextEditingController();

    super.onInit();
  }

  @override
  register() async {
    if (!validateFormManually()) return;
    data = RegisterModel(
      gender: gender,
      fatherName: fatherName.text,
      firstName: firstName.text,
      lastName: lastName.text,
      email: email.text,
      password: password.text,
      role: role,
      universityNumber: universityNumber.text,
    ).toJson();
    print("Data to send: $data");
    var formData = formStateRegister.currentState;
    if (formData!.validate()) {
      isLoading.value = true;
      statusRequest = StatusRequest.loading;
      update();
      try {
        final responseData = await authRemote.register(data);
        statusRequest = handlingData(responseData);
        if (statusRequest == StatusRequest.success) {
          Get.offAllNamed(
            AppRroute.login,
            arguments: {'email': responseData['data']['email']},
          );
        }

        update();
      } catch (e) {
        statusRequest = StatusRequest.serverFailure;
        update();
        print("Exception in register: $e");
      }finally{
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    firstName.dispose();
    fatherName.dispose();
    lastName.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    universityNumber.dispose();
    super.onClose();
  }

  @override
  goToLogin() {
    Get.offAndToNamed(AppRroute.login);
  }
  bool  confirmPass=false;
  @override
  validatConfirmPassowrd(String? val) {
    if(val==password.text ) {
      confirmPass=true;
    } else {
      confirmPass=false;
    }
    update();
  }

  // داخل RegisterControllerImp

bool validateFormManually() {
  // تحقق من الحقول واحداً واحداً
  final firstNameError = RegisterValidator.name(firstName.text, 'الاسم الأول');
  if (firstNameError != null) {
    _showSnackbarAndFocus(firstNameError, firstName);
    return false;
  }

  final fatherNameError = RegisterValidator.name(fatherName.text, 'اسم الأب');
  if (fatherNameError != null) {
    _showSnackbarAndFocus(fatherNameError, fatherName);
    return false;
  }

  final lastNameError = RegisterValidator.name(lastName.text, 'الكنية');
  if (lastNameError != null) {
    _showSnackbarAndFocus(lastNameError, lastName);
    return false;
  }

  final emailError = RegisterValidator.email(email.text);
  if (emailError != null) {
    _showSnackbarAndFocus(emailError, email);
    return false;
  }

  final passwordError = RegisterValidator.password(password.text);
  if (passwordError != null) {
    _showSnackbarAndFocus(passwordError, password);
    return false;
  }

  final confirmError = RegisterValidator.confirmPassword(confirmPassword.text, password.text);
  if (confirmError != null) {
    _showSnackbarAndFocus(confirmError, confirmPassword);
    return false;
  }

  if (role == 'student') {
    final uniError = RegisterValidator.universityNumber(universityNumber.text, true);
    if (uniError != null) {
      _showSnackbarAndFocus(uniError, universityNumber);
      return false;
    }
  }

  return true;
}

void _showSnackbarAndFocus(String message, TextEditingController controller) {
  Get.snackbar(
    'تنبيه',
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: const Color.fromARGB(117, 255, 255, 255),
    colorText: Colors.red,
    duration: const Duration(seconds: 3),
  );
  // طلب التركيز على الحقل المخالف
  WidgetsBinding.instance.addPostFrameCallback((_) {
    FocusScope.of(Get.context!).requestFocus(FocusNode()); // نعيد التركيز على الحقل
  });
}
}
