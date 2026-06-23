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
    var response = await crud.postData(
        "${ApiLink.acceptVerifyStudent}/$studentId", {});
    return response.fold((l) => l, (r) => r);
  }
  rejectVerifyStudent(String studentId,{Map? data}) async {
    var response = await crud.postData(
        "${ApiLink.rejectVerifyStudent}/$studentId", data??{"reject_reason":"خطأ بالبيانات!"});
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
    var response = await crud.getData(ApiLink.getAllPendingRequests);
    return response.fold((l) => l, (r) => r);
  }

  getAllInProcessingRequests() async {
    var response = await crud.getData(ApiLink.getAllInProcessingRequests);
    return response.fold((l) => l, (r) => r);
  }

  getAllFinishedRequests() async {
    var response = await crud.getData(ApiLink.getAllFinishedRequests);
    return response.fold((l) => l, (r) => r);
  }

  getAllRejectedRequests() async {
    var response = await crud.getData(ApiLink.getAllRejectedRequests);
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

  addLesson(Map data) async {
    var response = await crud.postData(
      ApiLink.addLesson,
      data,
    );
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
}
