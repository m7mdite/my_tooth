import 'package:get/get.dart';

import '../services/remote/public_remotes/post_remote.dart';
import '../controllers/post_controllers/post_controller.dart';

class FeedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostController>(() => PostController());
    // إذا كان PostController يحتاج إلى Remote، فسجله أيضاً
    Get.lazyPut<PostRemote>(() => PostRemote(Get.find()));
  }
}