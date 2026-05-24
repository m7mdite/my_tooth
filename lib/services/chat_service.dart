import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gr_flutter/api_link.dart';
import 'package:gr_flutter/services/shared/auth_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/message_model.dart';
import '../utils/app_constants/status_request.dart';
import 'crud.dart';

class ChatService {
  final Crud _crud = Crud();
  AuthModel authModel =AuthModel();

  // final GetStorage _storage = GetStorage();

  // String get _token => _storage.read('token') ?? '';
  // String get _userId => _storage.read('userId') ?? '';


getConversationMessages(String otherUserId) async {
    final String? token = await authModel.getToken();
    // var response = await _crud.getData("${ApiLink.conversations}/69f96e7a9bf6eb4b8528a7f7", {
    var response = await _crud.getData("${ApiLink.conversations}/$otherUserId", );
    return response.fold((l) => l, (r) => r);
  }
  // جلب الرسائل
  Future<Either<StatusRequest, List<MessageModel>>> getConversationMessagess(String otherUserId) async {
    // final token =  await authModel.getToken();
    // if (token) return left(StatusRequest.unauthenticated);

   

    // final result = await _crud.getData("${ApiLink.conversations}/69f96e7a9bf6eb4b8528a7f7", headers);
    final result = await _crud.getData("${ApiLink.conversations}/$otherUserId", );
    
    return result.fold(
      (status) => left(status),
      (responseBody) {
        List<dynamic> messagesData = [];
        if (responseBody.containsKey('data')) {
          messagesData = responseBody['data'];
        }
        final messages = messagesData
            .map((json) => MessageModel.fromJson(json))
            .toList();
            print("${messages[0].content}");
        return right(messages);
      },
    );
  }

  // إرسال رسالة نصية
  Future<Either<StatusRequest, MessageModel>> sendTextMessage(String conversationId, String text) async {
    final token =  await authModel.getToken();
    // if (token.isEmpty) return left(StatusRequest.unauthenticated);

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final result = await _crud.postData('${ApiLink.conversations}/$conversationId', {'text': text}, );
    
    return result.fold(
      (status) => left(status),
      (responseBody) {
        if (responseBody['status'] == 'success' && responseBody.containsKey('data')) {
          return right(MessageModel.fromJson(responseBody['data']));
        }
        return left(StatusRequest.serverFailure);
      },
    );
  }

  // إرسال ملف (لأن Crud لا يدعم multipart)
  Future<Either<StatusRequest, MessageModel>> sendFileMessage(String conversationId, File file) async {
    final token =  await authModel.getToken();
    // if (token.isEmpty) return left(StatusRequest.unauthenticated);
    
    try {
      final uri = Uri.parse('${ApiLink.conversations}/$conversationId');
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      
      request.files.add(await http.MultipartFile.fromPath('file', file.path,
          contentType: MediaType('image', 'jpeg')));
      
      final response = await http.Response.fromStream(await request.send());
      
      if (response.statusCode == 201) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == 'success' && body.containsKey('data')) {
          return right(MessageModel.fromJson(body['data']));
        }
      }
      return left(StatusRequest.serverFailure);
    } catch (e) {
      return left(StatusRequest.serverFailure);
    }
  }
}