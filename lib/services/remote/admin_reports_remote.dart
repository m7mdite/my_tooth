import '../../api_link.dart';
import '../crud.dart';

class AdminReportsRemote {
  final Crud crud;
  AdminReportsRemote(this.crud);

   getPendingReports() async {
    var response = await crud.getData(ApiLink.adminReports);
    return response.fold((l) => l, (r) => r);
  }

  // مراجعة البلاغ (تعليم كمقروء + إضافة ملاحظة اختيارية)
   reviewReport(String reportId, {String? note}) async {
    var response = await crud.putData(
      ApiLink.reviewReport(reportId),
      note != null ? {'note': note} : {},""
    );
    return response.fold((l) => l, (r) => r);
  }

  // ملاحظة: لا يوجد حذف في الباك. يمكن إضافة رسالة للمستخدم.
}