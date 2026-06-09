import 'package:gr_flutter/api_link.dart';
import 'package:gr_flutter/services/remote/crud.dart';

class AuthRemote {
  Crud crud;
  AuthRemote(this.crud);
  register(Map data)async{
    var response=await crud.postData(ApiLink.register, data,);
    return response.fold((l) => l, (r) => r);
  }
  login(Map data)async{
    var response=await crud.postData(ApiLink.login, data,);
    return response.fold((l) => l, (r) => r);
  }
}