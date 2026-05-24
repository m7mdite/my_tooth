import 'package:gr_flutter/services/crud.dart';
import '../../api_link.dart';

class SupportRemote {
  Crud crud;
  SupportRemote(this.crud);

  sendSupportMessage({
    required String subject,
    required String message,
  }) async {
    var response = await crud.postData(ApiLink.supportMessage, {
      'subject': subject,
      'message': message,
    });
    return response.fold((l) => l, (r) => r);
  }
}