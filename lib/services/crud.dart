import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../utils/app_constants/status_request.dart';

class Crud {
  // ================================================================
  Future<Either<StatusRequest, Map>> postData(
      String linkurl, Map data, Map<String, String>? header) async {
    try {
      final headers = header ??
          {
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
          // Get.snackbar(
          //   "${responsebody['status']}",
          //   "${responsebody['message']}",
          // );
        }
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
      // ← استخدم e بدلاً من _ لرؤية الخطأ
      print('Exception: $e');
      return left(StatusRequest.serverFailure);
    }
  }

// ============================================      read
  Future<Either<StatusRequest, Map>> getData(
      String linkurl, Map<String, String>? header) async {
    try {
      var response = await http.get(Uri.parse(linkurl), headers: header);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = jsonDecode(response.body);
        // Get.snackbar(
        //     "${responsebody['status']}",
        //     "${responsebody['message']}",
        //   );
        return right(responsebody);
      } else {
        Map responsebody = jsonDecode(response.body);

        Get.snackbar(
            "${responsebody['status']}",
            "${responsebody['message']}",
          );
        return right(responsebody);
      }
    } catch (e) {
      print('Exception: $e');
      return left(StatusRequest.serverFailure);
    }
  }

  // ========================================================  update
  Future<Either<StatusRequest, Map>> putData(
      String linkurl, Map data, Map<String, String>? header, String id) async {
    try {
      // if(await checkInternet()){
      var response = await http.put(
        Uri.parse("$linkurl/$id"),
        headers: header!,
        body: jsonEncode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = jsonDecode(response.body);
        return right(responsebody);
      } else {
        return left(StatusRequest.serverFailure);
      }
      // }else{
      //   return left(StatusRequest.offlinefailure);
      // }
    } catch (_) {
      return left(StatusRequest.serverFailure);
    }
  }

  // ============================================================= delete
  Future<Either<StatusRequest, Map>> deleteData(
      String linkurl, Map<String, String>? header, String id) async {
    try {
      // if(await checkInternet()){
      var response = await http.delete(
        Uri.parse("$linkurl/$id"),
        headers: header,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = jsonDecode(response.body);
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
