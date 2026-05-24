// controllers/admin_controller/admin_reports_controller.dart
import 'package:get/get.dart';
import 'package:gr_flutter/models/admin/report_model.dart';
import 'package:gr_flutter/services/remote/admin_reports_remote.dart';
import '../../services/crud.dart';
import '../../services/functions/handling_data.dart';
import '../../utils/app_constants/status_request.dart';

class AdminReportsController extends GetxController {
  final AdminReportsRemote remote = AdminReportsRemote(Get.find<Crud>());
  List<ReportModel> reports = [];
  RxBool isLoading = false.obs;
  StatusRequest statusRequest = StatusRequest.none;

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  Future<void> fetchReports() async {
    isLoading.value = true;
    statusRequest = StatusRequest.loading;
    update();
    var response = await remote.getPendingReports();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      // الباك يعيد { status: 'success', data: [...] }
      List<dynamic> data = response['data'] ?? [];
      reports = data.map((json) => ReportModel.fromJson(json)).toList();
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل تحميل البلاغات');
    }
    isLoading.value = false;
    update();
  }

  // تعليم البلاغ كمقروء (بدون ملاحظة)
  Future<void> markAsRead(String reportId) async {
    var response = await remote.reviewReport(reportId);
    if (handlingData(response) == StatusRequest.success) {
      // تحديث محلي: تغيير الحالة إلى reviewed وإضافة reviewedAt
      int index = reports.indexWhere((r) => r.sId == reportId);
      if (index != -1) {
        ReportModel old = reports[index];
        reports[index] = ReportModel(
          sId: old.sId,
          reason: old.reason,
          type: old.type,
          status: 'reviewed',
          adminNote: old.adminNote,
          reviewedAt: DateTime.now(),
          reviewedBy: 'admin', // قد لا يكون متوفراً، يفضل قراءة من الـ response إن وجد
          createdAt: old.createdAt,
          reporter: old.reporter,
          reported: old.reported,
        );
        update();
        Get.snackbar('تم', 'تم تحديث حالة البلاغ');
      }
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل تحديث البلاغ');
    }
  }

  // إضافة ملاحظة (ثم تعليم كمقروء)
  Future<void> addNote(String reportId, String note) async {
    if (note.trim().isEmpty) return;
    var response = await remote.reviewReport(reportId, note: note);
    if (handlingData(response) == StatusRequest.success) {
      int index = reports.indexWhere((r) => r.sId == reportId);
      if (index != -1) {
        ReportModel old = reports[index];
        reports[index] = ReportModel(
          sId: old.sId,
          reason: old.reason,
          type: old.type,
          status: 'reviewed',
          adminNote: note,
          reviewedAt: DateTime.now(),
          reviewedBy: 'admin',
          createdAt: old.createdAt,
          reporter: old.reporter,
          reported: old.reported,
        );
        update();
        Get.snackbar('تم', 'تم إضافة الملاحظة وتحديث الحالة');
      }
    } else {
      Get.snackbar('خطأ', response['message'] ?? 'فشل إضافة الملاحظة');
    }
  }

  // الحذف غير مدعوم في الباك، يمكن إزالته أو تجاهله
  void deleteReport(String reportId) {
    Get.snackbar('غير متاح', 'حذف البلاغات غير مدعوم حالياً');
  }
}