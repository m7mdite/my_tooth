import '../../api_link.dart';
import '../crud.dart';
import '../shared/auth_model.dart';

class AdminRemote {
  final AuthModel authModel = AuthModel();

  Crud crud;
  AdminRemote(this.crud);
  addOverSeer(Map data) async {
    final String? token = await authModel.getToken();

    var response = await crud.postData(ApiLink.addOverSeer, data, {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }

  acceptVerifyStudent(String studentId) async {
    final String? token = await authModel.getToken();

    var response =
        await crud.postData("${ApiLink.acceptVerifyStudent}/$studentId", {
      'studentId': studentId
    }, {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }

  getAllOverSeers() async {
    final String? token = await authModel.getToken();

    var response = await crud.getData(ApiLink.getAllOverSeers, {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }

  getAllStudents() async {
    final String? token = await authModel.getToken();

    var response = await crud.getData(ApiLink.getAllStudents, {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }

  getAllPatientes() async {
    final String? token = await authModel.getToken();

    var response = await crud.getData(ApiLink.getAllPatientes, {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }

  getAllVerifyStudents() async {
    final String? token = await authModel.getToken();

    var response = await crud.getData(ApiLink.getAllVerifyStudents, {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }

  getAllCourses() async {
    final String? token = await authModel.getToken();

    var response = await crud.getData(ApiLink.getAllCourses, {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }

  getAllTreatments() async {
    final String? token = await authModel.getToken();

    var response = await crud.getData(ApiLink.getAllTreatments, {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }

  addTreatment(Map data) async {
    final String? token = await authModel.getToken();

    var response = await crud.postData(ApiLink.addTreatment, data, {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }

  addCourse(Map data) async {
    final String? token = await authModel.getToken();

    var response = await crud.postData(ApiLink.addCourse, data, {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }
}
