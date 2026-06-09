// bindings/main_student_binding.dart
import 'package:get/get.dart';
import '../controllers/post_controllers/post_controller.dart';
import '../controllers/student_controllers/main_student_controller.dart';
import '../controllers/student_controllers/student_home_controller.dart';
import '../controllers/student_controllers/student_requests_controller.dart';
import '../controllers/public_controllers/unified_setting_controller.dart';
import '../services/remote/public_remotes/request_remote.dart';
import '../services/remote/public_remotes/post_remote.dart';
import '../services/remote/public_remotes/unified_profile_remote.dart';

class MainStudentBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<RequestRemote>(() => RequestRemote(Get.find()));
    Get.lazyPut<PostRemote>(() => PostRemote(Get.find()));
    Get.lazyPut<UnifiedProfileRemote>(() => UnifiedProfileRemote(Get.find()));
    
    // Controllers
    Get.lazyPut<StudentHomeControllerImp>(() => StudentHomeControllerImp());
    Get.lazyPut<StudentRequestsControllerImp>(() => StudentRequestsControllerImp());
    Get.lazyPut<PostController>(() => PostController());
    Get.lazyPut<UnifiedSettingController>(() => UnifiedSettingController());
    Get.lazyPut<MainStudentControllerImp>(() => MainStudentControllerImp());
  }
}