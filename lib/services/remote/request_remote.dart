import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../api_link.dart';
import '../../utils/app_constants/status_request.dart';
import '../crud.dart';
import '../shared/auth_model.dart';

class RequestRemote {
  final AuthModel authModel = AuthModel();

  Crud crud;
  RequestRemote(this.crud);
  fetchingData() async {
    final String? token = await authModel.getToken();
    var response = await crud.getData(ApiLink.requests, {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }
  fetchingSpecialData() async {
    final String? token = await authModel.getToken();
    var response = await crud.getData(ApiLink.ownedStudentRequest, {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }

  acceptRequestData(Map data, String id) async {
    final String? token = await authModel.getToken();
    print(ApiLink.acceptRequest);
    var response = await crud.postData("${ApiLink.acceptRequest}/$id", data, {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }

  deleteRequest(String id) async {
    final String? token = await authModel.getToken();
    var response = await crud.deleteData(
        ApiLink.requests,
        {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        id);
        print("$response");
        return response.fold((l) => l, (r) => r);
  }

  fetchingMyData() async {
    final String? token = await authModel.getToken();
    var response = await crud.getData(ApiLink.myRequests, {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }

  // updateRequestData(Map data,File? image) async {
  //   final String? token = await authModel.getToken();
  //   print(ApiLink.requests);
  //   // if(image!=null)uploadRequestPicture(image);
  //   var response = await crud.postData(ApiLink.requests, data, {
  //     'Authorization': 'Bearer $token',
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //   });
  //   return response.fold((l) => l, (r) => r);
  // }
  // دالة التحديث مع إمكانية رفع صورة
  updateRequestData(Map<String, dynamic> data, File? image,String id) async {
    var uri = Uri.parse("${ApiLink.requests}/$id");
    var request = http.MultipartRequest('PUT', uri);

    final String? token = await authModel.getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.headers['Accept'] = 'application/json';
    if (image == null) {
      // بدون صورة - إرسال JSON عادي
      var response = await crud.putData(ApiLink.requests, data, {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },id);
      return response.fold((l) => l, (r) => r);
    }
    else {
    // مع صورة - إرسال Multipart
    // return await _uploadWithImage(data, image, token);

    var pic = await http.MultipartFile.fromPath(
      'photo',
      image.path,
      // filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg'
    );
    data.forEach((key, value) {
      if (value != null) {
        request.fields[key] = value.toString();
      }
    });
    request.files.add(pic);
    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    print('📥 كود الاستجابة: ${response.statusCode}');
    print('📄 بيانات الاستجابة: $responseData');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        var jsonResponse = json.decode(responseData);
        return {'status': 'success', 'data': jsonResponse};
      } catch (e) {
        return {'status': 'success', 'data': responseData};
      }
    } else {
      print('❌ خطأ في الاستجابة: ${response.statusCode}');
      return StatusRequest.serverFailure;
    }
      }
  }
  sendRequestData(Map<String, dynamic> data, File? image) async {
    var uri = Uri.parse(ApiLink.requests);
    var request = http.MultipartRequest('POST', uri);

    final String? token = await authModel.getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.headers['Accept'] = 'application/json';
    if (image == null) {
      // بدون صورة - إرسال JSON عادي
      var response = await crud.postData(ApiLink.requests, data, {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
      return response.fold((l) => l, (r) => r);
    }
    // else {
    // مع صورة - إرسال Multipart
    // return await _uploadWithImage(data, image, token);

    var pic = await http.MultipartFile.fromPath(
      'photo',
      image.path,
      // filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg'
    );
    data.forEach((key, value) {
      if (value != null) {
        if (key == 'more_details') {
            // حول moreDetails إلى JSON string وأرسله باسم more_details
            request.fields['more_details'] = jsonEncode(value);
            print("reeeeeeee ${jsonEncode(value).runtimeType}");
          } else {
            request.fields[key] = value.toString();
          }
        // request.fields[key] = value.toString();
      }
    });
    request.files.add(pic);
    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    print('📥 كود الاستجابة: ${response.statusCode}');
    print('📄 بيانات الاستجابة: $responseData');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        var jsonResponse = json.decode(responseData);
        return {'status': 'success', 'data': jsonResponse};
      } catch (e) {
        return {'status': 'success', 'data': responseData};
      }
    } else {
      print('❌ خطأ في الاستجابة: ${response.statusCode}');
      return StatusRequest.serverFailure;
    }
      // }
  }

  // دالة خاصة للرفع مع الصورة
  Future<dynamic> _uploadWithImage(
      Map<String, dynamic> data, File image, String? token) async {
    try {
      var uri = Uri.parse(ApiLink.requests);
      print('📤 رابط الرفع: $uri');

      var request = http.MultipartRequest('POST', uri);

      // إضافة الهيدرات
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';

      // إضافة البيانات النصية
      data.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // إضافة الصورة
      var pic = await http.MultipartFile.fromPath(
        'photo', // اسم الحقل الذي يتوقعه الباكند
        image.path,
        filename: 'request_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      request.files.add(pic);

      print('🔄 جاري إرسال البيانات مع الصورة...');
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      print('📥 كود الاستجابة: ${response.statusCode}');
      print('📄 بيانات الاستجابة: $responseData');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          var jsonResponse = json.decode(responseData);
          return {'status': 'success', 'data': jsonResponse};
        } catch (e) {
          return {'status': 'success', 'data': responseData};
        }
      } else {
        print('❌ خطأ في الاستجابة: ${response.statusCode}');
        return StatusRequest.serverFailure;
      }
    } catch (e) {
      print("❌ خطأ في رفع الصورة: $e");
      return StatusRequest.serverFailure;
    }
  }

  // Future<dynamic> uploadRequestPicture(File image) async {
  //   try {
  //     // إضافة الصورة
  //     var pic = await http.MultipartFile.fromPath('photo', image.path,
  //         filename: 'request_${DateTime.now().millisecondsSinceEpoch}.jpg');
  //     request.files.add(pic);

  //     print('إرسال الطلب...');
  //     var response = await request.send();
  //     var responseData = await response.stream.bytesToString();

  //     print('كود الاستجابة: ${response.statusCode}');
  //     print('بيانات الاستجابة: $responseData');

  //     if (response.statusCode == 200) {
  //       var jsonResponse = json.decode(responseData);
  //       return {'status': 'success', 'data': jsonResponse};
  //     } else {
  //       print('خطأ في الاستجابة: ${response.statusCode}');
  //       return StatusRequest.serverFailure;
  //     }
  //   } catch (e) {
  //     print("Error uploading image: $e");
  //     return StatusRequest.serverFailure;
  //   }
  // }
  // Future<dynamic> uploadRequestPicture(File image) async {
  //   try {
  //     var uri = Uri.parse(ApiLink.requests);
  //     print('الرابط: $uri');

  //     var request = http.MultipartRequest('POST', uri);

  //     // إضافة التوكن للمصادقة
  //     String? token = await authModel.getToken();
  //     print('التوكن: ${token != null ? "موجود" : "غير موجود"}');

  //     if (token != null) {
  //       request.headers['Authorization'] = 'Bearer $token';
  //     }

  //     request.headers['Accept'] = 'application/json';

  //     // إضافة الصورة
  //     var pic = await http.MultipartFile.fromPath('photo', image.path,
  //         filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg');
  //     request.files.add(pic);

  //     print('إرسال الطلب...');
  //     var response = await request.send();
  //     var responseData = await response.stream.bytesToString();

  //     print('كود الاستجابة: ${response.statusCode}');
  //     print('بيانات الاستجابة: $responseData');

  //     if (response.statusCode == 200) {
  //       var jsonResponse = json.decode(responseData);
  //       return {'status': 'success', 'data': jsonResponse};
  //     } else {
  //       print('خطأ في الاستجابة: ${response.statusCode}');
  //       return StatusRequest.serverFailure;
  //     }
  //   } catch (e) {
  //     print("Error uploading image: $e");
  //     return StatusRequest.serverFailure;
  //   }
  // }
}
