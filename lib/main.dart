import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app_route.dart';
import 'controllers/controllers_binding.dart';
import 'controllers/notification_controller.dart';
import 'services/crud.dart';
// import 'services/my_services.dart';
import 'services/shared/auth_service.dart';
import 'services/websocket_service.dart';
import 'services/websocket_service1.dart';

Future<void> main() async {
  Get.put(Crud());
  WidgetsFlutterBinding.ensureInitialized();
  
  // await initialServices();
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(NotificationController());
  Get.put(WebSocketService1());
    // Get.put(WebSocketService(), permanent: true);
    
    Get.put(AuthService(), permanent: true);
    return GetMaterialApp(
      locale: Locale('ar'),
      initialBinding: ControllersBinding(),
      getPages: routes,
      debugShowCheckedModeBanner: false,
      title: 'final',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
