import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utils/app_constants/status_request.dart';
import 'shared/auth_model.dart';

class Crud {
  final AuthModel authModel = AuthModel();
  // ================================================================
  Future<Either<StatusRequest, Map>> postData(
      String linkurl, Map data,{ Map<String, String>? header}) async {
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
  Future<Either<StatusRequest, Map>> getData(
      String linkurl,{ Map<String, String>? header}) async {
        final String? token = await authModel.getToken();
    try {
      var response = await http.get(Uri.parse(linkurl), headers: header??{
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
      String linkurl, Map data,  String id,{ Map<String, String>? header}) async {
        final String? token = await authModel.getToken();

    try {
      // if(await checkInternet()){
      var response = await http.put(
        Uri.parse("$linkurl/$id"),
        headers: header??{
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
  Future<Either<StatusRequest, Map>> deleteData(
      String linkurl, String id,{ Map<String, String>? header}) async {
            final String? token = await authModel.getToken();
    try {
      // if(await checkInternet()){
      var response = await http.delete(
        Uri.parse("$linkurl/$id"),
        headers: header??{
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
}
