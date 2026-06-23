import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/api_link.dart';
import '../../../../models/conversations_models/message_model.dart';
import '../../../../utils/app_constants/status_request.dart';
import '../../crud.dart';
import '../../../local_storge/local_user_storage.dart';

class ChatRemote {
  final Crud _crud = Crud();
  final localStorage = Get.find<LocalUserStorage>();

  // جلب جميع المحادثات (أو بيانات المستخدم الآخر)
   getConversationMessages(String otherUserId) async {
    final response = await _crud.getData("${ApiLink.conversations}/$otherUserId");
    return response.fold((l) => l, (r) => r);
  }

  // جلب الرسائل كقائمة MessageModel
   getConversationMessagess(String otherUserId) async {
    final response = await _crud.getData("${ApiLink.conversations}/$otherUserId");
    return response.fold((l) => l, (r) => r);
    // return result.fold(
    //   (status) => left(status),
    //   (responseBody) {
    //     List<dynamic> messagesData = responseBody['data'] ?? [];
    //     final messages = messagesData.map((json) => MessageModel.fromJson(json)).toList();
    //     return right(messages);
    //   },
    // );
  }

  // إرسال رسالة نصية
   sendTextMessage(String conversationId, String text) async {
    final response = await _crud.postData('${ApiLink.conversations}/$conversationId', {'text': text});
     return response.fold((l) => l, (r) => r);
    // return result.fold(
    //   (status) => left(status),
    //   (responseBody) {
    //     if (responseBody['status'] == 'success' && responseBody.containsKey('data')) {
    //       return right(MessageModel.fromJson(responseBody['data']));
    //     }
    //     return left(StatusRequest.serverFailure);
    //   },
    // );
  }

  // إرسال ملف (صورة) باستخدام Crud بعد إضافة دالة postDataWithFiles
   sendFileMessage(String conversationId, File file) async {
    // نستخدم postDataWithFiles إذا كانت موجودة في Crud
    final response = await _crud.postDataWithFiles(
      '${ApiLink.conversations}/$conversationId',
      {},
      [file.path],
      'file',
    );

    return response.fold((l) => l, (r) => r);
    // return result.fold(
    //   (status) => left(status),
    //   (responseBody) {
    //     if (responseBody['status'] == 'success' && responseBody.containsKey('data')) {
    //       return right(MessageModel.fromJson(responseBody['data']));
    //     }
    //     return left(StatusRequest.serverFailure);
    //   },
    // );
  }
}