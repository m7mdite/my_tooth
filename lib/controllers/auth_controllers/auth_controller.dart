import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/app_route.dart';
import 'package:gr_flutter/controllers/auth_controllers/login_controller.dart';
import 'package:gr_flutter/controllers/auth_controllers/register_controller.dart';

class AuthController extends GetxController {
  final LoginControllerImp loginController = Get.find();
  final RegisterControllerImp registerController = Get.find();

  RxBool isLogin = true.obs;
  RxString gender = 'male'.obs;
  RxString role = 'patient'.obs;
  late PageController pageController;
  RxInt currentPage = 0.obs;

  // Login controllers
  TextEditingController get loginEmailController => loginController.email;
  TextEditingController get loginPasswordController => loginController.password;
  GlobalKey<FormState> get loginFormKey => loginController.formStateLogin;

  // Register controllers
  TextEditingController get registerFirstNameController =>
      registerController.firstName;
  TextEditingController get registerFatherNameController =>
      registerController.fatherName;
  TextEditingController get registerLastNameController =>
      registerController.lastName;
  TextEditingController get registerEmailController => registerController.email;
  TextEditingController get registerPasswordController =>
      registerController.password;
  TextEditingController get registerConfirmPasswordController =>
      registerController.confirmPassword;
  TextEditingController get registerUniversityController =>
      registerController.universityNumber;
  GlobalKey<FormState> get registerFormKey =>
      registerController.formStateRegister;

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
  
  loginAsGuest() {
    Get.toNamed(AppRroute.mainScreenGuest);
    print("Logged in as guest");
  }

  void goToPage(int index) {
    currentPage.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
  void goToLogin() {
  currentPage.value = 0;
  pageController.animateToPage(
    0,
    duration: const Duration(milliseconds: 400),
    curve: Curves.easeInOut,
  );
}

void goToRegister() {
  currentPage.value = 1;
  pageController.animateToPage(
    1,
    duration: const Duration(milliseconds: 400),
    curve: Curves.easeInOut,
  );
}

  void togglePage(int index) {
    currentPage.value = index;
    update();
  }

  void toggleMode() {
    if (isLogin.value) {
      // الانتقال إلى صفحة إنشاء الحساب (الصفحة الثانية)
      pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      // الانتقال إلى صفحة تسجيل الدخول (الصفحة الأولى)
      pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
    isLogin.toggle();
  }

  void login() {
    if (loginFormKey.currentState!.validate()) {
      loginController.login();
    }
  }

  void register() {
    if (registerFormKey.currentState!.validate()) {
      // تمرير القيم المختارة إلى RegisterController
      registerController.gender = gender.value;
      registerController.role = role.value;
      registerController.register();
    }
  }
}
