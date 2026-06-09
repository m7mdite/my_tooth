// bindings/login_binding.dart
import 'package:get/get.dart';
import '../controllers/auth_controllers/login_controller.dart';
import '../services/remote/public_remotes/auth_remote.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemote>(() => AuthRemote(Get.find()));
    Get.lazyPut<LoginControllerImp>(() => LoginControllerImp());
  }
}
