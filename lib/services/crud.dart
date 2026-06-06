import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utils/app_constants/status_request.dart';
import 'shared/auth_model.dart';

class Crud {
  final AuthModel authModel = AuthModel();
  // ================================================================
  Future<Either<StatusRequest, Map>> postData(String linkurl, Map data,
      {Map<String, String>? header}) async {
    final String? token = await authModel.getToken();
    try {
      final headers = header ??
          {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          };
      // if(await checkInternet()){
      var response = await http.post(
        Uri.parse(linkurl),
        headers: headers,
        body: jsonEncode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = jsonDecode(response.body);
        if (responsebody.containsKey('message')) {
          print("$responsebody");
          // Get.snackbar(
          //   "${responsebody['status']}",
          //   "${responsebody['message']}",
          // );
        }
        return right(responsebody);
      } else {
        Map responsebody = jsonDecode(response.body);
        Get.snackbar("${responsebody['status']}", "${responsebody['message']}");
        return right(responsebody);
      }
      // }else{
      //   return left(StatusRequest.offlinefailure);
      // }
    } catch (e) {
      // ← استخدم e بدلاً من _ لرؤية الخطأ
      print('Exception: $e');
      return left(StatusRequest.serverFailure);
    }
  }

// ============================================      read
  Future<Either<StatusRequest, Map>> getData(String linkurl,
      {Map<String, String>? header}) async {
    final String? token = await authModel.getToken();
    try {
      var response = await http.get(Uri.parse(linkurl),
          headers: header ??
              {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              });
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("${response.body}");
        Map responsebody = jsonDecode(response.body);
        // Get.snackbar(
        //     "${responsebody['status']}",
        //     "${responsebody['message']}",
        //   );
        return right(responsebody);
      } else {
        Map responsebody = jsonDecode(response.body);
        print("${responsebody['message']}"
            "${responsebody['status']}");
        return right(responsebody);
      }
    } catch (e) {
      print('Exception: $e');
      return left(StatusRequest.serverFailure);
    }
  }

  // ========================================================  update
  Future<Either<StatusRequest, Map>> putData(
      String linkurl, Map data, String id,
      {Map<String, String>? header}) async {
    final String? token = await authModel.getToken();

    try {
      // if(await checkInternet()){
      var response = await http.put(
        Uri.parse("$linkurl/$id"),
        headers: header ??
            {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("${response.body}");
        Map responsebody = jsonDecode(response.body);
        return right(responsebody);
      } else {
        Map responsebody = jsonDecode(response.body);

        Get.snackbar(
          "${responsebody['status']}",
          "${responsebody['message']}",
        );
        return right(responsebody);
      }
      // }else{
      //   return left(StatusRequest.offlinefailure);
      // }
    } catch (e) {
      printError(info: e.toString());
      return left(StatusRequest.serverFailure);
    }
  }

  // ============================================================= delete
  Future<Either<StatusRequest, Map>> deleteData(String linkurl, String id,
      {Map<String, String>? header}) async {
    final String? token = await authModel.getToken();
    try {
      // if(await checkInternet()){
      var response = await http.delete(
        Uri.parse("$linkurl/$id"),
        headers: header ??
            {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = jsonDecode(response.body);
        print("${responsebody['message']}");
        return right(responsebody);
      } else {
        print("object${jsonDecode(response.body)}");
        return left(StatusRequest.serverFailure);
      }
    } catch (_) {
      return left(StatusRequest.serverFailure);
    }
  }

  Future<Either<StatusRequest, Map>> postDataWithFiles(
  String url,
  Map<String, String> data,
  List<String> filePaths,
  String fileField,
) async {
  final String? token = await authModel.getToken();
  var request = http.MultipartRequest('POST', Uri.parse(url));

  // إضافة الحقول النصية
  request.fields.addAll(data);

  // إضافة الترويسات
  request.headers.addAll({
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  });

  // إضافة الملفات (كل ملف بنفس اسم الحقل)
  for (var path in filePaths) {
    // تأكد من أن الملف موجود
    final file = File(path);
    if (!await file.exists()) {
      return Left(StatusRequest.serverFailure);
    }
    final multipartFile = await http.MultipartFile.fromPath(fileField, path);
    request.files.add(multipartFile);
  }

  try {
    final response = await request.send();
    final responseString = await response.stream.bytesToString();
    final responseBody = jsonDecode(responseString);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Right(responseBody);
    } else {
      // عرض رسالة الخطأ من السيرفر
      Get.snackbar(
        responseBody['status'] ?? 'خطأ',
        responseBody['message'] ?? 'حدث خطأ أثناء رفع الصور',
      );
      return Right(responseBody); // أو Left(StatusRequest.serverFailure)
    }
  } catch (e) {
    print('Exception in postDataWithFiles: $e');
    return Left(StatusRequest.serverFailure);
  }
}
}
