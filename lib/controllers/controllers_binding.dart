import 'package:get/get.dart';
import 'package:gr_flutter/controllers/all/public_controller.dart';
import 'package:gr_flutter/controllers/auth_controller/login_controller.dart';
import 'package:gr_flutter/controllers/auth_controller/register_controller.dart';


class ControllersBinding extends Bindings {
  @override
  void dependencies() {
    // سيتم تهيئة الـ controllers مرة واحدة عند بدء التطبيق
    Get.lazyPut<LoginControllerImp>(() => LoginControllerImp(), fenix: true);
    Get.lazyPut<PublicController>(() => PublicController(), fenix: true);
    Get.put<RegisterControllerImp>(RegisterControllerImp());

    // patient 
    // Get.lazyPut<MainControllerImp>(() => MainControllerImp(), fenix: true);
    // Get.lazyPut<MainPatientControllerImp>(() => MainPatientControllerImp(), fenix: true);                                          
    // Get.lazyPut<FillRequestControllerImp>(() => FillRequestControllerImp(), fenix: true);
    // Get.lazyPut<PatientRequestControllerImp>(() => PatientRequestControllerImp(), fenix: true);

    // admin
    // Get.lazyPut<MainAdminControllerImp>(() => MainAdminControllerImp(), fenix: true);
  }
}