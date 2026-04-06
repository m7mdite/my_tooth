import 'dart:convert';
import 'dart:io';

import 'package:gr_flutter/services/shared/auth_model.dart';
import 'package:http/http.dart' as http;
import '../../api_link.dart';
import '../../utils/app_constants/status_request.dart';
import '../crud.dart';

class StudentRemote {
  final AuthModel authModel = AuthModel();

  Crud crud;
  StudentRemote(this.crud);
  
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