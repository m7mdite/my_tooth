// bindings/student_requests_binding.dart
import 'package:get/get.dart';
import '../controllers/student_controllers/student_requests_controller.dart';
import '../services/remote/public_remotes/request_remote.dart';

class StudentRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestRemote>(() => RequestRemote(Get.find()));
    Get.lazyPut<StudentRequestsControllerImp>(() => StudentRequestsControllerImp());
  }
}