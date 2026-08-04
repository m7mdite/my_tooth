import 'package:get/get.dart';
import '../controllers/patient_controller/main_patient_controller.dart';
import '../controllers/patient_controller/home_patient_controller.dart';
import '../controllers/patient_controller/patient_request_controller.dart';
import '../controllers/public_controllers/unified_setting_controller.dart';
import '../controllers/post_controllers/post_controller.dart';
import '../services/remote/public_remotes/request_remote.dart';
import '../services/remote/public_remotes/post_remote.dart';
import '../services/remote/public_remotes/unified_profile_remote.dart';

class MainPatientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestRemote>(() => RequestRemote(Get.find()));
    Get.lazyPut<PostRemote>(() => PostRemote(Get.find()));
    Get.lazyPut<UnifiedProfileRemote>(() => UnifiedProfileRemote(Get.find()));
    
    Get.lazyPut<HomePatientControllerImp>(() => HomePatientControllerImp());
    Get.lazyPut<PatientRequestControllerImp>(() => PatientRequestControllerImp());
    Get.lazyPut<PostController>(() => PostController());
    Get.lazyPut<UnifiedSettingController>(() => UnifiedSettingController());
    Get.lazyPut<MainPatientControllerImp>(() => MainPatientControllerImp());
  }
}