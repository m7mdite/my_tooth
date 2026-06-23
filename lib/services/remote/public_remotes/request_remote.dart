import 'dart:convert';
import 'dart:io';

import 'package:gr_flutter/api_link.dart';
import 'package:gr_flutter/services/remote/crud.dart';

class RequestRemote {
  final Crud crud;
  RequestRemote(this.crud);

  // ========== دوال GET (بدون ملفات) ==========
  getTreatments() async {
    var response = await crud.getData(ApiLink.treatments);
    return response.fold((l) => l, (r) => r);
  }

  getTreatmentRequestsForOverseer() async {
    var response = await crud.getData(ApiLink.treatmentRequestsForOverseer);
    return response.fold((l) => l, (r) => r);
  }

  getPendingRequests() async {
    var response = await crud.getData(ApiLink.requests);
    return response.fold((l) => l, (r) => r);
  }

  getOverSeerForCourse(String id) async {
    var response = await crud.getData("${ApiLink.getOverSeerForCourse}/$id");
    return response.fold((l) => l, (r) => r);
  }

  fetchingSpecialData() async {
    var response = await crud.getData(ApiLink.ownedStudentRequest);
    return response.fold((l) => l, (r) => r);
  }

  getPendingPatientRequest() async {
    var response = await crud.getData(ApiLink.pendingPatientRequest);
    return response.fold((l) => l, (r) => r);
  }

  getInProcessingPatientRequest() async {
    var response = await crud.getData(ApiLink.inProcessingPatientRequest);
    return response.fold((l) => l, (r) => r);
  }

  getCompletedPatientRequest() async {
    var response = await crud.getData(ApiLink.completedPatientRequest);
    return response.fold((l) => l, (r) => r);
  }
  getRejectedPatientRequest() async {
    var response = await crud.getData(ApiLink.completedPatientRequest);
    return response.fold((l) => l, (r) => r);
  }

  // ========== دوال POST / PUT / DELETE ==========
  acceptRequestData(Map data, String idR, String idO) async {
    var response = await crud.postData("${ApiLink.acceptRequest}/$idR/$idO", data);
    return response.fold((l) => l, (r) => r);
  }

  dunningOverseerData(Map data, String idR, String idO) async {
    var response = await crud.putData("${ApiLink.dunningOverseer}/$idR", data, idO);
    return response.fold((l) => l, (r) => r);
  }

  changeCaseRequestData(Map data, String idR, String idC) async {
    var response = await crud.putData("${ApiLink.changeCaseRequest}/$idR", data, idC);
    return response.fold((l) => l, (r) => r);
  }

  rejectRequestData(Map data, String id) async {
    var response = await crud.putData(ApiLink.rejectRequest, data, id);
    return response.fold((l) => l, (r) => r);
  }

  complateRequestData(Map data, String id) async {
    var response = await crud.putData(ApiLink.complateRequest, data, id);
    return response.fold((l) => l, (r) => r);
  }

  addEvaluationRequestData(Map data, String id) async {
    var response = await crud.putData(ApiLink.addEvaluationRequest, data, id);
    return response.fold((l) => l, (r) => r);
  }

  deleteRequest(String id) async {
    var response = await crud.deleteData(ApiLink.requests, id);
    return response.fold((l) => l, (r) => r);
  }

  // ========== دوال رفع الملفات (باستخدام Crud) ==========
  Future<dynamic> sendRequestData(Map<String, dynamic> data, File? image) async {
    if (image == null) {
      // بدون صورة → JSON عادي
      var response = await crud.postData(ApiLink.requests, data);
      return response.fold((l) => l, (r) => r);
    } else {
      // مع صورة → Multipart
      final stringData = _convertToStringMap(data);
      final result = await crud.postDataWithFiles(
        ApiLink.requests,
        stringData,
        [image.path],
        'photo',
      );
      return result.fold(
        (status) => {'status': 'error', 'message': 'فشل إرسال الطلب'},
        (data) => data,
      );
    }
  }

  Future<dynamic> updateRequestData(Map<String, dynamic> data, File? image, String id) async {
    if (image == null) {
      // بدون صورة → PUT عادي
      var response = await crud.putData(ApiLink.requests, data, id);
      return response.fold((l) => l, (r) => r);
    } else {
      // مع صورة → PUT Multipart
      final stringData = _convertToStringMap(data);
      final result = await crud.putDataWithFiles(
        "${ApiLink.requests}/$id",
        stringData,
        [image.path],
        'photo',
      );
      return result.fold(
        (status) => {'status': 'error', 'message': 'فشل تحديث الطلب'},
        (data) => data,
      );
    }
  }

  // دالة مساعدة لتحويل Map<String, dynamic> إلى Map<String, String>
  Map<String, String> _convertToStringMap(Map<String, dynamic> data) {
    Map<String, String> result = {};
    data.forEach((key, value) {
      if (value != null) {
        if (key == 'more_details') {
          result[key] = jsonEncode(value);
        } else {
          result[key] = value.toString();
        }
      }
    });
    return result;
  }
}