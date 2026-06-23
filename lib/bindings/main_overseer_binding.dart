// bindings/main_student_binding.dart
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/overseer_controllers/main_overseer_controller.dart';
import 'package:gr_flutter/controllers/overseer_controllers/overseer_requests_controller.dart';
import '../controllers/post_controllers/post_controller.dart';
import '../controllers/public_controllers/unified_setting_controller.dart';
import '../services/remote/public_remotes/request_remote.dart';
import '../services/remote/public_remotes/post_remote.dart';
import '../services/remote/public_remotes/unified_profile_remote.dart';

class MainOverseerBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<RequestRemote>(() => RequestRemote(Get.find()));
    Get.lazyPut<PostRemote>(() => PostRemote(Get.find()));
    Get.lazyPut<UnifiedProfileRemote>(() => UnifiedProfileRemote(Get.find()));
    
    // Controllers
    // Get.lazyPut<OverseerHomeControllerImp>(() => StudentHomeControllerImp());
    Get.lazyPut<OverseerRequestsControllerImpl>(() => OverseerRequestsControllerImpl());
    Get.lazyPut<PostController>(() => PostController());
    Get.lazyPut<UnifiedSettingController>(() => UnifiedSettingController());
    Get.lazyPut<MainOverseerControllerImp>(() => MainOverseerControllerImp());
  }
}