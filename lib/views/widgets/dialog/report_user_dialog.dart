import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/public_controllers/public_controller.dart';

class ReportUserDialog extends StatefulWidget {
  final String reportedUserId;
  const ReportUserDialog({super.key, required this.reportedUserId});

  @override
  State<ReportUserDialog> createState() => _ReportUserDialogState();
}

class _ReportUserDialogState extends State<ReportUserDialog> {
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedReason = 'مضايقة';
  final List<String> _reasons = [
    'مضايقة',
    'محتوى غير لائق',
    'انتحال شخصية',
    'إعلانات مزعجة',
    'سبب آخر',
  ];
  bool _isSubmitting = false;

  Future<void> _submitReport() async {
    if (_selectedReason == 'سبب آخر' && _descriptionController.text.trim().isEmpty) {
      Get.snackbar('تنبيه', 'الرجاء كتابة وصف للسبب', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    setState(() => _isSubmitting = true);
    final publicController = Get.find<PublicController>();
    bool success = await publicController.reportUser(
      userId: widget.reportedUserId,
      reason: _selectedReason,
      description: _selectedReason == 'سبب آخر' ? _descriptionController.text.trim() : '',
    );
    setState(() => _isSubmitting = false);
    if (success) {
      Get.close(1);
      Get.back(); // إغلاق الديالوج
      Get.snackbar('تم', 'تم إرسال البلاغ بنجاح', snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('خطأ', 'فشل إرسال البلاغ، حاول مجدداً', snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.elliptical(100, 10),
            bottomLeft: Radius.elliptical(10, 100),
            topRight: Radius.elliptical(10, 100),
            bottomRight: Radius.elliptical(100, 10),
          ),
          border: Border.all(color: Colors.redAccent, width: 1.5, strokeAlign: 10),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // عنوان الإبلاغ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.report, color: Colors.redAccent, size: 28),
                Text(
                  'إبلاغ عن مستخدم',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 20),
            // قائمة أسباب الإبلاغ
            DropdownButtonFormField<String>(
              value: _selectedReason,
              decoration: InputDecoration(
                labelText: 'سبب الإبلاغ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
              ),
              items: _reasons.map((reason) {
                return DropdownMenuItem(value: reason, child: Text(reason));
              }).toList(),
              onChanged: (value) => setState(() => _selectedReason = value!),
            ),
            SizedBox(height: 16),
            // حقل نصي إضافي (للسبب الآخر)
            if (_selectedReason == 'سبب آخر')
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'تفاصيل إضافية',
                  hintText: 'اكتب سبب الإبلاغ بالتفصيل...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            SizedBox(height: 24),
            // زر إرسال البلاغ بنفس تصميم الأزرار في ViewOtherProfile
            ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _submitReport,
              icon: _isSubmitting ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2) : Icon(Icons.send),
              label: Text(_isSubmitting ? 'جاري الإرسال...' : 'إرسال البلاغ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                elevation: 5,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(1, 10),
                    topRight: Radius.elliptical(10, 1),
                    bottomLeft: Radius.elliptical(10, 1),
                    bottomRight: Radius.elliptical(1, 10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}