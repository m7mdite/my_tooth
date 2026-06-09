import 'package:get/get.dart';
import '../services/remote/public_remotes/auth_remote.dart';
import '../controllers/auth_controllers/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemote>(() => AuthRemote(Get.find()));
    Get.lazyPut<RegisterControllerImp>(() => RegisterControllerImp());
  }
}