import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/controllers/admin_controllers/admin_users_controller.dart';

import '../../../utils/app_constants/colors_constant.dart';
import '../../widgets/custom_app_bar.dart';

class AddOverSeerPage extends StatelessWidget {
  final AdminUsersControllerImpl controller = Get.put(AdminUsersControllerImpl());
  AddOverSeerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(title: "إضافة مشرف",),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),
            // أيقونة ورئيسية
             Icon(Icons.admin_panel_settings, size: 60, color: AppColors.primaryAccent),
            const SizedBox(height: 10),
             Center(
              child: Text(
                "إضافة مشرف",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryAccent),
              ),
            ),
            const SizedBox(height: 30),
            // حقول الإدخال
            TextFormField(
              controller: controller.firstNameController,
              decoration: const InputDecoration(
                labelText: "الاسم الأول",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) => value == null || value.isEmpty ? "الاسم الأول مطلوب" : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: controller.fatherNameController,
              decoration: const InputDecoration(
                labelText: "اسم الأب",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) => value == null || value.isEmpty ? "اسم الأب مطلوب" : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: controller.lastNameController,
              decoration: const InputDecoration(
                labelText: "الكنية",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) => value == null || value.isEmpty ? "الكنية مطلوبة" : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "البريد الإلكتروني",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return "البريد الإلكتروني مطلوب";
                if (!value.contains('@')) return "أدخل بريداً إلكترونياً صحيحاً";
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: controller.passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "كلمة السر",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              validator: (value) => value == null || value.length < 6 ? "كلمة السر يجب أن تكون 6 أحرف على الأقل" : null,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                if (controller.formKey.currentState!.validate()) {
                  controller.addOverSeer();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text("إضافة المشرف", style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryAccent,
                foregroundColor: AppColors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}