import 'package:gr_flutter/services/remote/crud.dart';
import 'package:gr_flutter/api_link.dart';

class DashboardRemote {
  final Crud crud;
  DashboardRemote(this.crud);

  getDashboard() async {
    final response = await crud.getData(ApiLink.dashboard);
    return response.fold((l) => l, (r) => r);
  }
}