import 'package:get/get.dart';

import '../controllers/public_controllers/public_controller.dart';
import '../services/remote/crud.dart';
import '../services/local_storge/secure_storage_service.dart';

class GeneralBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SecureStorageService(), permanent: true);
    // خدمات عامة (permanent لأنها تستخدم في كل مكان)
    Get.put(Crud(), permanent: true);
    
    // Get.put(AuthModel(), permanent: true);
    // Get.put(AuthService(), permanent: true);
    Get.lazyPut<PublicController>(() => PublicController(), fenix: true);
  }
}