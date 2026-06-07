// services/remote/unified_profile_remote.dart
import 'dart:convert';
import 'dart:io';
import 'package:gr_flutter/services/crud.dart';
import 'package:gr_flutter/api_link.dart';
import 'package:gr_flutter/services/shared/auth_model.dart';

import 'package:http/http.dart' as http;
import '../../utils/app_constants/status_request.dart';

class UnifiedProfileRemote {
  final Crud crud;
  AuthModel authModel =AuthModel();
  UnifiedProfileRemote(this.crud);

  getMyProfile() async {
    var response = await crud.getData(ApiLink.profile);
    return response.fold((l) => l, (r) => r);
  }

  updateProfile(Map<String, dynamic> data) async {
    var response = await crud.putData(ApiLink.profile, data, '');
    return response.fold((l) => l, (r) => r);
  }

  uploadProfilePicture(File image) async {
    final result = await crud.putDataWithFiles(
      ApiLink.photo, // تأكد أن ApiLink.photo = '/api/users/photo'
      {},
      [image.path],
      'profile_photo',
    );
    return result.fold(
      (status) => {'status': 'error', 'message': 'فشل الاتصال'},
      (data) => data,
    );
  }

  Future<dynamic> sendVerifyDocument(File image) async {
    String? token = await authModel.getToken();
    try {
      // إنشاء طلب متعدد الأجزاء (multipart request)
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiLink.verify), // تأكد من صحة المسار
      );
      // إضافة التوكن في الـ Header
      request.headers['Authorization'] = 'Bearer $token';
      // إضافة الصورة - تأكد أن اسم الحقل هو 'document' كما في الباك إند
      var pic = await http.MultipartFile.fromPath(
        'document', // ✅ التصحيح: يجب أن يكون 'document' وليس 'photo'
        image.path,
        filename: 'verify_document_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      request.files.add(pic);

      print('إرسال الطلب...');
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      print('كود الاستجابة: ${response.statusCode}');
      print('بيانات الاستجابة: $responseData');

      // التحقق من نجاح الطلب
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = json.decode(responseData);
        return {'status': 'success', 'data': jsonResponse};
      } else {
        print('خطأ في الاستجابة: ${response.statusCode}');
        
        // محاولة قراءة رسالة الخطأ من الاستجابة
        try {
          var errorResponse = json.decode(responseData);
          return {
            'status': 'error', 
            'message': errorResponse['message'] ?? 'حدث خطأ في إرسال الطلب'
          };
        } catch (e) {
          return StatusRequest.serverFailure;
        }
      }
    } catch (e) {
      print("Error uploading image: $e");
      return StatusRequest.serverFailure;
    }
  }
}
