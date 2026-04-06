import 'package:gr_flutter/api_link.dart';
import 'package:gr_flutter/services/crud.dart';

class AuthRemote {
  Crud crud;
  AuthRemote(this.crud);
  register(Map data)async{
    var response=await crud.postData(ApiLink.register, data,{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }
  login(Map data)async{
    var response=await crud.postData(ApiLink.login, data,{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return response.fold((l) => l, (r) => r);
  }
}