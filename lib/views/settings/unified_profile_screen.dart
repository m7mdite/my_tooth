// views/settings/unified_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/utils/app_constants/app_constants.dart';
import 'package:gr_flutter/views/widgets/default_container_profile.dart';

import '../../controllers/all/unified_setting_controller.dart';
import '../../utils/app_constants/status_request.dart';
import 'unified_edit_profile_screen.dart';

class UnifiedProfileScreen extends StatelessWidget {
  final UnifiedSettingController controller = Get.find();

  UnifiedProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الملف الشخصي"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(onPressed: (){Get.to(() => UnifiedEditProfileScreen());}, icon: Icon(Icons.edit_note_sharp))
        ],
      ),
      body: Obx(() {
        if (controller.statusRequest.value == StatusRequest.loading) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: EdgeInsets.all(16),
          children: [
            // الصورة
            Center(
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: controller.profilePicture.value.isNotEmpty
                        ? NetworkImage("http://localhost:5000/${controller.profilePicture.value}")
                        : AssetImage(AppConstants.defaultBackgroundImage) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                controller.fullName.value,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(controller.getRoleTitle()),
              ),
            ),
            SizedBox(height: 24),
            // بيانات مشتركة
            _buildInfoTile(Icons.phone, "رقم الهاتف", controller.phoneNumber.value),
            if (controller.bio.value.isNotEmpty)
              _buildInfoTile(Icons.description, "نبذة", controller.bio.value),
            // بيانات المريض
            if (controller.role.value == 'patient') ...[
              _buildInfoTile(Icons.cake, "العمر", "${controller.age.value} سنة"),
              _buildInfoTile(Icons.people, "الجنس", controller.gender.value == 'male' ? 'ذكر' : 'أنثى'),
            ],
            // بيانات الطالب
            if (controller.role.value == 'student') ...[
              _buildInfoTile(Icons.numbers, "الرقم الجامعي", controller.universityNumber.value),
              _buildInfoTile(Icons.category, "الفئة", controller.category.value),
              _buildInfoTile(Icons.check_circle, "حالة التوثيق",
                  controller.authService.isVerified() == true ? "موثق" : "غير موثق"),
              _buildStatsRow(),
            ],
            // بيانات المشرف
            if (controller.role.value == 'overseer') ...[
              _buildStatsRow(),
            ],
            SizedBox(height: 40),
          ],
        );
      }),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(label),
        trailing: Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
        onTap: () => _copyToClipboard(value),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Text("الحالات المكتملة", style: TextStyle(color: Colors.green)),
                  SizedBox(height: 8),
                  Text(controller.completedCases.value.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Text("الحالات قيد المعالجة", style: TextStyle(color: Colors.orange)),
                  SizedBox(height: 8),
                  Text(controller.inProgressCases.value.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar('تم النسخ', 'تم نسخ النص بنجاح');
  }
}