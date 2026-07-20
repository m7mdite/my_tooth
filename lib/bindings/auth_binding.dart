import 'package:get/get.dart';
import 'package:gr_flutter/controllers/auth_controllers/login_controller.dart';
import 'package:gr_flutter/controllers/auth_controllers/auth_controller.dart';
import '../services/remote/public_remotes/auth_remote.dart';
import '../controllers/auth_controllers/register_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemote>(() => AuthRemote(Get.find()));
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<RegisterControllerImp>(() => RegisterControllerImp());
    Get.lazyPut<LoginControllerImp>(() => LoginControllerImp());
  }
}