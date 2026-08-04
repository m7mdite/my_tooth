import 'package:gr_flutter/services/remote/crud.dart';

import '../../../api_link.dart';

class PublicRemote {
  Crud crud;
  PublicRemote(this.crud);
  getOtherProfile(String id) async {
    var response = await crud.getData(
      "${ApiLink.getOtherProfile}/$id",
    );
    print("$response ${ApiLink.getOtherProfile}/$id");
    return response.fold((l) => l, (r) => r);
  }

  reportUser(String userId, String reason, String description) async {
    var response = await crud.postData(
      "${ApiLink.reportUser}/$userId",
      {
        // 'reportedUserId': userId,
        'type': reason,
        'reason': description,
      },
    );
    return response.fold((l) => l, (r) => r);
  }
   changePassword(String oldPassword, String newPassword) async {
  var response = await crud.postData(ApiLink.changePassword, {
    'old_password': oldPassword,
    'new_password': newPassword,
  });
  return response.fold((l) => l, (r) => r);
}
}
