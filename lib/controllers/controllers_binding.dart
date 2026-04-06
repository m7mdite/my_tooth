import 'package:get/get.dart';
import 'package:gr_flutter/controllers/auth/login_controller.dart';
import 'package:gr_flutter/controllers/auth/register_controller.dart';
import 'package:gr_flutter/controllers/patient_controller/main_patient_controller.dart';
import 'package:gr_flutter/controllers/patient_controller/patient_request_controller.dart';
import 'package:gr_flutter/controllers/fill_request_controller.dart';

import 'admin_controller/main_admin_controller.dart';

class ControllersBinding extends Bindings {
  @override
  void dependencies() {
    // سيتم تهيئة الـ controllers مرة واحدة عند بدء التطبيق
    Get.lazyPut<LoginControllerImp>(() => LoginControllerImp(), fenix: true);
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