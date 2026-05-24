import 'package:get/get.dart';
import 'package:gr_flutter/models/profile_model.dart';
import 'package:gr_flutter/services/remote/public_remote.dart';

import '../../services/functions/handling_data.dart';
import '../../utils/app_constants/status_request.dart';

class PublicController extends GetxController {
  late StatusRequest statusRequest;
  PublicRemote publicRemote = PublicRemote(Get.find());
  ProfileModel? otherProfile;
  getOtherProfile(String id) async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await publicRemote.getOtherProfile(id);
    statusRequest = handlingData(response);
    print("$response");
    if (statusRequest == StatusRequest.success) {
      otherProfile = ProfileModel.fromJson(response['data']);
    }
    update();
  }

  // داخل PublicController
  Future<bool> reportUser({
    required String userId,
    required String reason,
    required String description,
  }) async {
    statusRequest = StatusRequest.loading;
    update();
    try {
      var response = await publicRemote.reportUser(userId, reason,
          description); // تحتاج لإضافة هذه الدالة في PublicRemote
      if (handlingData(response) == StatusRequest.success) {
        statusRequest = StatusRequest.success;
        update();
        return true;
      } else {
        statusRequest = StatusRequest.failure;
        update();
        return false;
      }
    } catch (e) {
      statusRequest = StatusRequest.failure;
      update();
      return false;
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
  statusRequest = StatusRequest.loading;
  update();
  var response = await publicRemote.changePassword(oldPassword, newPassword); // قم بإنشائها في PublicRemote
  statusRequest = handlingData(response);
  if (statusRequest == StatusRequest.success) {
    update();
    return true;
  } else {
    update();
    return false;
  }
}
}
