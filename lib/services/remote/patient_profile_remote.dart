import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../api_link.dart';
import '../../utils/app_constants/status_request.dart';
import '../crud.dart';
import '../shared/auth_model.dart';

class PatientProfileRemote {
  final AuthModel authModel = AuthModel();

  Crud crud;
  PatientProfileRemote(this.crud);
  updateProfileData(Map data) async {
    var response = await crud.putData(ApiLink.servere, data, "users");
    return response.fold((l) => l, (r) => r);
  }

  fetchingData() async {
    var response = await crud.getData(
      ApiLink.profile,
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> uploadProfilePicture(File image) async {
    try {
      var uri = Uri.parse(ApiLink.photo);
      print('الرابط: $uri');

      var request = http.MultipartRequest('PUT', uri);

      // إضافة التوكن للمصادقة
      String? token = await authModel.getToken();
      print('التوكن: ${token != null ? "موجود" : "غير موجود"}');
      print(token);

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.headers['Accept'] = 'application/json';

      // إضافة الصورة
      var pic = await http.MultipartFile.fromPath(
        'profile_photo',
        image.path,
        // filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg'
      );
      request.files.add(pic);

      print('إرسال الطلب...');
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      print('كود الاستجابة: ${response.statusCode}');
      print('بيانات الاستجابة: $responseData');

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseData);
        return {'status': 'success', 'data': jsonResponse};
      } else {
        print('خطأ في الاستجابة: ${response.statusCode}');
        return StatusRequest.serverFailure;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return StatusRequest.serverFailure;
    }
  }
}
