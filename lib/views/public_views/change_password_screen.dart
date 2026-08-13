import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/views/widgets/custom_app_bar.dart';

import '../../controllers/public_controllers/public_controller.dart';
import '../../utils/app_constants/app_images_constant.dart';
import '../../utils/app_constants/colors_constant.dart';

class ChangePasswordScreen extends StatelessWidget {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final PublicController controller = Get.find(); // أو PublicController

  ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "تغيير كلمة المرور"),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.authBackground),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.linearToSrgbGamma(),
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {},
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              children: [
                // زر العودة
                
                // أيقونة القفل
                Center(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: AppColors.primary, blurRadius: 20, spreadRadius: 1)],
                      color: AppColors.white24,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                    child: Icon(Icons.lock_outline, color: AppColors.white, size: 60),
                  ),
                ),
                SizedBox(height: 20),
                // العنوان
                Center(
                  child: Text(
                    'تغيير كلمة المرور',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary, shadows: [Shadow(color: AppColors.white, blurRadius: 5)]),
                  ),
                ),
                SizedBox(height: 40),
                // حاوية النماذج
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white70,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(50, 10),
                      bottomLeft: Radius.elliptical(10, 50),
                      topRight: Radius.elliptical(10, 50),
                      bottomRight: Radius.elliptical(50, 10),
                    ),
                    border: Border.all(color: AppColors.primary, width: 1.5),
                    boxShadow: [BoxShadow(color: AppColors.black12, blurRadius: 8)],
                  ),
                  child: Column(
                    children: [
                      // حقل كلمة المرور القديمة
                      TextField(
                        controller: oldPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'كلمة المرور الحالية',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      SizedBox(height: 20),
                      // حقل كلمة المرور الجديدة
                      TextField(
                        controller: newPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'كلمة المرور الجديدة',
                          prefixIcon: Icon(Icons.lock_open),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      SizedBox(height: 20),
                      // حقل تأكيد كلمة المرور
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'تأكيد كلمة المرور الجديدة',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      SizedBox(height: 40),
                      // زر التغيير
                      ElevatedButton.icon(
                        onPressed: _changePassword,
                        icon: Icon(Icons.save),
                        label: Text('تغيير كلمة المرور', style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryAccent,
                          foregroundColor: AppColors.white,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
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
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changePassword() async {
    String oldPass = oldPasswordController.text.trim();
    String newPass = newPasswordController.text.trim();
    String confirmPass = confirmPasswordController.text.trim();

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar('خطأ', 'الرجاء ملء جميع الحقول');
      return;
    }
    if (newPass != confirmPass) {
      Get.snackbar('خطأ', 'كلمة المرور الجديدة وتأكيدها غير متطابقتين');
      return;
    }
    if (newPass.length < 6) {
      Get.snackbar('خطأ', 'كلمة المرور الجديدة يجب أن تكون 6 أحرف على الأقل');
      return;
    }

    // استدعاء دالة تغيير كلمة المرور من الـ Controller
    bool success = await controller.changePassword(oldPass, newPass);
    if (success) {
      Get.back(); // العودة للإعدادات
      Get.snackbar('نجاح', 'تم تغيير كلمة المرور بنجاح');
    } else {
      Get.snackbar('فشل', 'فشل تغيير كلمة المرور. تأكد من صحة الكلمة الحالية');
    }
  }
}