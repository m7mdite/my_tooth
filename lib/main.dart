import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app_route.dart';
import 'bindings/general_binding.dart';
import 'controllers/notifications_controllers/notification_controller.dart';
import 'services/local_storge/local_user_storage.dart';
import 'services/local_storge/secure_storage_service.dart';
import 'services/remote/crud.dart';
// import 'services/my_services.dart';
import 'services/remote/public_remotes/unified_profile_remote.dart';
import 'services/notification/websocket_service.dart';

Future<void> main() async {
  Get.put(SecureStorageService(), permanent: true);
  Get.put(LocalUserStorage(), permanent: true);
  Get.put(Crud(), permanent: true);
  WidgetsFlutterBinding.ensureInitialized();

  // await initialServices();
  await GetStorage.init();

  
  Get.put(NotificationController());
  // Get.put(AuthModel(), permanent: true);
  Get.put(WebSocketService());
  // Get.put(WebSocketService(), permanent: true);
  Get.put(UnifiedProfileRemote(Get.find()), permanent: true);
  // Get.put(AuthService(), permanent: true);
  // final oldToken = GetStorage().read('token');
  // if (oldToken != null) {
  //   await Get.find<SecureStorageService>().saveToken(oldToken);
  //   GetStorage().remove('token');
  // }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Locale('ar'),
      initialBinding: GeneralBinding(),
       initialRoute: AppRroute.splash,
      getPages: routes,
      debugShowCheckedModeBanner: false,
      title: 'final',
      
    );
  }
}
