import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gr_flutter/utils/app_constants/app_theme_constants.dart';
import 'package:gr_flutter/views/widgets/auth_text_form_field.dart';

import '../../controllers/auth_controllers/auth_controller.dart';
import '../../utils/app_constants/colors_constant.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find();

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24,vertical: 30),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.92),
          borderRadius: AppThemeConstants.borderRadius,
          border: Border.all(color: AppColors.white, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Form(
          key: controller.loginFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthTextFormField(
                  label: "البريد الإلكتروني",
                  textEditingController: controller.loginEmailController,
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),
                AuthTextFormField(
                  label: "كلمة المرور",
                  textEditingController: controller.loginPasswordController,
                  isPassword: true,
                  icon: Icons.lock_outline,
                ),
                const SizedBox(height: 24),
                AnimatedContainer(
                  padding: EdgeInsets.all(10),
                  duration: const Duration(milliseconds: 300),
                  // width: double.infinity,
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary,strokeAlign: 10),
                    gradient: LinearGradient(
                      colors: [AppColors.primary700, AppColors.primary400],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(100, 10),
                      bottomLeft: Radius.elliptical(10, 100),
                      topRight: Radius.elliptical(10, 100),
                      bottomRight: Radius.elliptical(100, 10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary300.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () => controller.login(),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(100, 10),
                      bottomLeft: Radius.elliptical(10, 100),
                      topRight: Radius.elliptical(10, 100),
                      bottomRight: Radius.elliptical(100, 10),
                    ),
                    child: const Center(
                      child: Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}