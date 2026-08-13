import 'dart:io';

import '../../../api_link.dart';
import '../crud.dart';

class AdminRemote {
  Crud crud;
  AdminRemote(this.crud);
  addOverSeer(Map data) async {
    var response = await crud.postData(
      ApiLink.addOverSeer,
      data,
    );
    return response.fold((l) => l, (r) => r);
  }

  // داخل AdminRemote
  deleteOverSeer(String id) async {
    var response = await crud.postData('${ApiLink.deleteOverSeer}/$id', {});
    return response.fold((l) => l, (r) => r);
  }

  acceptVerifyStudent(String studentId) async {
    var response =
        await crud.postData("${ApiLink.acceptVerifyStudent}/$studentId", {});
    return response.fold((l) => l, (r) => r);
  }

  rejectVerifyStudent(String studentId, {Map? data}) async {
    var response = await crud.postData(
        "${ApiLink.rejectVerifyStudent}/$studentId",
        data ?? {"reject_reason": "خطأ بالبيانات!"});
    return response.fold((l) => l, (r) => r);
  }

  getAllOverSeers() async {
    var response = await crud.getData(
      ApiLink.getAllOverSeers,
    );
    return response.fold((l) => l, (r) => r);
  }

  getAllStudents() async {
    var response = await crud.getData(
      ApiLink.getAllStudents,
    );
    return response.fold((l) => l, (r) => r);
  }

  getAllPatientes() async {
    var response = await crud.getData(
      ApiLink.getAllPatientes,
    );
    return response.fold((l) => l, (r) => r);
  }

  getAllVerifyStudents() async {
    var response = await crud.getData(
      ApiLink.getAllVerifyStudents,
    );
    return response.fold((l) => l, (r) => r);
  }

  getAllCourses() async {
    var response = await crud.getData(
      ApiLink.getAllCourses,
    );
    return response.fold((l) => l, (r) => r);
  }

  getAllTreatments() async {
    var response = await crud.getData(
      ApiLink.getAllTreatments,
    );
    return response.fold((l) => l, (r) => r);
  }

  getAllCategory() async {
    var response = await crud.getData(
      ApiLink.getAllCategory,
    );
    return response.fold((l) => l, (r) => r);
  }

  getAllPendingRequests() async {
    var response = await crud.getData(ApiLink.getPendingRequest);
    return response.fold((l) => l, (r) => r);
  }

  getAllInProcessingRequests() async {
    var response = await crud.getData(ApiLink.getProcessingRequests);
    return response.fold((l) => l, (r) => r);
  }

  getCompletedRequests() async {
    var response = await crud.getData(ApiLink.getCompletedRequests);
    return response.fold((l) => l, (r) => r);
  }

  getAllRejectedRequests() async {
    var response = await crud.getData(ApiLink.getRejectedRequests);
    return response.fold((l) => l, (r) => r);
  }

  addTreatment(Map data) async {
    var response = await crud.postData(
      ApiLink.addTreatment,
      data,
    );
    return response.fold((l) => l, (r) => r);
  }

  addCourse(Map data) async {
    var response = await crud.postData(
      ApiLink.addCourse,
      data,
    );
    return response.fold((l) => l, (r) => r);
  }

  addLessons(List<Map<String, dynamic>> data) async {
    var response = await crud.postManyData(
      ApiLink.weeklySchedule,
      data,
    );
    return response.fold((l) => l, (r) => r);
  }
  Future updateLesson(String id, Map data) async {
  var response = await crud.postData('${ApiLink.weeklySchedule}/$id', data);
  return response.fold((l) => l, (r) => r);
}

  addCategory(Map data) async {
    var response = await crud.postData(
      ApiLink.addCategory,
      data,
    );
    return response.fold((l) => l, (r) => r);
  }

  deleteCategory(String id) async {
    var response = await crud.postData('${ApiLink.categories}/$id/delete', {});
    return response.fold((l) => l, (r) => r);
  }

  // اعلانات
  getAllAdvertisements() async {
    var response = await crud.getData(ApiLink.advertisements);
    return response.fold((l) => l, (r) => r);
  }

  createAdvertisement({
    required String content,
    required File imageFile,
  }) async {
    final response = await crud.postDataWithFiles(
      ApiLink.advertisements,
      {'content': content},
      [imageFile.path],
      'image', // ✅ اسم الحقل كما هو متوقع في الباك إند (upload.single('image'))
    );

    return response.fold((l) => l, (r) => r);
  }

   deleteAdvertisement(String id) async {
    final response = await crud.deleteData(ApiLink.advertisements, id);
    return response.fold((l) => l, (r) => r);
    // return result.fold(
    //   (status) => {'status': 'error', 'message': 'فشل الحذف'},
    //   (data) => data,
    // );
  }


   getWeeklySchedule() async {
    final result = await crud.getData(ApiLink.weeklySchedule);
    return result.fold((l) => l, (r) => r);
  }
   notifyUsersByRoles({
    required String title,
    required String body,
    required List<String> roles,
  }) async {
    final response = await crud.postData(
      ApiLink.notifyAll,
      {
        'title': title,
        'body': body,
        'roles': roles,
      },
    );
    return response.fold((l) => l, (r) => r);
    
  }
  // حذف طلب علاج (Patient/Admin) — DELETE /api/request/:id
deleteTreatmentRequest(String id) async {
  var response = await crud.deleteData(ApiLink.requests, id);
  return response.fold((l) => l, (r) => r);
}

// تحديث/رفض طلب — PUT /api/request/:id
// ⚠️ لاحظ: الراوت بالباك اند PUT وليس POST، تأكد إنه crud عنده putData
// وإلا عدّل الميثود بالباك اند لتقبل POST متل باقي التحديثات عندك
updateTreatmentRequest(String id, Map data) async {
  var response = await crud.postData('${ApiLink.requests}/$id', data);
  return response.fold((l) => l, (r) => r);
}

// قبول الطلب وتعيين مشرف — POST /api/request/accept/:id/:overseer
acceptRequest(String id, String overseerId) async {
  var response =
      await crud.postData('${ApiLink.acceptRequest}/$id/$overseerId', {});
  return response.fold((l) => l, (r) => r);
}

// إعادة تعيين مشرف — PUT /api/request/reassign-overseer/:id/:overseer
reassignOverseer(String id, String overseerId) async {
  var response = await crud
      .postData('${ApiLink.reassignOverseer}/$id/$overseerId', {});
  return response.fold((l) => l, (r) => r);
}

// جلب مشرفين كورس معيّن — GET /api/request/course-overseers/:id
getCourseOverseers(String courseId) async {
  var response =
      await crud.getData('${ApiLink.courseOverseers}/$courseId');
  return response.fold((l) => l, (r) => r);
}
}
