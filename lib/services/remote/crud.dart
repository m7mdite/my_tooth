import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../utils/app_constants/status_request.dart';
import '../local_storge/local_user_storage.dart';

class Crud {
  final LocalUserStorage localStorage = Get.find<LocalUserStorage>();

  // ============================================================
  // POST
  // ============================================================
  Future<Either<StatusRequest, Map>> postData(
    String linkurl,
    Map data, {
    Map<String, String>? header,
  }) async {
    final String? token = await localStorage.getToken();
    try {
      final headers = header ?? {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final response = await http.post(
        Uri.parse(linkurl),
        headers: headers,
        body: jsonEncode(data),
      );
      final Map responsebody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(responsebody);
      } else {
        Get.snackbar(
          responsebody['status'] ?? 'خطأ',
          responsebody['message'] ?? 'حدث خطأ',
        );
        return right(responsebody);
      }
    } catch (e) {
      return left(StatusRequest.serverFailure);
    }
  }

  // ============================================================
  // POST Many (List)
  // ============================================================
  Future<Either<StatusRequest, Map>> postManyData(
    String linkurl,
    List<Map<String, dynamic>> data, {
    Map<String, String>? header,
  }) async {
    final String? token = await localStorage.getToken();
    try {
      final headers = header ?? {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final response = await http.post(
        Uri.parse(linkurl),
        headers: headers,
        body: jsonEncode(data),
      );
      final Map responsebody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(responsebody);
      } else {
        Get.snackbar(
          responsebody['status'] ?? 'خطأ',
          responsebody['message'] ?? 'حدث خطأ',
        );
        return right(responsebody);
      }
    } catch (e) {
      print('Exception in postManyData: $e');
      return left(StatusRequest.serverFailure);
    }
  }

  // ============================================================
  // GET
  // ============================================================
 
 Future<Either<StatusRequest, Map>> getData(
    String linkurl, {
    Map<String, String>? header,
  }) async {
    final String? token = await localStorage.getToken();
    try {
      final headers = header ?? {
        if (token != null) 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final response = await http.get(
        Uri.parse(linkurl),
        headers: headers,
      );
      final Map responsebody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(responsebody);
      } else {
        print('${responsebody['message']} ${responsebody['status']}');
        return right(responsebody);
      }
    } catch (e) {
      print('Exception in getData: $e');
      return left(StatusRequest.serverFailure);
    }
  }

  // ============================================================
  // PUT (JSON)
  // ============================================================
  Future<Either<StatusRequest, Map>> putData(
    String linkurl,
    Map data,
    String id, {
    Map<String, String>? header,
  }) async {
    final String? token = await localStorage.getToken();
    try {
      final headers = header ?? {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final response = await http.put(
        Uri.parse('$linkurl/$id'),
        headers: headers,
        body: jsonEncode(data),
      );
      final Map responsebody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(responsebody);
      } else {
        Get.snackbar(
          responsebody['status'] ?? 'خطأ',
          responsebody['message'] ?? 'حدث خطأ',
        );
        return right(responsebody);
      }
    } catch (e) {
      print('Exception in putData: $e');
      return left(StatusRequest.serverFailure);
    }
  }

  // ============================================================
  // DELETE
  // ============================================================
  Future<Either<StatusRequest, Map>> deleteData(
    String linkurl,
    String id, {
    Map<String, String>? header,
  }) async {
    final String? token = await localStorage.getToken();
    try {
      final headers = header ?? {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final response = await http.delete(
        Uri.parse('$linkurl/$id'),
        headers: headers,
      );
      final Map responsebody = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(responsebody);
      } else {
        print('Delete failed: ${responsebody['message']}');
        return left(StatusRequest.serverFailure);
      }
    } catch (e) {
      print('Exception in deleteData: $e');
      return left(StatusRequest.serverFailure);
    }
  }

  // ============================================================
  // POST with Files (Multipart)
  // ============================================================
  Future<Either<StatusRequest, Map>> postDataWithFiles(
    String url,
    Map<String, String> data,
    List<String> filePaths,
    String fileField,
  ) async {
    final String? token = await localStorage.getToken();
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields.addAll(data);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    for (final path in filePaths) {
      final file = File(path);
      if (!await file.exists()) {
        return Left(StatusRequest.serverFailure);
      }
      request.files.add(await http.MultipartFile.fromPath(fileField, path));
    }

    try {
      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      final responseBody = jsonDecode(responseString);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(responseBody);
      } else {
        Get.snackbar(
          responseBody['status'] ?? 'خطأ',
          responseBody['message'] ?? 'فشل رفع الملفات',
        );
        return Right(responseBody);
      }
    } catch (e) {
      print('Exception in postDataWithFiles: $e');
      return Left(StatusRequest.serverFailure);
    }
  }

  // ============================================================
  // PUT with Files (Multipart)
  // ============================================================
  Future<Either<StatusRequest, Map>> putDataWithFiles(
    String url,
    Map<String, String> data,
    List<String> filePaths,
    String fileField,
  ) async {
    final String? token = await localStorage.getToken();
    final request = http.MultipartRequest('PUT', Uri.parse(url));

    request.fields.addAll(data);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    for (final path in filePaths) {
      final file = File(path);
      if (!await file.exists()) {
        return Left(StatusRequest.serverFailure);
      }
      request.files.add(await http.MultipartFile.fromPath(fileField, path));
    }

    try {
      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      final responseBody = jsonDecode(responseString);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(responseBody);
      } else {
        Get.snackbar(
          responseBody['status'] ?? 'خطأ',
          responseBody['message'] ?? 'فشل رفع الملفات',
        );
        return Right(responseBody);
      }
    } catch (e) {
      print('Exception in putDataWithFiles: $e');
      return Left(StatusRequest.serverFailure);
    }
  }
}