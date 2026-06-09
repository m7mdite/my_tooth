// lib/bindings/unified_setting_binding.dart
import 'package:get/get.dart';
import '../controllers/public_controllers/unified_setting_controller.dart';
import '../services/remote/public_remotes/unified_profile_remote.dart';
import '../services/local_storge/secure_storage_service.dart';

class UnifiedSettingBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut: يتم إنشاء الكائن فقط عند أول استخدام له
    Get.lazyPut<SecureStorageService>(() => SecureStorageService());
    // Get.lazyPut<AuthModel>(() => AuthModel());
    // Get.lazyPut<AuthService>(() => AuthService());
    Get.lazyPut<UnifiedProfileRemote>(() => UnifiedProfileRemote(Get.find()));
    Get.lazyPut<UnifiedSettingController>(() => UnifiedSettingController());
  }
}
