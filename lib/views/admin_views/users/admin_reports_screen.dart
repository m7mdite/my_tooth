// views/admin/admin_reports_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/admin_controller/admin_reports_controller.dart';
import 'package:gr_flutter/models/admin/report_model.dart';

class AdminReportsScreen extends StatelessWidget {
  final AdminReportsController controller = Get.put(AdminReportsController());
  AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('البلاغات'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchReports();
        },
        child: GetBuilder<AdminReportsController>(
          builder: (controller) {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.reports.isEmpty) {
              return const Center(child: Text('لا توجد بلاغات معلقة'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: controller.reports.length,
              itemBuilder: (context, index) {
                final report = controller.reports[index];
                return _buildReportCard(report);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildReportCard(ReportModel report) {
    final bool isPending = report.status == 'pending';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${report.reporter?.fullName ?? 'مبلغ'} ← بلغ عن → ${report.reported?.firstName ?? ''} ${report.reported?.lastName ?? ''}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                if (isPending)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('قيد الانتظار', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text('النوع: ${report.type ?? 'غير محدد'}'),
            if (report.reason != null && report.reason!.isNotEmpty)
              Text('السبب: ${report.reason}'),
            const SizedBox(height: 8),
            Text('تاريخ الإبلاغ: ${_formatDateString(report.createdAt)}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            if (report.adminNote != null && report.adminNote!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('📝 ملاحظة الأدمن: ${report.adminNote}'),
                ),
              ),
            if (report.reviewedAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('تمت المراجعة: ${_formatDate(report.reviewedAt!)}', style: const TextStyle(fontSize: 11, color: Colors.green)),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isPending)
                  _actionButton(
                    icon: Icons.done_all,
                    label: 'تعليم كمقروء',
                    color: Colors.green,
                    onTap: () => controller.markAsRead(report.sId!),
                  ),
                const SizedBox(width: 8),
                _actionButton(
                  icon: Icons.comment,
                  label: 'ملاحظة',
                  color: Colors.orange,
                  onTap: () => _showAddNoteDialog(report.sId!),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  void _showAddNoteDialog(String reportId) {
    final noteController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('إضافة ملاحظة'),
        content: TextField(
          controller: noteController,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'أدخل ملاحظة الأدمن...'),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              controller.addNote(reportId, noteController.text);
              Get.back();
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  String _formatDateString(String? dateString) {
    if (dateString == null) return 'غير معروف';
    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}